import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habit_pet/data/habit_store.dart';
import 'package:habit_pet/data/pet_store.dart';
import 'package:habit_pet/models/habit.dart';
import 'package:habit_pet/models/pet.dart';
import 'package:habit_pet/screens/home_screen.dart';
import 'package:habit_pet/screens/pet_onboarding_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Widget test onboarding pet dan check-in di halaman utama.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Kosongkan penyimpanan tiruan sebelum setiap test.
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('C1: onboarding menyimpan nama pet', (tester) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final petStore = PetStore();
    await petStore.load();

    await tester.pumpWidget(
      MaterialApp(home: PetOnboardingScreen(petStore: petStore)),
    );
    await tester.pumpAndSettle();

    expect(find.text('Kenalan dulu, yuk!'), findsOneWidget);
    expect(petStore.hasPet, isFalse);

    await tester.enterText(find.byType(TextField), 'Milo');
    await tester.pump();
    await tester.tap(find.text('Mulai Berteman'));
    await tester.pumpAndSettle();

    expect(petStore.pet!.name, 'Milo');
    expect(tester.takeException(), isNull);
  });

  testWidgets('A3/C2: home menampilkan pet dan check-in menambah XP', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final store = HabitStore();
    await store.load();
    await store.add(
      const Habit(
        id: 'h1',
        name: 'Minum air',
        icon: 'hydration',
        color: 0xFFFFE6D5,
        days: [1, 2, 3, 4, 5, 6, 7],
      ),
    );

    final petStore = PetStore();
    await petStore.load();
    await petStore.createPet('Milo');

    await tester.pumpWidget(
      MaterialApp(
        home: HomeScreen(store: store, petStore: petStore),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Milo'), findsOneWidget);
    expect(find.text('Kenyang'), findsOneWidget);
    expect(find.text('Bahagia'), findsOneWidget);
    expect(find.text('Minum air'), findsOneWidget);

    await tester.tap(find.text('Minum air'));
    await tester.pumpAndSettle();

    expect(store.habits.single.isDoneOn(DateTime.now()), isTrue);
    expect(petStore.pet!.xp, Pet.habitXp);
    expect(find.text('Selesai · ketuk untuk batal'), findsOneWidget);

    // Tunggu snackbar hilang supaya tidak ada timer yang menggantung.
    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('A3: check-in bisa dibatalkan', (tester) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final store = HabitStore();
    await store.load();
    final day = DateTime.now();
    await store.add(
      Habit(
        id: 'h1',
        name: 'Baca buku',
        icon: 'reading',
        color: 0xFFDDF4E6,
        days: const [1, 2, 3, 4, 5, 6, 7],
        doneDates: [dateKey(day)],
      ),
    );

    final petStore = PetStore();
    await petStore.load();
    await petStore.createPet('Milo');
    await petStore.completeHabit();

    await tester.pumpWidget(
      MaterialApp(
        home: HomeScreen(store: store, petStore: petStore),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Baca buku'));
    await tester.pumpAndSettle();

    expect(store.habits.single.isDoneOn(day), isFalse);
    expect(petStore.pet!.xp, 0);
    expect(find.text('Belum selesai · ketuk untuk check-in'), findsOneWidget);

    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
