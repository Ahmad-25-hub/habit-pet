import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:habit_pet/data/habit_store.dart';
import 'package:habit_pet/data/pet_store.dart';
import 'package:habit_pet/models/habit.dart';
import 'package:habit_pet/models/pet.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Test HabitStore (check-in) dan PetStore (buat pet, hadiah, penurunan).
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Kosongkan penyimpanan tiruan sebelum setiap test.
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  /// Membuat satu habit contoh untuk dipakai di test.
  Habit sampleHabit() => const Habit(
    id: 'h1',
    name: 'Baca buku',
    icon: 'reading',
    color: 0xFFFFE6D5,
    days: [1, 2, 3, 4, 5, 6, 7],
  );

  group('A3 check-in', () {
    test('toggleDone menandai lalu membatalkan check-in', () async {
      final store = HabitStore();
      await store.load();
      await store.add(sampleHabit());

      final day = DateTime(2026, 11, 19);

      expect(store.habits.single.isDoneOn(day), isFalse);
      expect(await store.toggleDone('h1', day), isTrue);
      expect(store.habits.single.isDoneOn(day), isTrue);
      expect(store.habits.single.doneDates, ['2026-11-19']);

      expect(await store.toggleDone('h1', day), isFalse);
      expect(store.habits.single.isDoneOn(day), isFalse);
      expect(store.habits.single.doneDates, isEmpty);
    });

    test('check-in tersimpan ke penyimpanan lokal', () async {
      final store = HabitStore();
      await store.load();
      await store.add(sampleHabit());
      await store.toggleDone('h1', DateTime(2026, 11, 19));

      final reloaded = HabitStore();
      await reloaded.load();
      expect(reloaded.habits.single.isDoneOn(DateTime(2026, 11, 19)), isTrue);
    });

    test('id yang tidak dikenal tidak mengubah apa pun', () async {
      final store = HabitStore();
      await store.load();
      await store.add(sampleHabit());

      expect(
        await store.toggleDone('tidak-ada', DateTime(2026, 11, 19)),
        isFalse,
      );
      expect(store.habits.single.doneDates, isEmpty);
    });
  });

  group('C1/C2 pet', () {
    test('createPet menyimpan nama dan status awal', () async {
      final store = PetStore();
      await store.load();
      expect(store.hasPet, isFalse);

      await store.createPet('  Milo  ');
      expect(store.pet!.name, 'Milo');
      expect(store.pet!.fullness, Pet.initialFullness);
      expect(store.pet!.happiness, Pet.initialHappiness);
      expect(store.pet!.xp, 0);

      final reloaded = PetStore();
      await reloaded.load();
      expect(reloaded.pet!.name, 'Milo');
    });

    test('hadiah check-in menambah XP lalu undo mengembalikannya', () async {
      final store = PetStore();
      await store.load();
      await store.createPet('Milo');

      await store.completeHabit();
      expect(store.pet!.xp, Pet.habitXp);
      expect(store.pet!.fullness, Pet.initialFullness + Pet.habitFullness);

      await store.undoHabit();
      expect(store.pet!.xp, 0);
      expect(store.pet!.fullness, Pet.initialFullness);
    });

    test('status diturunkan saat data dimuat setelah beberapa hari', () async {
      final oldDate = DateTime.now().subtract(const Duration(days: 4));
      final saved = Pet(
        name: 'Milo',
        fullness: 90,
        happiness: 80,
        xp: 30,
        lastUpdated: oldDate,
      );
      SharedPreferences.setMockInitialValues({
        'pet': jsonEncode(saved.toJson()),
      });

      final store = PetStore();
      await store.load();

      expect(store.pet!.fullness, 90 - 4 * Pet.fullnessDecayPerDay);
      expect(store.pet!.happiness, 80 - 4 * Pet.happinessDecayPerDay);
    });
  });
}
