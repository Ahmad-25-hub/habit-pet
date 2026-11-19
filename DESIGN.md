# Panduan Desain Habit Pet

Panduan ini supaya semua halaman terlihat **satu gaya**, walaupun dikerjakan orang yang berbeda.
Gayanya: **Friendly & Aesthetic**: warna hangat (oranye + krem), sudut membulat, kartu putih,
dan ilustrasi lucu.

> Aturan utama: **jangan menulis warna atau ukuran sendiri.** Pakai yang sudah ada di
> `lib/theme.dart` dan komponen di `lib/widgets/common.dart`.

---

## 1. Warna

Semua warna ada di `AppColors` (`lib/theme.dart`).

| Nama | Hex | Dipakai untuk |
|---|---|---|
| `AppColors.orange` | `#FF7A1A` | Warna utama: tombol, item terpilih, ikon aksi, angka streak |
| `AppColors.orangeSoft` | `#FFEEE0` | Latar lembut: label pil, kotak ikon, banner streak |
| `AppColors.background` | `#FFF8F2` | Latar semua halaman (krem), isi kolom input |
| `Colors.white` | `#FFFFFF` | Latar kartu |
| `AppColors.border` | `#F2E8DF` | Garis tepi kartu dan tombol bulat |
| `AppColors.line` | `#E3DCD6` | Garis timeline, tepi pilihan yang tidak aktif |
| `AppColors.text` | `#2B2622` | Teks utama |
| `AppColors.textSoft` | `#9A928B` | Teks keterangan, status "belum", ikon pasif |
| `AppColors.green` | `#22A55B` | Status selesai |

**Arti warna** (jangan ditukar):
- Oranye = aksi / aktif / streak
- Hijau = selesai
- Abu-abu (`textSoft`) = belum / tidak aktif
- Merah (`Colors.redAccent`) = hanya untuk tombol hapus

### Warna kartu habit (pastel)

Pilihan warna habit ada di `habitColors`. Warna ini dipakai sebagai **latar kartu habit**, bukan untuk teks.

| Warna | Hex |
|---|---|
| Peach | `#FFE6D5` |
| Mint | `#DDF4E6` |
| Biru langit | `#DDEDFF` |
| Lavender | `#EDE5FF` |
| Kuning | `#FFF3C7` |
| Pink | `#FFE0EA` |

Cara pakai warna dari data habit: `Color(habit.color)`.

---

## 2. Tipografi

Font bawaan Flutter (Roboto di Android). Tidak perlu menambah font.

| Peran | Ukuran | Ketebalan | Contoh |
|---|---|---|---|
| Judul besar halaman utama | 24 | `w800` | "Habit Pet" |
| Judul halaman / judul kartu | 18 | `w700` | "Kelola Habit", "Habit Hari Ini" |
| Judul item / bagian form | 15 | `w700` | Nama habit, "Pilih Warna" |
| Teks biasa | 14 | normal | Sapaan, keterangan |
| Keterangan kecil | 12–13 | `w500`–`w600` | "Belum selesai", "3 hari streak" |
| Teks tombol utama | 16 | `w700` | "Simpan Habit" |
| Teks perayaan | 18 | `w800` + *italic*, oranye | "3 Hari Berturut-turut!" |

Teks yang bisa panjang (nama habit) **wajib** diberi `maxLines` dan `overflow: TextOverflow.ellipsis`.

---

## 3. Jarak & Sudut

Gunakan kelipatan ini saja: **4, 8, 12, 16, 20**.

| Hal | Nilai |
|---|---|
| Padding tepi halaman | `20` |
| Jarak antar bagian besar | `20` |
| Jarak antar kartu dalam daftar | `12`–`14` |
| Padding dalam kartu | `16` (kartu kecil: `12`) |
| Sudut kartu (`AppCard`) | `20` |
| Sudut kartu habit, tombol utama | `16` |
| Sudut input & pilihan | `14` |
| Pil / label | bulat penuh (`20`–`30`) |
| Tinggi tombol utama | `54` |
| Ukuran tombol bulat (`CircleButton`) | `40` |
| Ukuran pilihan bulat (hari, warna) | `38` |

Bayangan kartu sangat tipis: hitam 5% (`0x0D000000`), blur 12, turun 4px. Sudah otomatis lewat `AppCard`.

---

## 4. Komponen siap pakai

Semua ada di `lib/widgets/`. **Pakai ini dulu sebelum membuat komponen baru.**

### `AppCard`: kartu putih standar
```dart
AppCard(
  child: Text('Isi kartu'),
)
```

### `PageHeader`: header halaman (tombol kembali + judul di tengah)
```dart
PageHeader(
  title: 'Halaman Pet',
  trailing: CircleButton(icon: Icons.add_rounded, onTap: () {}), // opsional
)
```

### `CircleButton`: tombol bulat kecil (kembali, panah, tambah)
```dart
CircleButton(icon: Icons.arrow_forward_rounded, onTap: () {})
```

### `Pill`: label kecil oranye
```dart
Pill('3 habit')
Pill('+120 XP')
```

### `StreakLabel`: ikon api + jumlah hari
```dart
StreakLabel(habit.streak())
```

### `BlendImage`: ilustrasi yang menyatu dengan latar (lihat bagian 5)
```dart
BlendImage('assets/images/pet_happy.png', background: Colors.white, size: 120)
```

### `EmptyHabits`: tampilan kosong (rubah + tombol)
```dart
EmptyHabits(message: 'Belum ada stack.', onAdd: () {})
```

### Komponen lain
| Komponen | File | Fungsi |
|---|---|---|
| `StreakBanner` | `widgets/streak_banner.dart` | Banner streak dengan gambar bintang |
| `DateStrip` | `widgets/date_strip.dart` | Deretan 7 tanggal yang bisa dipilih |
| `HabitTile` | `widgets/habit_tile.dart` | Kartu habit dengan garis timeline di kiri |

### Tombol
| Jenis | Cara |
|---|---|
| Tombol utama (lebar penuh, bawah layar) | `FilledButton` tinggi 54, sudut 16 (contoh di `habit_form_screen.dart`) |
| Tombol utama kecil | `FilledButton.icon(...)` (otomatis oranye dari tema) |
| Tombol bulat | `CircleButton` |
| Tambah dari halaman utama | `FloatingActionButton.extended` (otomatis oranye) |
| Hapus | `FilledButton` dengan `backgroundColor: Colors.redAccent`, selalu pakai dialog konfirmasi |

### Ikon
Pakai ikon Material versi **rounded**, misalnya `Icons.add_rounded`, `Icons.edit_rounded`,
`Icons.local_fire_department_rounded`. Jangan pakai versi biasa atau outlined supaya bentuknya seragam.

---

## 5. Ilustrasi & Gambar

Semua gambar ada di `assets/images/` (sudah terdaftar di `pubspec.yaml`).

| File | Untuk |
|---|---|
| `habit_*.png` (7 buah) | Ikon habit: creativity, healthy_meal, hydration, planning, reading, sleep, workout |
| `pet_happy.png` | Pet senang, tampilan kosong, layar sukses |
| `pet_hungry_sad.png` | Pet lapar/sedih (C2) |
| `streak_celebration_stars.png` | Perayaan streak / stack selesai |
| `badge_*.png` (3 buah) | Lencana: habit_magnet, rise_and_shine, streak_champ |

### Penting: gambar berlatar putih

Semua gambar **berlatar putih (bukan transparan)**. Kalau ditaruh di atas warna lain, akan terlihat
kotak putih. Solusinya: **selalu pakai `BlendImage`** dan isi `background` dengan **warna yang sama
persis** dengan latar di belakangnya.

```dart
// Di atas kartu habit berwarna
BlendImage(habitImage(habit.icon), background: Color(habit.color), size: 76)

// Di atas latar halaman (krem)
BlendImage('assets/images/pet_happy.png', background: AppColors.background, size: 160)

// Di dalam lingkaran: bungkus dengan ClipOval supaya sudutnya tidak kotak
ClipOval(child: BlendImage(path, background: warna, size: 150))
```

Jangan pakai `Image.asset` langsung di atas latar berwarna.

---

## 6. Pola Halaman

Semua halaman memakai kerangka yang sama:

```dart
Scaffold(
  body: SafeArea(
    child: ListView(
      padding: const EdgeInsets.all(20),
      children: [
        PageHeader(title: 'Judul Halaman'),
        const SizedBox(height: 20),
        AppCard(child: ...),
        const SizedBox(height: 20),
        AppCard(child: ...),
      ],
    ),
  ),
)
```

Contoh susunan halaman utama:

```
┌─────────────────────────────┐
│ Semangat hari ini!     [⚙]  │  ← sapaan + judul besar + CircleButton
│ Habit Pet                   │
│ (15)(16)(17)[18](19)(20)(21)│  ← DateStrip
│ ┌─────────────────────────┐ │
│ │ ★★  3 Hari Berturut!    │ │  ← StreakBanner
│ └─────────────────────────┘ │
│ ┌─────────────────────────┐ │
│ │ Habit Hari Ini (2) [→]  │ │  ← AppCard + Pill + CircleButton
│ │ ● ┌───────────────┐     │ │
│ │ │ │ Nama    [gbr] │     │ │  ← HabitTile (timeline)
│ │ ○ └───────────────┘     │ │
│ └─────────────────────────┘ │
│                [+ Habit Baru]│  ← FAB
└─────────────────────────────┘
```

Form: kartu-kartu bagian (ikon kecil oranye di kotak `orangeSoft` + judul), lalu tombol utama
lebar penuh di bawah layar. Contoh lengkap ada di `lib/screens/habit_form_screen.dart`.

---

## 7. Gaya Bahasa

- Bahasa Indonesia santai dan ramah, pakai "kamu".
- Pendek dan menyemangati: "Yuk buat habit pertamamu!", "Pertahankan!"
- Nama hari: `dayShort` (Sen, Sel, …) dan `dayLong` (Senin, …). Nama bulan: `monthShort`.
  Semua ada di `lib/theme.dart`, jangan menulis ulang.
- Tombol memakai kata kerja: "Simpan Habit", "Tambah Habit", "Hapus".

---

## 8. Saran untuk fitur lain

| Fitur | Saran desain |
|---|---|
| **A3 Check-in** | Ganti `_Status` di `habit_tile.dart` jadi bisa diketuk. Selesai = hijau + `check_circle_rounded`, titik timeline jadi oranye (sudah otomatis dari `doneDates`). |
| **B1 Buat stack** | Pakai pola form yang sama (kartu bagian + tombol bawah). Urutan habit tampilkan dengan `HabitTile` (timeline). |
| **B2 Mode jalankan stack** | Satu habit per layar: ilustrasi besar di tengah (`ClipOval` + `BlendImage`, 150–180), nama habit 18 `w700`, tombol utama "Selesai, lanjut". Saat stack selesai tampilkan `streak_celebration_stars.png`. |
| **C1 Beri nama pet** | `pet_happy.png` besar di atas, satu kartu input (gaya sama dengan "Nama Habit"), tombol utama. |
| **C2–C4 Halaman pet** | Gambar pet berubah sesuai status (`pet_happy` / `pet_hungry_sad`). Bar status: tinggi 10, sudut bulat penuh, latar `AppColors.border`, isi oranye (XP), hijau (kenyang), pink (kebahagiaan). Level pakai `Pill('Level 3')`. |

---

## 9. Checklist sebelum push

- [ ] Tidak ada warna hex baru di file halaman; semua dari `AppColors` / `habitColors`
- [ ] Kartu memakai `AppCard`, header memakai `PageHeader`
- [ ] Gambar memakai `BlendImage` dengan `background` yang sesuai
- [ ] Padding halaman 20, sudut kartu 20
- [ ] Ikon versi `_rounded`
- [ ] Teks panjang diberi `maxLines` + `ellipsis`
- [ ] Dicek di layar HP kecil (lebar 360–375) tanpa overflow (garis kuning-hitam)
- [ ] `flutter analyze` bersih
