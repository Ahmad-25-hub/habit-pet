import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/habit_store.dart';
import '../data/pet_store.dart';
import '../models/habit.dart';
import '../models/pet.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/date_strip.dart';
import '../widgets/habit_tile.dart';
import '../widgets/pet_status_card.dart';
import '../widgets/streak_banner.dart';
import 'habit_form_screen.dart';
import 'manage_habits_screen.dart';

/// A2: halaman utama, menampilkan habit yang harus dikerjakan hari ini.
/// A3: kartu habit bisa diketuk untuk check-in / membatalkan check-in.
/// C2: status pet tampil di bagian atas halaman.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.store, required this.petStore});

  final HabitStore store;
  final PetStore petStore;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  DateTime selected = DateUtils.dateOnly(DateTime.now());
  late final Listenable _listenable;

  @override
  void initState() {
    super.initState();
    _listenable = Listenable.merge([widget.store, widget.petStore]);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// C2: status pet juga diturunkan saat aplikasi kembali dibuka dari latar.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      widget.petStore.refreshDecay();
    }
  }

  void openManage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ManageHabitsScreen(store: widget.store),
      ),
    );
  }

  void openForm([Habit? habit]) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => HabitFormScreen(store: widget.store, habit: habit),
      ),
    );
  }

  void showMessage(String text) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(content: Text(text), behavior: SnackBarBehavior.floating),
    );
  }

  /// A3: menandai habit selesai pada tanggal yang dipilih, atau membatalkannya.
  Future<void> toggleCheckIn(Habit habit) async {
    if (!mounted) return;

    final today = DateUtils.dateOnly(DateTime.now());
    if (selected.isAfter(today)) {
      showMessage('Belum bisa check-in untuk tanggal yang akan datang.');
      return;
    }

    final isToday = DateUtils.isSameDay(selected, today);
    final done = await widget.store.toggleDone(habit.id, selected);
    if (!mounted) return;

    // Hadiah pet dihitung untuk check-in hari ini (dasar fitur C3).
    if (isToday) {
      if (done) {
        await widget.petStore.completeHabit();
      } else {
        await widget.petStore.undoHabit();
      }
      if (!mounted) return;
    }

    HapticFeedback.selectionClick();

    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        content: Text(
          done
              ? (isToday
                    ? '${habit.name} selesai! +${Pet.habitXp} XP'
                    : '${habit.name} ditandai selesai.')
              : 'Check-in ${habit.name} dibatalkan.',
        ),
        action: SnackBarAction(
          label: done ? 'Batalkan' : 'Ulangi',
          onPressed: () => toggleCheckIn(habit),
        ),
      ),
    );
  }

  String get listTitle {
    if (DateUtils.isSameDay(selected, DateTime.now())) return 'Habit Hari Ini';
    return '${dayLong[selected.weekday - 1]}, ${selected.day} ${monthShort[selected.month - 1]}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: openForm,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Habit Baru'),
      ),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: _listenable,
          builder: (context, _) {
            if (widget.store.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            final habits = widget.store.habitsOn(selected);
            final pet = widget.petStore.pet;

            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
              children: [
                _Header(onManage: openManage),
                const SizedBox(height: 16),
                if (pet != null) ...[
                  PetStatusCard(pet: pet),
                  const SizedBox(height: 16),
                ],
                DateStrip(
                  selected: selected,
                  onSelect: (date) => setState(() => selected = date),
                ),
                const SizedBox(height: 20),
                StreakBanner(streak: widget.store.bestStreak),
                const SizedBox(height: 20),
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              listTitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Pill('${habits.length} habit'),
                          const SizedBox(width: 4),
                          CircleButton(
                            icon: Icons.arrow_forward_rounded,
                            onTap: openManage,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      if (habits.isEmpty)
                        Center(
                          child: EmptyHabits(
                            message: 'Belum ada habit untuk hari ini.\nYuk buat habit pertamamu!',
                            onAdd: openForm,
                          ),
                        ),
                      for (var i = 0; i < habits.length; i++)
                        HabitTile(
                          habit: habits[i],
                          date: selected,
                          isFirst: i == 0,
                          isLast: i == habits.length - 1,
                          onCheckIn: () => toggleCheckIn(habits[i]),
                          onEdit: () => openForm(habits[i]),
                        ),
                    ],
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

class _Header extends StatelessWidget {
  const _Header({required this.onManage});

  final VoidCallback onManage;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Semangat hari ini!',
                style: TextStyle(fontSize: 14, color: AppColors.textSoft),
              ),
              SizedBox(height: 2),
              Text(
                'Habit Pet',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ),
        CircleButton(icon: Icons.tune_rounded, onTap: onManage),
      ],
    );
  }
}
