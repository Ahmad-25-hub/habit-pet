import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/habit.dart';
import '../models/habit_stack.dart';

/// A5: menyimpan daftar habit di perangkat (shared_preferences)
/// dalam bentuk teks JSON, jadi data tetap ada saat aplikasi ditutup.
class HabitStorage {
  static const _key = 'habits';

  static Future<List<Habit>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final text = prefs.getString(_key);
    if (text == null) return [];

    try {
      final list = jsonDecode(text) as List;
      return list.map((item) => Habit.fromJson(item)).toList();
    } catch (_) {
      return []; // data rusak -> mulai dari kosong
    }
  }

  static Future<void> save(List<Habit> habits) async {
    final prefs = await SharedPreferences.getInstance();
    final text = jsonEncode(habits.map((h) => h.toJson()).toList());
    await prefs.setString(_key, text);
  }

  // ---- B1: stack disimpan dengan cara yang sama, di key terpisah ----

  static const _stackKey = 'stacks';

  static Future<List<HabitStack>> loadStacks() async {
    final prefs = await SharedPreferences.getInstance();
    final text = prefs.getString(_stackKey);
    if (text == null) return [];

    final list = jsonDecode(text) as List;
    return list.map((item) => HabitStack.fromJson(item)).toList();
  }

  static Future<void> saveStacks(List<HabitStack> stacks) async {
    final prefs = await SharedPreferences.getInstance();
    final text = jsonEncode(stacks.map((s) => s.toJson()).toList());
    await prefs.setString(_stackKey, text);
  }
}
