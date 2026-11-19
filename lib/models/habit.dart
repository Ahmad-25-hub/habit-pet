/// Satu habit milik pengguna (A1).
class Habit {
  final String id;
  final String name;

  /// Nama ikon, mis. 'creativity' -> assets/images/habit_creativity.png
  final String icon;

  /// Warna kartu (nilai ARGB).
  final int color;

  /// Hari terjadwal: 1 = Senin ... 7 = Minggu (sama dengan DateTime.weekday).
  final List<int> days;

  /// Tanggal-tanggal habit diselesaikan, format 'yyyy-mm-dd'.
  final List<String> doneDates;

  const Habit({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.days,
    this.doneDates = const [],
  });

  bool get isEveryDay => days.length == 7;

  bool isScheduledOn(DateTime date) => days.contains(date.weekday);

  bool isDoneOn(DateTime date) => doneDates.contains(dateKey(date));

  /// Salinan habit dengan sebagian data diganti (dipakai saat check-in).
  Habit copyWith({
    String? name,
    String? icon,
    int? color,
    List<int>? days,
    List<String>? doneDates,
  }) {
    return Habit(
      id: id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      days: days ?? this.days,
      doneDates: doneDates ?? this.doneDates,
    );
  }

  /// A4: jumlah hari terjadwal berturut-turut yang diselesaikan,
  /// dihitung mundur dari hari ini.
  /// - Hari yang tidak terjadwal dilewati (tidak memutus streak).
  /// - Kalau hari ini belum selesai, streak tetap dihitung dari kemarin.
  int streak([DateTime? today]) {
    if (days.isEmpty || doneDates.isEmpty) return 0;

    final now = today ?? DateTime.now();
    var day = DateTime(now.year, now.month, now.day);
    if (!isDoneOn(day)) day = _previousDay(day);

    var count = 0;
    while (true) {
      if (isScheduledOn(day)) {
        if (!isDoneOn(day)) break;
        count++;
      }
      day = _previousDay(day);
    }
    return count;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'icon': icon,
        'color': color,
        'days': days,
        'doneDates': doneDates,
      };

  factory Habit.fromJson(Map<String, dynamic> json) => Habit(
        id: json['id'] as String,
        name: json['name'] as String,
        icon: json['icon'] as String,
        color: json['color'] as int,
        days: List<int>.from(json['days'] as List),
        doneDates: List<String>.from(json['doneDates'] as List? ?? []),
      );
}

/// Mengubah tanggal menjadi teks 'yyyy-mm-dd'.
String dateKey(DateTime date) {
  final m = date.month.toString().padLeft(2, '0');
  final d = date.day.toString().padLeft(2, '0');
  return '${date.year}-$m-$d';
}

DateTime _previousDay(DateTime day) => DateTime(day.year, day.month, day.day - 1);
