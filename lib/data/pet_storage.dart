import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/pet.dart';

/// C1/C2: menyimpan satu pet (nama + status) di perangkat.
/// Dipisah dari habit supaya pet tetap ada walau semua habit dihapus.
class PetStorage {
  static const _key = 'pet';

  static Future<Pet?> load() async {
    final prefs = await SharedPreferences.getInstance();
    final text = prefs.getString(_key);
    if (text == null) return null;

    try {
      return Pet.fromJson(jsonDecode(text) as Map<String, dynamic>);
    } catch (_) {
      return null; // data rusak -> pengguna diminta memberi nama lagi
    }
  }

  static Future<void> save(Pet pet) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(pet.toJson()));
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
