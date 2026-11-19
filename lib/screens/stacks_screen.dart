import 'package:flutter/material.dart';

import '../data/habit_store.dart';
import '../data/pet_store.dart';
import '../models/habit_stack.dart';
import '../theme.dart';
import '../widgets/common.dart';
import 'run_stack_screen.dart';
import 'stack_form_screen.dart';

/// B1: daftar semua stack. Tap untuk edit, ikon tempat sampah untuk hapus.
/// B2: tombol play untuk menjalankan stack.
class StacksScreen extends StatelessWidget {
  const StacksScreen({super.key, required this.store, required this.petStore});

  final HabitStore store;
  final PetStore petStore;

  /// B2: mulai menjalankan stack langkah demi langkah.
  void openRun(BuildContext context, HabitStack stack) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RunStackScreen(store: store, petStore: petStore, stack: stack),
      ),
    );
  }

  void openForm(BuildContext context, [HabitStack? stack]) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => StackFormScreen(store: store, stack: stack)),
    );
  }

  Future<void> confirmDelete(BuildContext context, HabitStack stack) async {
    final yes = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus stack?'),
        content: Text('"${stack.name}" akan dihapus. Habit di dalamnya tetap ada.'),
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
    if (yes == true) await store.deleteStack(stack.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListenableBuilder(
          listenable: store,
          builder: (context, _) {
            final stacks = store.stacks;

            return ListView(
              padding: const EdgeInsets.all(20),
              children: [
                PageHeader(
                  title: 'Habit Stack',
                  trailing: CircleButton(
                    icon: Icons.add_rounded,
                    onTap: () => openForm(context),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Gabungkan beberapa habit menjadi satu rutinitas berurutan.',
                  style: TextStyle(color: AppColors.textSoft),
                ),
                const SizedBox(height: 12),
                if (stacks.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Column(
                      children: [
                        const Icon(Icons.link_rounded, size: 56, color: AppColors.textSoft),
                        const SizedBox(height: 8),
                        const Text(
                          'Belum ada stack.',
                          style: TextStyle(color: AppColors.textSoft),
                        ),
                        const SizedBox(height: 12),
                        FilledButton.icon(
                          onPressed: () => openForm(context),
                          icon: const Icon(Icons.add_rounded),
                          label: const Text('Buat Stack'),
                        ),
                      ],
                    ),
                  ),
                for (final stack in stacks)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _StackTile(
                      stack: stack,
                      habitNames: [
                        for (final h in store.habitsInStack(stack)) h.name,
                      ],
                      onRun: () => openRun(context, stack),
                      onEdit: () => openForm(context, stack),
                      onDelete: () => confirmDelete(context, stack),
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

class _StackTile extends StatelessWidget {
  const _StackTile({
    required this.stack,
    required this.habitNames,
    required this.onRun,
    required this.onEdit,
    required this.onDelete,
  });

  final HabitStack stack;
  final List<String> habitNames;
  final VoidCallback onRun;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onEdit,
      child: AppCard(
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          stack.name,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Pill('${habitNames.length} habit'),
                    ],
                  ),
                  const SizedBox(height: 6),
                  // Contoh: "Minum air → Olahraga → Baca buku"
                  Text(
                    habitNames.join('  →  '),
                    style: const TextStyle(fontSize: 13, color: AppColors.textSoft),
                  ),
                ],
              ),
            ),
            // B2: tombol jalankan (hanya kalau stack masih punya habit).
            if (habitNames.isNotEmpty)
              IconButton.filled(
                tooltip: 'Jalankan',
                onPressed: onRun,
                icon: const Icon(Icons.play_arrow_rounded),
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
