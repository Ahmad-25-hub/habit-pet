import 'dart:math';

import 'package:flutter/foundation.dart';

import '../models/habit.dart';
import 'habit_storage.dart';

/// Tempat semua data habit. Layar mendengarkan perubahan lewat
/// ListenableBuilder, dan setiap perubahan langsung disimpan (A5).
class HabitStore extends ChangeNotifier {
  List<Habit> habits = [];
  bool isLoading = true;

  Future<void> load() async {
    habits = await HabitStorage.load();
    isLoading = false;
    notifyListeners();
  }

  /// A2: habit yang dijadwalkan pada tanggal tertentu.
  List<Habit> habitsOn(DateTime date) =>
      habits.where((h) => h.isScheduledOn(date)).toList();

  /// A4: streak tertinggi dari semua habit.
  int get bestStreak => habits.fold(0, (best, h) => max(best, h.streak()));

  // ---- A1: tambah, edit, hapus ----

  Future<void> add(Habit habit) async {
    habits.add(habit);
    await _save();
  }

  Future<void> update(Habit habit) async {
    final index = habits.indexWhere((h) => h.id == habit.id);
    if (index != -1) habits[index] = habit;
    await _save();
  }

  Future<void> delete(String id) async {
    habits.removeWhere((h) => h.id == id);
    await _save();
  }

  // ---- A3: check-in / batalkan check-in ----

  /// Menandai habit selesai pada [date], atau membatalkannya kalau tanggal
  /// tersebut sudah tercatat. Mengembalikan status selesai yang baru.
  Future<bool> toggleDone(String id, DateTime date) async {
    final index = habits.indexWhere((h) => h.id == id);
    if (index == -1) return false;

    final habit = habits[index];
    final key = dateKey(date);
    final dates = [...habit.doneDates];
    final nowDone = !dates.contains(key);

    if (nowDone) {
      dates.add(key);
      dates.sort();
    } else {
      dates.remove(key);
    }

    habits[index] = habit.copyWith(doneDates: dates);
    await _save();
    return nowDone;
  }

  Future<void> _save() async {
    notifyListeners();
    await HabitStorage.save(habits);
  }
}
