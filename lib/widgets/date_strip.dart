import 'package:flutter/material.dart';

import '../theme.dart';

/// Deretan 7 hari (3 hari lalu, hari ini, 3 hari ke depan).
class DateStrip extends StatelessWidget {
  const DateStrip({super.key, required this.selected, required this.onSelect});

  final DateTime selected;
  final ValueChanged<DateTime> onSelect;

  /// Membuat 7 tombol hari; mengetuk salah satunya memanggil [onSelect].
  @override
  Widget build(BuildContext context) {
    final today = DateUtils.dateOnly(DateTime.now());

    return Row(
      children: [
        for (var i = -3; i <= 3; i++)
          Expanded(
            child: _DayPill(
              date: DateTime(today.year, today.month, today.day + i),
              isToday: i == 0,
              isPast: i < 0,
              isSelected: DateUtils.isSameDay(
                selected,
                DateTime(today.year, today.month, today.day + i),
              ),
              onTap: onSelect,
            ),
          ),
      ],
    );
  }
}

/// Satu tombol hari (tanggal + nama hari) di dalam [DateStrip].
class _DayPill extends StatelessWidget {
  const _DayPill({
    required this.date,
    required this.isToday,
    required this.isPast,
    required this.isSelected,
    required this.onTap,
  });

  final DateTime date;
  final bool isToday;
  final bool isPast;
  final bool isSelected;
  final ValueChanged<DateTime> onTap;

  /// Menggambar tombol hari dengan warna sesuai status
  /// (terpilih, sudah lewat, atau hari mendatang).
  @override
  Widget build(BuildContext context) {
    final Color background;
    final Color textColor;
    if (isSelected) {
      background = AppColors.orange;
      textColor = Colors.white;
    } else if (isPast) {
      background = const Color(0xFFEFEAE6);
      textColor = AppColors.textSoft;
    } else {
      background = Colors.white;
      textColor = AppColors.text;
    }

    return GestureDetector(
      onTap: () => onTap(date),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 3),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isToday && !isSelected ? AppColors.orange : AppColors.border,
            width: isToday && !isSelected ? 1.5 : 1,
          ),
          boxShadow: isSelected
              ? const [
                  BoxShadow(color: Color(0x40FF7A1A), blurRadius: 10, offset: Offset(0, 4)),
                ]
              : null,
        ),
        child: Column(
          children: [
            Text(
              '${date.day}',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              dayShort[date.weekday - 1],
              style: TextStyle(fontSize: 12, color: textColor),
            ),
          ],
        ),
      ),
    );
  }
}
