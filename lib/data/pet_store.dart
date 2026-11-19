import 'package:flutter/foundation.dart';

import '../models/pet.dart';
import 'pet_storage.dart';

/// C1/C2: tempat data pet. Layar mendengarkan perubahan lewat ListenableBuilder.
///
/// Status pet diturunkan sekali saat data dibuka (dan saat aplikasi kembali
/// aktif) berdasarkan jumlah hari sejak [Pet.lastUpdated].
class PetStore extends ChangeNotifier {
  Pet? pet;
  bool isLoading = true;

  /// True kalau pengguna sudah membuat (memberi nama) pet.
  bool get hasPet => pet != null;

  /// Memuat pet dari penyimpanan dan langsung menerapkan penurunan status
  /// sesuai hari yang terlewat.
  Future<void> load() async {
    final saved = await PetStorage.load();
    isLoading = false;

    if (saved != null) {
      final updated = saved.decayTo(DateTime.now());
      pet = updated;
      if (!identical(updated, saved)) {
        await PetStorage.save(updated);
      }
    }
    notifyListeners();
  }

  /// C1: dipanggil dari onboarding saat pengguna memberi nama pet.
  Future<void> createPet(String name) async {
    final newPet = Pet(
      name: name.trim(),
      fullness: Pet.initialFullness,
      happiness: Pet.initialHappiness,
      xp: 0,
      lastUpdated: DateTime.now(),
    );
    await _update(newPet);
  }

  /// C3: satu habit selesai -> +10 XP, +5 kenyang.
  Future<void> completeHabit() async {
    final current = pet;
    if (current == null) return;
    await _update(current.addHabitReward(DateTime.now()));
  }

  /// C3: stack selesai lengkap -> bonus +30 XP, +10 kebahagiaan.
  Future<void> completeStack() async {
    final current = pet;
    if (current == null) return;
    await _update(current.addStackBonus(DateTime.now()));
  }

  /// Check-in dibatalkan -> hadiahnya ikut ditarik kembali.
  Future<void> undoHabit() async {
    final current = pet;
    if (current == null) return;
    await _update(current.removeHabitReward());
  }

  /// Mengganti nama pet (diabaikan kalau kosong atau sama dengan nama lama).
  Future<void> rename(String newName) async {
    final current = pet;
    final name = newName.trim();
    if (current == null || name.isEmpty || name == current.name) return;
    await _update(current.rename(name));
  }

  /// Penurunan status kalau aplikasi dibuka lagi setelah beberapa hari.
  Future<void> refreshDecay() async {
    final current = pet;
    if (current == null) return;

    final updated = current.decayTo(DateTime.now());
    if (identical(updated, current)) return;

    pet = updated;
    notifyListeners();
    await PetStorage.save(updated);
  }

  /// Mengganti pet di memori, memberi tahu layar, lalu menyimpannya.
  Future<void> _update(Pet newPet) async {
    pet = newPet;
    notifyListeners();
    await PetStorage.save(newPet);
  }
}
