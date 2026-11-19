import 'package:flutter/material.dart';

import '../models/pet.dart';
import '../theme.dart';
import 'common.dart';

/// C2: ringkasan tiga status pet (Kenyang, Kebahagiaan, XP) di halaman utama.
class PetStatusCard extends StatelessWidget {
  const PetStatusCard({super.key, required this.pet, this.onTap});

  final Pet pet;

  /// Aksi saat kartu diketuk. Kalau kosong, tampilkan penjelasan status.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label:
          'Status ${pet.name}, level ${pet.level}, kenyang ${pet.fullness} persen, '
          'kebahagiaan ${pet.happiness} persen, ${pet.xp} XP. Ketuk untuk detail.',
      child: GestureDetector(
        onTap: onTap ?? () => showPetStatusSheet(context, pet),
        child: Container(
          padding: const EdgeInsets.fromLTRB(10, 10, 12, 12),
          decoration: BoxDecoration(
            color: AppColors.orangeSoft,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFFFDDC4)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              BlendImage(pet.image, background: AppColors.orangeSoft, size: 92),
              const SizedBox(width: 6),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            pet.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              color: AppColors.text,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        _LevelPill(level: pet.level),
                        const Spacer(),
                        const Icon(
                          Icons.info_outline_rounded,
                          size: 15,
                          color: AppColors.textSoft,
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${pet.levelTitle} · ${pet.moodLabel}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSoft,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _StatBar(
                      icon: Icons.restaurant_rounded,
                      label: 'Kenyang',
                      color: AppColors.orange,
                      value: pet.fullness / Pet.maxStatus,
                      text: '${pet.fullness}%',
                    ),
                    const SizedBox(height: 5),
                    _StatBar(
                      icon: Icons.favorite_rounded,
                      label: 'Bahagia',
                      color: AppColors.pink,
                      value: pet.happiness / Pet.maxStatus,
                      text: '${pet.happiness}%',
                    ),
                    const SizedBox(height: 5),
                    _StatBar(
                      icon: Icons.bolt_rounded,
                      label: 'XP',
                      color: AppColors.blue,
                      value: pet.levelProgress,
                      text: '${pet.xpInLevel}/${Pet.xpPerLevel}',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LevelPill extends StatelessWidget {
  const _LevelPill({required this.level});

  final int level;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.orange,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        'Lv. $level',
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _StatBar extends StatelessWidget {
  const _StatBar({
    required this.icon,
    required this.label,
    required this.color,
    required this.value,
    required this.text,
  });

  final IconData icon;
  final String label;
  final Color color;
  final double value;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 12, color: color),
        const SizedBox(width: 3),
        SizedBox(
          width: 50,
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: AppColors.textSoft,
            ),
          ),
        ),
        Expanded(
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: value.clamp(0.0, 1.0).toDouble()),
            duration: const Duration(milliseconds: 550),
            curve: Curves.easeOutCubic,
            builder: (context, animated, _) => ClipRRect(
              borderRadius: BorderRadius.circular(99),
              child: LinearProgressIndicator(
                value: animated,
                minHeight: 6,
                backgroundColor: Colors.white,
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
          ),
        ),
        const SizedBox(width: 5),
        SizedBox(
          width: 36,
          child: Text(
            text,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}

/// Penjelasan singkat aturan status pet (C2/C3) saat kartu diketuk.
void showPetStatusSheet(BuildContext context, Pet pet) {
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: AppColors.background,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (context) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.line,
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.orangeSoft,
                    ),
                    child: BlendImage(
                      pet.image,
                      background: AppColors.orangeSoft,
                      size: 76,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pet.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${pet.levelTitle} · Level ${pet.level} · ${pet.moodLabel}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSoft,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              const _InfoRow(
                icon: Icons.restaurant_rounded,
                color: AppColors.orange,
                title: 'Kenyang (HP)',
                text:
                    'Turun ${Pet.fullnessDecayPerDay} poin tiap hari. Setiap habit '
                    'selesai menambah ${Pet.habitFullness} poin (maksimal 100).',
              ),
              const SizedBox(height: 12),
              const _InfoRow(
                icon: Icons.favorite_rounded,
                color: AppColors.pink,
                title: 'Kebahagiaan',
                text:
                    'Turun ${Pet.happinessDecayPerDay} poin tiap hari. Menyelesaikan '
                    'satu stack lengkap menambah ${Pet.stackHappiness} poin.',
              ),
              const SizedBox(height: 12),
              const _InfoRow(
                icon: Icons.bolt_rounded,
                color: AppColors.blue,
                title: 'XP & Level',
                text:
                    'Setiap habit selesai memberi ${Pet.habitXp} XP, stack lengkap '
                    'bonus ${Pet.stackXp} XP. Pet naik level setiap ${Pet.xpPerLevel} XP.',
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.schedule_rounded,
                      size: 16,
                      color: AppColors.textSoft,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Penurunan status dihitung otomatis saat aplikasi '
                        'dibuka, berdasarkan jumlah hari sejak terakhir diperbarui.',
                        style: TextStyle(
                          fontSize: 11,
                          height: 1.45,
                          color: AppColors.textSoft,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.color,
    required this.title,
    required this.text,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 16, color: color),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                text,
                style: const TextStyle(
                  fontSize: 12,
                  height: 1.4,
                  color: AppColors.textSoft,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
