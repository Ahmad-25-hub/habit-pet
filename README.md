# Habit Pet

Aplikasi mobile habit tracker berbasis Flutter dengan dua fitur unggulan:

- **Habit Stacking**: menyusun beberapa kebiasaan menjadi satu rutinitas berurutan.
- **Virtual Pet**: hewan peliharaan virtual yang tumbuh saat pengguna konsisten menjalankan habit.

Daftar fitur lengkap ada di `Daftar_Fitur_Habit_Tracker.md` (versi Word: `Daftar_Fitur_Habit_Tracker.docx`).
Panduan desain (warna, ukuran, komponen) ada di [`DESIGN.md`](DESIGN.md). Baca dulu sebelum membuat halaman baru.

## Status fitur

| Kode | Fitur | Status |
| --- | --- | --- |
| A1 | Kelola habit (tambah, edit, hapus) | Selesai |
| A2 | Daftar habit hari ini | Selesai |
| A3 | Check-in habit | Selesai |
| A4 | Streak | Selesai |
| A5/A7 | Penyimpanan lokal | Selesai |
| C1 | Beri nama pet (onboarding) | Selesai |
| C2 | Status pet (Kenyang, Kebahagiaan, XP) | Selesai |
| B1 | Buat stack (rantai) | Selesai |
| B2 | Mode jalankan stack | Selesai |
| C3 | Pet bereaksi ke habit (hadiah check-in + bonus stack) | Selesai |
| C4 | Halaman pet | Selesai |

## Cara menjalankan

```bash
flutter pub get
flutter run
```

Menjalankan semua tes: `flutter test`

## Fitur A3 — Check-in habit

- Ketuk kartu habit di halaman utama untuk menandai **selesai**.
- Ketuk lagi (atau tekan **Batalkan** pada snackbar) untuk membatalkan check-in.
- Tombol **Edit** kecil di kanan bawah kartu membuka form edit habit.
- Tanggal selesai disimpan di `Habit.doneDates` (format `yyyy-mm-dd`), jadi streak
  langsung terhitung ulang.
- Tanggal yang bisa dipilih adalah 3 hari ke belakang sampai 3 hari ke depan;
  check-in untuk tanggal yang akan datang ditolak.
- Check-in hari ini ikut memberi hadiah ke pet (+10 XP, +5 kenyang); kalau
  dibatalkan, hadiahnya ditarik kembali.

## Fitur C1 & C2 — Virtual Pet

- **C1:** saat aplikasi pertama kali dibuka, pengguna memberi nama pet pada layar
  onboarding (maksimal 18 karakter, ada pilihan nama cepat). Nama dan status pet
  disimpan terpisah dari habit di `shared_preferences` (key `pet`).
- **C2:** satu pet untuk seluruh aplikasi, dengan tiga status:
  - **Kenyang (HP)** 0–100, turun 12 poin per hari.
  - **Kebahagiaan** 0–100, turun 8 poin per hari.
  - **XP & Level**: naik level setiap 100 XP. Ada gelar dari "Rubah Kecil"
    sampai "Rubah Legenda".
- Status ditampilkan di kartu pet pada halaman utama. Ketuk kartu untuk melihat
  penjelasan aturan status.
- Penurunan status dihitung otomatis saat aplikasi dibuka (dan saat kembali dari
  latar belakang), berdasarkan jumlah hari sejak pembaruan terakhir.
- Gambar pet berganti antara `pet_happy.png` dan `pet_hungry_sad.png` sesuai
  kondisi kenyang & kebahagiaan.

## Fitur B1, B2, C3 & C4 — Habit Stacking dan Halaman Pet

- **B1:** tombol 🔗 di kanan atas halaman utama membuka daftar stack. Buat stack
  dengan nama (mis. "Rutinitas Pagi") lalu ketuk habit sesuai urutan yang
  diinginkan (minimal 2 habit). Ketuk kartu stack untuk edit, ikon tempat sampah
  untuk hapus. Disimpan di `shared_preferences` (key `stacks`). Habit yang dihapus
  otomatis keluar dari semua stack.
- **B2:** tombol ▶ pada kartu stack menjalankan stack langkah demi langkah.
  **Selesai** = check-in habit itu lalu otomatis lanjut ke habit berikutnya,
  **Lewati** = lanjut tanpa check-in.
- **C3:** kalau semua habit di stack selesai saat dijalankan, pet dapat bonus
  **+30 XP dan +10 kebahagiaan**. Stack yang sudah lengkap sebelum dijalankan
  tidak diberi bonus lagi (supaya tidak bisa diulang-ulang di hari yang sama).
- **C4:** ketuk kartu pet di halaman utama untuk membuka halaman pet: gambar
  pet, level + bar XP, bar Kenyang & Kebahagiaan, dan cara membuat pet tumbuh.
  Tombol ⓘ menampilkan penjelasan aturan status.

## Struktur kode

```
lib/
  main.dart                          # tema, memuat data, onboarding-first
  theme.dart                         # warna, ikon/warna habit, nama hari
  models/habit.dart                  # model Habit + hitung streak (A4)
  models/pet.dart                    # model Pet: status, level, decay, bonus (C2/C3)
  models/habit_stack.dart            # model HabitStack: nama + urutan habit (B1)
  data/habit_storage.dart            # simpan/baca habit & stack (A5/A7/B1)
  data/pet_storage.dart              # simpan/baca pet (C1/C2)
  data/habit_store.dart              # kelola habit, check-in, stack (A1/A3/B1)
  data/pet_store.dart                # kelola pet + hadiah habit & stack (C1/C2/C3)
  screens/home_screen.dart           # daftar habit hari ini + status pet (A2/C2)
  screens/pet_onboarding_screen.dart # onboarding beri nama pet (C1)
  screens/manage_habits_screen.dart  # daftar semua habit (A1)
  screens/habit_form_screen.dart     # form tambah/edit habit (A1)
  screens/stacks_screen.dart         # daftar stack (B1)
  screens/stack_form_screen.dart     # form buat/edit stack (B1)
  screens/run_stack_screen.dart      # jalankan stack langkah demi langkah (B2/C3)
  screens/pet_screen.dart            # halaman pet (C4)
  widgets/                           # kartu, tile habit, streak, status pet
```
