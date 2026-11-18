import 'package:flutter/material.dart';

import '../data/habit_store.dart';
import '../models/habit.dart';
import '../theme.dart';
import '../widgets/common.dart';
import '../widgets/date_strip.dart';
import '../widgets/habit_tile.dart';
import '../widgets/streak_banner.dart';
import 'habit_form_screen.dart';
import 'manage_habits_screen.dart';

/// A2: halaman utama, menampilkan habit yang harus dikerjakan hari ini.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.store});

  final HabitStore store;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime selected = DateUtils.dateOnly(DateTime.now());

  void openManage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ManageHabitsScreen(store: widget.store)),
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
          listenable: widget.store,
          builder: (context, _) {
            if (widget.store.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            final habits = widget.store.habitsOn(selected);

            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
              children: [
                _Header(onManage: openManage),
                const SizedBox(height: 20),
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
                          Text(
                            listTitle,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(width: 8),
                          Pill('${habits.length} habit'),
                          const Spacer(),
                          CircleButton(icon: Icons.arrow_forward_rounded, onTap: openManage),
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
                          onTap: () => openForm(habits[i]),
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
