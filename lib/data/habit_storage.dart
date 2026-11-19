import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/habit.dart';
import '../models/habit_stack.dart';

/// A5: menyimpan daftar habit di perangkat (shared_preferences)
/// dalam bentuk teks JSON, jadi data tetap ada saat aplikasi ditutup.
class HabitStorage {
  static const _key = 'habits';

  /// Membaca daftar habit dari penyimpanan; kosong kalau belum ada/rusak.
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

  /// Menyimpan seluruh daftar habit sebagai teks JSON.
  static Future<void> save(List<Habit> habits) async {
    final prefs = await SharedPreferences.getInstance();
    final text = jsonEncode(habits.map((h) => h.toJson()).toList());
    await prefs.setString(_key, text);
  }

  // ---- B1: stack disimpan dengan cara yang sama, di key terpisah ----

  static const _stackKey = 'stacks';

  /// Membaca daftar stack dari penyimpanan; kosong kalau belum ada.
  static Future<List<HabitStack>> loadStacks() async {
    final prefs = await SharedPreferences.getInstance();
    final text = prefs.getString(_stackKey);
    if (text == null) return [];

    final list = jsonDecode(text) as List;
    return list.map((item) => HabitStack.fromJson(item)).toList();
  }

  /// Menyimpan seluruh daftar stack sebagai teks JSON.
  static Future<void> saveStacks(List<HabitStack> stacks) async {
    final prefs = await SharedPreferences.getInstance();
    final text = jsonEncode(stacks.map((s) => s.toJson()).toList());
    await prefs.setString(_stackKey, text);
  }
}
