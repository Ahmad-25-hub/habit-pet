import 'dart:math';

import 'package:flutter/foundation.dart';

import '../models/habit.dart';
import '../models/habit_stack.dart';
import 'habit_storage.dart';

/// Tempat semua data habit. Layar mendengarkan perubahan lewat
/// ListenableBuilder, dan setiap perubahan langsung disimpan (A5).
class HabitStore extends ChangeNotifier {
  List<Habit> habits = [];
  List<HabitStack> stacks = []; // B1
  bool isLoading = true;

  Future<void> load() async {
    habits = await HabitStorage.load();
    stacks = await HabitStorage.loadStacks();
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

    // B1: habit yang dihapus juga dikeluarkan dari semua stack.
    stacks = [
      for (final s in stacks)
        HabitStack(
          id: s.id,
          name: s.name,
          habitIds: s.habitIds.where((h) => h != id).toList(),
        ),
    ];
    await _saveStacks();
    await _save();
  }

  // ---- B1: tambah, edit, hapus stack ----

  /// Habit di dalam stack, sesuai urutan rutinitas.
  List<Habit> habitsInStack(HabitStack stack) => [
        for (final id in stack.habitIds) ...habits.where((h) => h.id == id),
      ];

  Future<void> addStack(HabitStack stack) async {
    stacks.add(stack);
    await _saveStacks();
  }

  Future<void> updateStack(HabitStack stack) async {
    final index = stacks.indexWhere((s) => s.id == stack.id);
    if (index != -1) stacks[index] = stack;
    await _saveStacks();
  }

  Future<void> deleteStack(String id) async {
    stacks.removeWhere((s) => s.id == id);
    await _saveStacks();
  }

  Future<void> _saveStacks() async {
    notifyListeners();
    await HabitStorage.saveStacks(stacks);
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
