import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habit_pet/data/habit_store.dart';
import 'package:habit_pet/data/pet_store.dart';
import 'package:habit_pet/models/habit.dart';
import 'package:habit_pet/models/habit_stack.dart';
import 'package:habit_pet/models/pet.dart';
import 'package:habit_pet/screens/pet_screen.dart';
import 'package:habit_pet/screens/run_stack_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Habit habit(String id, String name) => Habit(
        id: id,
        name: name,
        icon: 'reading',
        color: 0xFFFFE6D5,
        days: const [1, 2, 3, 4, 5, 6, 7],
      );

  const pagi = HabitStack(id: 's1', name: 'Rutinitas Pagi', habitIds: ['h1', 'h2']);

  /// Siapkan 2 habit, 1 stack, pet bernama Milo, lalu buka layar jalankan stack.
  Future<(HabitStore, PetStore)> openRun(WidgetTester tester) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final store = HabitStore();
    await store.load();
    await store.add(habit('h1', 'Minum air'));
    await store.add(habit('h2', 'Olahraga'));
    await store.addStack(pagi);

    final petStore = PetStore();
    await petStore.load();
    await petStore.createPet('Milo');

    await tester.pumpWidget(MaterialApp(
      home: RunStackScreen(store: store, petStore: petStore, stack: pagi),
    ));
    await tester.pumpAndSettle();
    return (store, petStore);
  }

  test('C3: bonus stack menambah XP dan kebahagiaan', () {
    final pet = Pet(
      name: 'Milo',
      fullness: 70,
      happiness: 95,
      xp: 0,
      lastUpdated: DateTime(2026, 11, 19),
    );
    final after = pet.addStackBonus(DateTime(2026, 11, 19));

    expect(after.xp, Pet.stackXp);
    expect(after.happiness, 100); // maksimal 100
  });

  testWidgets('B2/C3: jalankan stack sampai habis memberi bonus', (tester) async {
    final (store, petStore) = await openRun(tester);

    expect(find.text('Langkah 1 dari 2'), findsOneWidget);
    expect(find.text('Minum air'), findsOneWidget);

    await tester.tap(find.text('Selesai'));
    await tester.pumpAndSettle();

    // Otomatis lanjut ke habit berikutnya.
    expect(find.text('Langkah 2 dari 2'), findsOneWidget);
    expect(find.text('Olahraga'), findsOneWidget);

    await tester.tap(find.text('Selesai'));
    await tester.pumpAndSettle();

    expect(find.text('Rutinitas Selesai!'), findsOneWidget);
    expect(store.habits.every((h) => h.isDoneOn(DateTime.now())), isTrue);
    expect(petStore.pet!.xp, 2 * Pet.habitXp + Pet.stackXp);
    expect(petStore.pet!.happiness, Pet.initialHappiness + Pet.stackHappiness);
  });

  testWidgets('B2: habit yang dilewati membuat bonus tidak diberikan', (tester) async {
    final (store, petStore) = await openRun(tester);

    await tester.tap(find.text('Lewati'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Selesai'));
    await tester.pumpAndSettle();

    expect(find.textContaining('dilewati'), findsOneWidget);
    expect(store.habits.first.isDoneOn(DateTime.now()), isFalse);
    expect(petStore.pet!.xp, Pet.habitXp); // hanya 1 habit, tanpa bonus
  });

  testWidgets('C4: halaman pet menampilkan level dan status', (tester) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final petStore = PetStore();
    await petStore.load();
    await petStore.createPet('Milo');

    await tester.pumpWidget(MaterialApp(home: PetScreen(petStore: petStore)));
    await tester.pumpAndSettle();

    expect(find.text('Milo'), findsOneWidget);
    expect(find.text('Level 1'), findsOneWidget);
    expect(find.text('Kenyang'), findsOneWidget);
    expect(find.text('Kebahagiaan'), findsOneWidget);
  });
}
