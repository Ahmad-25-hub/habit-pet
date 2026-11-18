import 'package:flutter/material.dart';

import '../theme.dart';
import 'common.dart';

/// A4: banner streak terbaik di halaman utama.
class StreakBanner extends StatelessWidget {
  const StreakBanner({super.key, required this.streak});

  final int streak;

  @override
  Widget build(BuildContext context) {
    final hasStreak = streak > 0;

    return Container(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
      decoration: BoxDecoration(
        color: AppColors.orangeSoft,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFFDDC4)),
      ),
      child: Row(
        children: [
          const BlendImage(
            'assets/images/streak_celebration_stars.png',
            background: AppColors.orangeSoft,
            size: 84,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hasStreak ? '$streak Hari Berturut-turut!' : 'Ayo Mulai Streak!',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    fontStyle: FontStyle.italic,
                    color: AppColors.orange,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  hasStreak
                      ? 'Streak terbaik dari habit-habitmu. Pertahankan!'
                      : 'Selesaikan habit setiap hari supaya apimu terus menyala.',
                  style: const TextStyle(fontSize: 13, color: AppColors.textSoft),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
