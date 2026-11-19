# **Daftar Fitur Aplikasi Habit Tracker** 

Flutter • Fitur unggulan: Habit Stacking & Virtual Pet 

## **Gambaran Umum** 

Aplikasi habit tracker ini membantu pengguna membangun kebiasaan baik melalui dua fitur unggulan: 

- **Habit Stacking:** menyusun beberapa kebiasaan menjadi satu rutinitas berurutan, sehingga kebiasaan baru “menempel” pada kebiasaan yang sudah ada. 

- **Virtual Pet:** hewan peliharaan virtual yang tumbuh dan bahagia saat pengguna konsisten, serta sedih atau lapar saat habit diabaikan. 

Fitur dikelompokkan menjadi tiga bagian dan diberi tingkat prioritas: Wajib, Disarankan, dan Bonus. 

## **A. Fitur Dasar** 

|**No**|**Fitur**|**Keterangan**|**Yang ngerjain**|
|---|---|---|---|
|**A1**|**Kelola habit**|Tambah, edit, dan hapus habit: nama,<br>ikon, warna, serta jadwal (setiap hari atau<br>hari tertentu).||
|**A2**|**Daftar habit hari ini**|Halaman utama yang menampilkan habit<br>yang harus dikerjakan hari ini.||
|**A3**|**Check-in habit**|Tap untuk menandai habit selesai; bisa<br>dibatalkan.||
|**A4**|**Streak**|Menghitung jumlah hari berturut-turut<br>habit diselesaikan.||
|**A7**|**Penyimpanan lokal**|Data tersimpan di perangkat sehingga<br>tetap ada saat aplikasi ditutup.||



## **B. Habit Stacking** 

|**No**|**Fitur**|**Keterangan**|**Yang ngerjain**|
|---|---|---|---|
|**B1**|**Buat stack (rantai)**|Menggabungkan beberapa habit menjadi<br>satu rutinitas, misalnya “Rutinitas Pagi”.||
|**B2**|**Mode jalankan stack**|Tampilan langkah demi langkah: setelah<br>satu habit selesai, otomatis lanjut ke habit<br>berikutnya.||



## **C. Virtual Pet** 

|**No**|**Fitur**|**Keterangan**|**Yang ngerjain**|
|---|---|---|---|
|**C1**|**beri nama pet**|Dilakukan saat pertama kali membuka<br>aplikasi (onboarding).||



|**No**|**Fitur**|**Keterangan**|**Yang ngerjain**|
|---|---|---|---|
|**C2**|**Status pet**|Tiga status utama: Kenyang (HP),<br>Kebahagiaan, dan XP.||
|**C3**|**Pet bereaksi ke habit**|Habit selesai menambah XP dan rasa<br>kenyang; stack lengkap memberi bonus<br>besar.||
|**C4**|**Halaman pet**|Menampilkan pet, status bar, dan level.||



### **Catatan Desain Virtual Pet** 

- **Satu pet untuk seluruh aplikasi,** bukan satu pet per habit, agar logika lebih sederhana dan pengguna lebih terikat secara emosional. 

- **Contoh aturan main:** habit selesai +10 XP dan +5 kenyang; stack lengkap bonus +30 XP dan +10 kebahagiaan. 

- **Penurunan status** dihitung saat aplikasi dibuka, berdasarkan jumlah hari sejak pembaruan terakhir. 

