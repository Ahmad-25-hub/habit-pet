import 'package:flutter/material.dart';

/// Warna-warna utama aplikasi.
class AppColors {
  static const orange = Color(0xFFFF7A1A);
  static const orangeSoft = Color(0xFFFFEEE0);
  static const background = Color(0xFFFFF8F2);
  static const border = Color(0xFFF2E8DF);
  static const line = Color(0xFFE3DCD6);
  static const text = Color(0xFF2B2622);
  static const textSoft = Color(0xFF9A928B);
  static const green = Color(0xFF22A55B);

  /// Warna status pet (C2).
  static const pink = Color(0xFFF2709C);
  static const blue = Color(0xFF5B8DEF);
}

/// Pilihan ikon habit (file: `assets/images/habit_<nama>.png`).
const habitIcons = [
  'creativity',
  'healthy_meal',
  'hydration',
  'planning',
  'reading',
  'sleep',
  'workout',
];

/// Mengubah nama ikon menjadi path gambar asetnya.
String habitImage(String icon) => 'assets/images/habit_$icon.png';

/// Pilihan warna kartu habit (pastel).
const habitColors = [
  Color(0xFFFFE6D5), // peach
  Color(0xFFDDF4E6), // mint
  Color(0xFFDDEDFF), // biru langit
  Color(0xFFEDE5FF), // lavender
  Color(0xFFFFF3C7), // kuning
  Color(0xFFFFE0EA), // pink
];

const dayShort = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
const dayLong = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];
const monthShort = [
  'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
  'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
];

/// Teks jadwal, mis. "Setiap hari" atau "Sen, Rab, Jum".
String scheduleText(List<int> days) {
  if (days.length == 7) return 'Setiap hari';
  final sorted = [...days]..sort();
  return sorted.map((d) => dayShort[d - 1]).join(', ');
}
