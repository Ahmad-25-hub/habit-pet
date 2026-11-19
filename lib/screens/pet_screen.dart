import 'package:flutter/material.dart';

import '../data/pet_store.dart';
import '../models/pet.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/pet_status_card.dart';

/// C4: halaman pet, menampilkan pet, status bar, dan level.
class PetScreen extends StatelessWidget {
  const PetScreen({super.key, required this.petStore});

  final PetStore petStore;

  /// Menyusun halaman pet: gambar & nama, kartu level/XP,
  /// bar kenyang & kebahagiaan, dan cara membuat pet tumbuh.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListenableBuilder(
          listenable: petStore,
          builder: (context, _) {
            final pet = petStore.pet!;

            return ListView(
              padding: const EdgeInsets.all(20),
              children: [
                PageHeader(
                  title: 'Halaman Pet',
                  // Tombol info: penjelasan aturan status (dari C2).
                  trailing: CircleButton(
                    icon: Icons.info_outline_rounded,
                    onTap: () => showPetStatusSheet(context, pet),
                  ),
                ),
                const SizedBox(height: 20),

                // Gambar pet besar + nama + suasana hati
                Center(
                  child: ClipOval(
                    child: BlendImage(pet.image, background: AppColors.orangeSoft, size: 220),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  pet.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
                ),
                Text(
                  '${pet.levelTitle} · ${pet.moodLabel}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.textSoft),
                ),
                const SizedBox(height: 20),

                // Level dan progres XP
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Level ${pet.level}',
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                          ),
                          const Spacer(),
                          Pill('Total ${pet.xp} XP'),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _Bar(value: pet.levelProgress, color: AppColors.blue),
                      const SizedBox(height: 8),
                      Text(
                        '${pet.xpInLevel} / ${Pet.xpPerLevel} XP · '
                        '${pet.xpToNextLevel} XP lagi ke level ${pet.level + 1}',
                        style: const TextStyle(fontSize: 12, color: AppColors.textSoft),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Status bar: Kenyang dan Kebahagiaan
                AppCard(
                  child: Column(
                    children: [
                      _StatusRow(
                        icon: Icons.restaurant_rounded,
                        label: 'Kenyang',
                        value: pet.fullness,
                        color: AppColors.orange,
                      ),
                      const SizedBox(height: 16),
                      _StatusRow(
                        icon: Icons.favorite_rounded,
                        label: 'Kebahagiaan',
                        value: pet.happiness,
                        color: AppColors.pink,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Cara membuat pet tumbuh (aturan C3)
                const AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Cara membuat pet tumbuh',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '• Habit selesai: +${Pet.habitXp} XP, +${Pet.habitFullness} kenyang\n'
                        '• Stack selesai lengkap: +${Pet.stackXp} XP, '
                        '+${Pet.stackHappiness} kebahagiaan',
                        style: TextStyle(color: AppColors.textSoft, height: 1.6),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// Satu baris status: ikon, nama, angka persen, dan bar.
class _StatusRow extends StatelessWidget {
  const _StatusRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final int value; // 0 - 100
  final Color color;

  /// Menampilkan ikon, label, persen, dan bar progres di bawahnya.
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 6),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
            const Spacer(),
            Text(
              '$value%',
              style: TextStyle(fontWeight: FontWeight.w700, color: color),
            ),
          ],
        ),
        const SizedBox(height: 8),
        _Bar(value: value / Pet.maxStatus, color: color),
      ],
    );
  }
}

/// Bar progres membulat.
class _Bar extends StatelessWidget {
  const _Bar({required this.value, required this.color});

  final double value; // 0.0 - 1.0
  final Color color;

  /// Menggambar bar progres dengan sudut membulat.
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(99),
      child: LinearProgressIndicator(
        value: value,
        minHeight: 10,
        color: color,
        backgroundColor: AppColors.background,
      ),
    );
  }
}
