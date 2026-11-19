import 'package:flutter_test/flutter_test.dart';
import 'package:habit_pet/models/pet.dart';

void main() {
  final today = DateTime(2026, 11, 19);

  Pet pet({
    String name = 'Milo',
    int fullness = 70,
    int happiness = 70,
    int xp = 0,
    DateTime? updated,
  }) {
    return Pet(
      name: name,
      fullness: fullness,
      happiness: happiness,
      xp: xp,
      lastUpdated: updated ?? today,
    );
  }

  test('level naik setiap 100 XP', () {
    expect(pet(xp: 0).level, 1);
    expect(pet(xp: 99).level, 1);
    expect(pet(xp: 100).level, 2);
    expect(pet(xp: 250).level, 3);
  });

  test('progres XP menuju level berikutnya', () {
    final p = pet(xp: 130);
    expect(p.level, 2);
    expect(p.xpInLevel, 30);
    expect(p.xpToNextLevel, 70);
    expect(p.levelProgress, closeTo(0.3, 0.0001));
  });

  test('status turun sesuai jumlah hari sejak pembaruan terakhir', () {
    final p = pet(fullness: 80, happiness: 60, updated: DateTime(2026, 11, 16));
    final decayed = p.decayTo(today); // 3 hari

    expect(decayed.fullness, 80 - 3 * Pet.fullnessDecayPerDay);
    expect(decayed.happiness, 60 - 3 * Pet.happinessDecayPerDay);
    expect(decayed.lastUpdated, DateTime(2026, 11, 19));
  });

  test('status tidak turun pada hari yang sama', () {
    final p = pet(updated: DateTime(2026, 11, 19, 6));
    expect(identical(p.decayTo(today), p), isTrue);
    expect(p.decayTo(today).fullness, p.fullness);
  });

  test('status tidak pernah di bawah 0', () {
    final p = pet(fullness: 10, happiness: 5, updated: DateTime(2026, 10, 1));
    final decayed = p.decayTo(today);
    expect(decayed.fullness, 0);
    expect(decayed.happiness, 0);
  });

  test('hadiah habit menambah XP + kenyang dan dibatasi 100', () {
    final p = pet(fullness: 98, xp: 95).addHabitReward(today);
    expect(p.fullness, Pet.maxStatus);
    expect(p.xp, 105);
    expect(p.level, 2);
  });

  test('undo hadiah tidak membuat nilai negatif', () {
    final p = pet(fullness: 3, xp: 5).removeHabitReward();
    expect(p.fullness, 0);
    expect(p.xp, 0);
  });

  test('gambar dan mood berubah saat pet lapar', () {
    expect(pet(fullness: 80, happiness: 80).isHappy, isTrue);
    expect(pet(fullness: 80, happiness: 80).image, contains('pet_happy'));

    final hungry = pet(fullness: 10, happiness: 80);
    expect(hungry.isHappy, isFalse);
    expect(hungry.moodLabel, 'Lapar & sedih');
    expect(hungry.image, contains('pet_hungry_sad'));
  });

  test('toJson -> fromJson menghasilkan data yang sama', () {
    final p = pet(fullness: 42, happiness: 55, xp: 230);
    final copy = Pet.fromJson(p.toJson());

    expect(copy.name, p.name);
    expect(copy.fullness, p.fullness);
    expect(copy.happiness, p.happiness);
    expect(copy.xp, p.xp);
    expect(copy.lastUpdated, p.lastUpdated);
  });

  test('rename hanya mengganti nama', () {
    final p = pet().rename('Coco');
    expect(p.name, 'Coco');
    expect(p.xp, 0);
    expect(p.fullness, Pet.initialFullness);
  });
}
