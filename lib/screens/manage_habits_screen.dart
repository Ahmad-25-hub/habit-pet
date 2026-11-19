import 'package:flutter/material.dart';

import '../data/habit_store.dart';
import '../models/habit.dart';
import '../theme.dart';
import '../widgets/common.dart';
import 'habit_form_screen.dart';

/// A1: daftar semua habit. Tap untuk edit, ikon tempat sampah untuk hapus.
class ManageHabitsScreen extends StatelessWidget {
  const ManageHabitsScreen({super.key, required this.store});

  final HabitStore store;

  /// Membuka form habit: tambah baru kalau [habit] null, edit kalau diisi.
  void openForm(BuildContext context, [Habit? habit]) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => HabitFormScreen(store: store, habit: habit)),
    );
  }

  /// Menampilkan dialog konfirmasi, lalu menghapus habit kalau disetujui.
  Future<void> confirmDelete(BuildContext context, Habit habit) async {
    final yes = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus habit?'),
        content: Text('"${habit.name}" beserta riwayat streak-nya akan dihapus.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (yes == true) await store.delete(habit.id);
  }

  /// Menyusun halaman: header, jumlah habit, dan daftar semua habit.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListenableBuilder(
          listenable: store,
          builder: (context, _) {
            final habits = store.habits;

            return ListView(
              padding: const EdgeInsets.all(20),
              children: [
                PageHeader(
                  title: 'Kelola Habit',
                  trailing: CircleButton(
                    icon: Icons.add_rounded,
                    onTap: () => openForm(context),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  '${habits.length} habit tersimpan',
                  style: const TextStyle(color: AppColors.textSoft),
                ),
                const SizedBox(height: 12),
                if (habits.isEmpty)
                  EmptyHabits(
                    message: 'Kamu belum punya habit.',
                    background: AppColors.background,
                    onAdd: () => openForm(context),
                  ),
                for (final habit in habits)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _ManageTile(
                      habit: habit,
                      onEdit: () => openForm(context, habit),
                      onDelete: () => confirmDelete(context, habit),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// Satu kartu habit di halaman Kelola (gambar, nama, jadwal, streak, hapus).
class _ManageTile extends StatelessWidget {
  const _ManageTile({
    required this.habit,
    required this.onEdit,
    required this.onDelete,
  });

  final Habit habit;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  /// Menyusun kartu; diketuk -> edit, tombol sampah -> hapus.
  @override
  Widget build(BuildContext context) {
    final color = Color(habit.color);

    return GestureDetector(
      onTap: onEdit,
      child: AppCard(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(16),
              ),
              child: BlendImage(habitImage(habit.icon), background: color, size: 60),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    habit.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.event_repeat_rounded, size: 15, color: AppColors.textSoft),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          scheduleText(habit.days),
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12, color: AppColors.textSoft),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  StreakLabel(habit.streak()),
                ],
              ),
            ),
            IconButton(
              tooltip: 'Hapus',
              onPressed: onDelete,
              icon: const Icon(Icons.delete_outline_rounded, color: AppColors.textSoft),
            ),
          ],
        ),
      ),
    );
  }
}
