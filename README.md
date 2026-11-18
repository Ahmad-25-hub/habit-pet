# Habit Pet

Aplikasi mobile habit tracker berbasis Flutter dengan dua fitur unggulan:

- **Habit Stacking**: menyusun beberapa kebiasaan menjadi satu rutinitas berurutan.
- **Virtual Pet**: hewan peliharaan virtual yang tumbuh saat pengguna konsisten menjalankan habit.

Daftar fitur lengkap ada di `Daftar_Fitur_Habit_Tracker.docx`.

## Cara menjalankan

```bash
flutter pub get
flutter run
```

Tes logika streak: `flutter test`

## Struktur kode

```
lib/
  main.dart                     # tema & titik awal aplikasi
  theme.dart                    # warna, pilihan ikon/warna habit, nama hari
  models/habit.dart             # model Habit + hitung streak (A4)
  data/habit_storage.dart       # simpan/baca dari perangkat (A5)
  data/habit_store.dart         # tambah/edit/hapus habit (A1)
  screens/home_screen.dart      # daftar habit hari ini (A2)
  screens/manage_habits_screen.dart  # daftar semua habit (A1)
  screens/habit_form_screen.dart     # form tambah/edit habit (A1)
  widgets/                      # komponen tampilan (kartu, streak banner, dll)
```

Catatan untuk A3 (check-in): data tanggal selesai disimpan di `Habit.doneDates`
(format `yyyy-mm-dd`). Cukup tambahkan fungsi untuk menambah/menghapus tanggal
hari ini di `HabitStore`, lalu streak akan terhitung otomatis.
