/// B1: satu stack (rantai) = beberapa habit yang dijalankan berurutan,
/// misalnya "Rutinitas Pagi": Minum air -> Olahraga -> Baca buku.
class HabitStack {
  final String id;
  final String name;

  /// Id habit di dalam stack. Urutan list = urutan rutinitas.
  final List<String> habitIds;

  const HabitStack({
    required this.id,
    required this.name,
    required this.habitIds,
  });

  /// Mengubah stack menjadi Map supaya bisa disimpan sebagai JSON.
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'habitIds': habitIds,
      };

  /// Membuat stack dari Map hasil membaca JSON.
  factory HabitStack.fromJson(Map<String, dynamic> json) => HabitStack(
        id: json['id'] as String,
        name: json['name'] as String,
        habitIds: List<String>.from(json['habitIds'] as List),
      );
}
