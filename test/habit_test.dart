import 'package:flutter_test/flutter_test.dart';
import 'package:habit_pet/models/habit.dart';

void main() {
  final today = DateTime(2026, 11, 18); // Rabu

  Habit habit({List<int> days = const [1, 2, 3, 4, 5, 6, 7], required List<String> done}) {
    return Habit(id: '1', name: 'Tes', icon: 'reading', color: 0xFFFFFFFF, days: days, doneDates: done);
  }

  test('streak menghitung hari berturut-turut sampai hari ini', () {
    final h = habit(done: ['2026-11-16', '2026-11-17', '2026-11-18']);
    expect(h.streak(today), 3);
  });

  test('hari ini belum selesai tidak memutus streak kemarin', () {
    final h = habit(done: ['2026-11-16', '2026-11-17']);
    expect(h.streak(today), 2);
  });

  test('hari yang terlewat memutus streak', () {
    final h = habit(done: ['2026-11-14', '2026-11-15', '2026-11-17']);
    expect(h.streak(today), 1);
  });

  test('hari yang tidak terjadwal dilewati', () {
    expect(today.weekday, DateTime.wednesday);
    // Jadwal Sen, Rab, Jum. Selesai: Rab 18, Sen 16, Jum 13. Rab 11 terlewat.
    final h = habit(days: [1, 3, 5], done: ['2026-11-13', '2026-11-16', '2026-11-18']);
    expect(h.streak(today), 3);
  });

  test('tanpa riwayat, streak = 0', () {
    expect(habit(done: []).streak(today), 0);
  });

  test('toJson -> fromJson menghasilkan data yang sama', () {
    final h = habit(days: [2, 4], done: ['2026-11-17']);
    final copy = Habit.fromJson(h.toJson());
    expect(copy.name, h.name);
    expect(copy.days, h.days);
    expect(copy.doneDates, h.doneDates);
    expect(copy.color, h.color);
  });
}
