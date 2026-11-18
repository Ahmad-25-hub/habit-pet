import 'package:flutter/material.dart';

import '../models/habit.dart';
import '../theme.dart';
import 'common.dart';

/// Satu baris habit di halaman utama, lengkap dengan garis timeline di kiri.
class HabitTile extends StatelessWidget {
  const HabitTile({
    super.key,
    required this.habit,
    required this.date,
    required this.onTap,
    this.isFirst = false,
    this.isLast = false,
  });

  final Habit habit;
  final DateTime date;
  final VoidCallback onTap;
  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final done = habit.isDoneOn(date);
    final color = Color(habit.color);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Garis timeline + titik
          SizedBox(
            width: 16,
            child: Column(
              children: [
                Expanded(child: _line(visible: !isFirst)),
                Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: done ? AppColors.orange : Colors.white,
                    border: Border.all(
                      color: done ? AppColors.orange : AppColors.line,
                      width: 2.5,
                    ),
                  ),
                ),
                Expanded(child: _line(visible: !isLast)),
              ],
            ),
          ),
          const SizedBox(width: 10),

          // Kartu habit
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: GestureDetector(
                onTap: onTap,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(14, 12, 6, 12),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              habit.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: AppColors.text,
                              ),
                            ),
                            const SizedBox(height: 6),
                            _Status(done: done),
                            const SizedBox(height: 4),
                            StreakLabel(habit.streak()),
                          ],
                        ),
                      ),
                      BlendImage(habitImage(habit.icon), background: color, size: 76),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _line({required bool visible}) {
    return Center(
      child: Container(width: 2, color: visible ? AppColors.line : Colors.transparent),
    );
  }
}

/// Status selesai / belum (hanya tampilan; check-in dibuat di fitur A3).
class _Status extends StatelessWidget {
  const _Status({required this.done});

  final bool done;

  @override
  Widget build(BuildContext context) {
    final color = done ? AppColors.green : AppColors.textSoft;
    return Row(
      children: [
        Icon(
          done ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
          size: 16,
          color: color,
        ),
        const SizedBox(width: 4),
        Text(
          done ? 'Selesai' : 'Belum selesai',
          style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
