import 'package:flutter/material.dart';

import '../models/habit.dart';
import '../theme.dart';
import 'common.dart';

/// Satu baris habit di halaman utama, lengkap dengan garis timeline di kiri.
///
/// A3: mengetuk kartu menandai habit selesai / membatalkannya. Tombol "Edit"
/// kecil di kanan bawah membuka form edit.
class HabitTile extends StatelessWidget {
  const HabitTile({
    super.key,
    required this.habit,
    required this.date,
    required this.onCheckIn,
    required this.onEdit,
    this.isFirst = false,
    this.isLast = false,
  });

  final Habit habit;
  final DateTime date;
  final VoidCallback onCheckIn;
  final VoidCallback onEdit;
  final bool isFirst;
  final bool isLast;

  /// Menyusun garis timeline, kartu habit, status, streak, dan tombol Edit.
  @override
  Widget build(BuildContext context) {
    final done = habit.isDoneOn(date);
    final color = Color(habit.color);
    final cardColor = done
        ? Color.alphaBlend(Colors.white.withValues(alpha: 0.45), color)
        : color;
    final borderColor = done
        ? AppColors.green.withValues(alpha: 0.55)
        : Colors.transparent;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Garis timeline + titik status
          SizedBox(
            width: 16,
            child: Column(
              children: [
                Expanded(child: _line(visible: !isFirst)),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  width: 15,
                  height: 15,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: done ? AppColors.green : Colors.white,
                    border: Border.all(
                      color: done ? AppColors.green : AppColors.line,
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
              child: Semantics(
                button: true,
                label: done
                    ? '${habit.name}, selesai. Ketuk untuk membatalkan check-in.'
                    : '${habit.name}, belum selesai. Ketuk untuk check-in.',
                child: GestureDetector(
                  onTap: onCheckIn,
                  behavior: HitTestBehavior.opaque,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOut,
                    padding: const EdgeInsets.fromLTRB(14, 10, 10, 10),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: borderColor, width: 1.5),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
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
                        const SizedBox(width: 4),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Stack(
                              clipBehavior: Clip.none,
                              children: [
                                BlendImage(
                                  habitImage(habit.icon),
                                  background: cardColor,
                                  size: 70,
                                ),
                                if (done)
                                  Positioned(
                                    top: -2,
                                    right: -2,
                                    child: Container(
                                      padding: const EdgeInsets.all(3),
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColors.green,
                                      ),
                                      child: const Icon(
                                        Icons.check_rounded,
                                        size: 12,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            _EditButton(onTap: onEdit),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Membuat potongan garis timeline vertikal (transparan kalau disembunyikan).
  Widget _line({required bool visible}) {
    return Center(
      child: Container(
        width: 2,
        color: visible ? AppColors.line : Colors.transparent,
      ),
    );
  }
}

/// Status selesai / belum selesai + petunjuk singkat A3.
class _Status extends StatelessWidget {
  const _Status({required this.done});

  final bool done;

  /// Menampilkan ikon dan teks status selesai / belum selesai.
  @override
  Widget build(BuildContext context) {
    final color = done ? AppColors.green : AppColors.textSoft;
    return Row(
      children: [
        Icon(
          done
              ? Icons.check_circle_rounded
              : Icons.radio_button_unchecked_rounded,
          size: 16,
          color: color,
        ),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            done
                ? 'Selesai · ketuk untuk batal'
                : 'Belum selesai · ketuk untuk check-in',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

/// Tombol kecil untuk membuka form edit habit.
class _EditButton extends StatelessWidget {
  const _EditButton({required this.onTap});

  final VoidCallback onTap;

  /// Menggambar tombol kecil "Edit" yang memanggil [onTap].
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.7),
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.edit_rounded, size: 11, color: AppColors.textSoft),
              SizedBox(width: 3),
              Text(
                'Edit',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSoft,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
