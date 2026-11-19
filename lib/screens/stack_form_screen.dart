import 'package:flutter/material.dart';

import '../data/habit_store.dart';
import '../models/habit_stack.dart';
import '../theme.dart';
import '../widgets/common.dart';

/// B1: form buat / edit stack.
/// Ketuk habit di "Pilih Habit" untuk menambahkannya ke urutan,
/// ketuk tanda silang di "Urutan Habit" untuk mengeluarkannya.
class StackFormScreen extends StatefulWidget {
  const StackFormScreen({super.key, required this.store, this.stack});

  final HabitStore store;

  /// null = buat stack baru, selain itu = edit stack ini.
  final HabitStack? stack;

  /// Membuat objek state untuk form stack.
  @override
  State<StackFormScreen> createState() => _StackFormScreenState();
}

/// State form stack: menyimpan nama dan daftar habit yang dipilih.
class _StackFormScreenState extends State<StackFormScreen> {
  late final nameController = TextEditingController(text: widget.stack?.name);

  /// Id habit yang dipilih, sesuai urutan rutinitas.
  late final List<String> chosen = [...?widget.stack?.habitIds];

  /// True kalau form dibuka untuk mengedit stack yang sudah ada.
  bool get isEdit => widget.stack != null;

  /// Membersihkan controller teks saat halaman ditutup.
  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  /// Menampilkan pesan singkat (SnackBar), mis. untuk error validasi.
  void showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  /// Memvalidasi isian (nama + minimal 2 habit), lalu menyimpan stack
  /// dan menutup form.
  void save() {
    final name = nameController.text.trim();

    if (name.isEmpty) {
      showMessage('Nama stack belum diisi');
      return;
    }
    if (chosen.length < 2) {
      showMessage('Pilih minimal dua habit');
      return;
    }

    final stack = HabitStack(
      id: widget.stack?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      habitIds: chosen,
    );

    if (isEdit) {
      widget.store.updateStack(stack);
    } else {
      widget.store.addStack(stack);
    }
    Navigator.pop(context);
  }

  /// Menyusun form: nama stack, urutan habit terpilih, daftar habit
  /// yang bisa ditambahkan, dan tombol simpan.
  @override
  Widget build(BuildContext context) {
    final habits = widget.store.habits;
    final chosenHabits = [
      for (final id in chosen) ...habits.where((h) => h.id == id),
    ];
    final otherHabits = habits.where((h) => !chosen.contains(h.id)).toList();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: PageHeader(title: isEdit ? 'Edit Stack' : 'Stack Baru'),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  const _Title('Nama Stack'),
                  TextField(
                    controller: nameController,
                    maxLength: 30,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      hintText: 'Contoh: Rutinitas Pagi',
                      counterText: '',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Habit yang sudah dipilih, bernomor sesuai urutan.
                  _Title('Urutan Habit (${chosen.length})'),
                  AppCard(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Column(
                      children: [
                        if (chosenHabits.isEmpty)
                          const Padding(
                            padding: EdgeInsets.all(16),
                            child: Text(
                              'Ketuk habit di bawah untuk menambahkannya ke urutan.',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: AppColors.textSoft),
                            ),
                          ),
                        for (var i = 0; i < chosenHabits.length; i++)
                          ListTile(
                            leading: CircleAvatar(
                              radius: 14,
                              backgroundColor: AppColors.orange,
                              foregroundColor: Colors.white,
                              child: Text('${i + 1}'),
                            ),
                            title: Text(chosenHabits[i].name),
                            trailing: IconButton(
                              tooltip: 'Keluarkan',
                              icon: const Icon(Icons.close_rounded),
                              onPressed: () => setState(
                                () => chosen.remove(chosenHabits[i].id),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Habit yang belum dipilih.
                  const _Title('Pilih Habit'),
                  if (habits.isEmpty)
                    const Text(
                      'Belum ada habit. Buat habit dulu di halaman utama.',
                      style: TextStyle(color: AppColors.textSoft),
                    )
                  else if (otherHabits.isEmpty)
                    const Text(
                      'Semua habit sudah masuk ke urutan.',
                      style: TextStyle(color: AppColors.textSoft),
                    ),
                  for (final habit in otherHabits)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: AppCard(
                        padding: EdgeInsets.zero,
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: BlendImage(
                              habitImage(habit.icon),
                              background: Color(habit.color),
                              size: 40,
                            ),
                          ),
                          title: Text(habit.name),
                          trailing: const Icon(
                            Icons.add_circle_outline_rounded,
                            color: AppColors.orange,
                          ),
                          onTap: () => setState(() => chosen.add(habit.id)),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton(
                  onPressed: save,
                  child: Text(isEdit ? 'Simpan Perubahan' : 'Simpan Stack'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Judul kecil di atas tiap bagian form.
class _Title extends StatelessWidget {
  const _Title(this.text);

  final String text;

  /// Menampilkan teks judul tebal dengan jarak di bawahnya.
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
      ),
    );
  }
}
