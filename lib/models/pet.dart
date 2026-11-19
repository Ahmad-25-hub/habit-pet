/// C2: satu hewan peliharaan virtual untuk seluruh aplikasi.
///
/// Status utama:
/// - [fullness] = Kenyang / HP (0-100)
/// - [happiness] = Kebahagiaan (0-100)
/// - [xp] = pengalaman yang menentukan level
///
/// Semua perubahan status hanya lewat method di kelas ini supaya aturannya
/// terkumpul di satu tempat dan mudah diuji.
class Pet {
  const Pet({
    required this.name,
    required this.fullness,
    required this.happiness,
    required this.xp,
    required this.lastUpdated,
  });

  final String name;

  /// Kenyang / HP: 0 - 100.
  final int fullness;

  /// Kebahagiaan: 0 - 100.
  final int happiness;

  /// Total XP yang sudah dikumpulkan.
  final int xp;

  /// Tanggal terakhir status diperbarui (dasar penurunan status harian).
  final DateTime lastUpdated;

  static const int maxStatus = 100;

  /// XP yang dibutuhkan untuk naik satu level.
  static const int xpPerLevel = 100;

  /// C3: hadiah tiap habit yang selesai.
  static const int habitXp = 10;
  static const int habitFullness = 5;

  /// Penurunan status per hari (dihitung saat aplikasi dibuka).
  static const int fullnessDecayPerDay = 12;
  static const int happinessDecayPerDay = 8;

  /// Nilai awal saat pet baru diberi nama.
  static const int initialFullness = 70;
  static const int initialHappiness = 70;

  // ---- Level ----

  int get level => xp ~/ xpPerLevel + 1;

  int get xpInLevel => xp % xpPerLevel;

  int get xpToNextLevel => xpPerLevel - xpInLevel;

  /// Progres XP menuju level berikutnya (0.0 - 1.0).
  double get levelProgress => xpInLevel / xpPerLevel;

  String get levelTitle {
    if (level >= 8) return 'Rubah Legenda';
    if (level >= 6) return 'Rubah Hebat';
    if (level >= 4) return 'Rubah Ceria';
    if (level >= 2) return 'Rubah Muda';
    return 'Rubah Kecil';
  }

  // ---- Mood / gambar ----

  /// Pet dianggap bahagia kalau kenyang dan kebahagiaannya masih cukup.
  bool get isHappy => fullness >= 30 && happiness >= 30;

  String get moodLabel => isHappy ? 'Senang' : 'Lapar & sedih';

  /// Gambar pet sesuai kondisinya.
  String get image => isHappy
      ? 'assets/images/pet_happy.png'
      : 'assets/images/pet_hungry_sad.png';

  // ---- Perubahan status ----

  /// Jumlah hari penuh sejak [lastUpdated] sampai [now].
  int daysSince(DateTime now) => _daysBetween(lastUpdated, now);

  /// Penurunan status saat aplikasi dibuka.
  ///
  /// Kalau belum ganti hari, objek yang sama dikembalikan supaya pemanggil
  /// bisa mendeteksi "tidak ada perubahan" dengan [identical].
  Pet decayTo(DateTime now) {
    final days = daysSince(now);
    if (days <= 0) return this;

    return copyWith(
      fullness: _clampStatus(fullness - days * fullnessDecayPerDay),
      happiness: _clampStatus(happiness - days * happinessDecayPerDay),
      lastUpdated: _dateOnly(now),
    );
  }

  /// C3: hadiah saat satu habit selesai (+10 XP, +5 kenyang).
  Pet addHabitReward(DateTime now) => copyWith(
    xp: xp + habitXp,
    fullness: _clampStatus(fullness + habitFullness),
    lastUpdated: _dateOnly(now),
  );

  /// Mengembalikan hadiah saat check-in dibatalkan supaya XP tidak bisa
  /// ditambah terus hanya dengan menekan tombol bolak-balik.
  Pet removeHabitReward() => copyWith(
    xp: (xp - habitXp) < 0 ? 0 : xp - habitXp,
    fullness: _clampStatus(fullness - habitFullness),
  );

  Pet rename(String newName) => copyWith(name: newName);

  Pet copyWith({
    String? name,
    int? fullness,
    int? happiness,
    int? xp,
    DateTime? lastUpdated,
  }) {
    return Pet(
      name: name ?? this.name,
      fullness: fullness ?? this.fullness,
      happiness: happiness ?? this.happiness,
      xp: xp ?? this.xp,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  // ---- Penyimpanan ----

  Map<String, dynamic> toJson() => {
    'name': name,
    'fullness': fullness,
    'happiness': happiness,
    'xp': xp,
    'lastUpdated': lastUpdated.toIso8601String(),
  };

  factory Pet.fromJson(Map<String, dynamic> json) => Pet(
    name: json['name'] as String? ?? 'Pet',
    fullness: (json['fullness'] as num?)?.toInt() ?? initialFullness,
    happiness: (json['happiness'] as num?)?.toInt() ?? initialHappiness,
    xp: (json['xp'] as num?)?.toInt() ?? 0,
    lastUpdated:
        DateTime.tryParse(json['lastUpdated'] as String? ?? '') ??
        DateTime.now(),
  );
}

int _clampStatus(int value) => value.clamp(0, Pet.maxStatus).toInt();

DateTime _dateOnly(DateTime date) => DateTime(date.year, date.month, date.day);

/// Selisih hari kalender, dihitung dengan UTC supaya aman dari pergeseran
/// zona waktu / daylight saving.
int _daysBetween(DateTime from, DateTime to) {
  final a = DateTime.utc(from.year, from.month, from.day);
  final b = DateTime.utc(to.year, to.month, to.day);
  return b.difference(a).inDays;
}
