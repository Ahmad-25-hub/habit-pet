import 'package:flutter/material.dart';

import '../data/habit_store.dart';
import '../data/pet_store.dart';
import '../models/habit.dart';
import '../models/habit_stack.dart';
import '../models/pet.dart';
import '../theme.dart';
import '../widgets/common.dart';

/// B2: mode jalankan stack, langkah demi langkah.
/// Setelah satu habit selesai, otomatis lanjut ke habit berikutnya.
/// C3: kalau semua habit di stack selesai, pet dapat bonus besar.
class RunStackScreen extends StatefulWidget {
  const RunStackScreen({
    super.key,
    required this.store,
    required this.petStore,
    required this.stack,
  });

  final HabitStore store;
  final PetStore petStore;
  final HabitStack stack;

  @override
  State<RunStackScreen> createState() => _RunStackScreenState();
}

class _RunStackScreenState extends State<RunStackScreen> {
  final today = DateUtils.dateOnly(DateTime.now());

  /// Nomor langkah yang sedang dikerjakan (mulai dari 0).
  int step = 0;

  /// true kalau semua langkah sudah dilewati.
  bool finished = false;

  /// true kalau pet mendapat bonus stack di akhir.
  bool gotBonus = false;

  /// Stack yang sudah lengkap sebelum dijalankan tidak diberi bonus lagi,
  /// supaya bonus tidak bisa didapat berkali-kali di hari yang sama.
  late final bool wasCompleteBefore;

  @override
  void initState() {
    super.initState();
    wasCompleteBefore = allDoneToday(); // dicek sekali saat layar dibuka
  }

  /// Habit di stack, sesuai urutan (diambil ulang supaya status selalu baru).
  List<Habit> get habits => widget.store.habitsInStack(widget.stack);

  bool allDoneToday() => habits.every((h) => h.isDoneOn(today));

  /// Tombol "Selesai": check-in habit ini (kalau belum), lalu lanjut.
  Future<void> completeStep() async {
    final habit = habits[step];
    if (!habit.isDoneOn(today)) {
      await widget.store.toggleDone(habit.id, today);
      await widget.petStore.completeHabit(); // C3: +10 XP, +5 kenyang
    }
    await nextStep();
  }

  /// Pindah ke langkah berikutnya, atau selesai kalau ini langkah terakhir.
  Future<void> nextStep() async {
    if (step < habits.length - 1) {
      setState(() => step++);
      return;
    }

    // Langkah terakhir: cek apakah semua habit selesai untuk bonus.
    if (allDoneToday() && !wasCompleteBefore) {
      await widget.petStore.completeStack(); // C3: +30 XP, +10 kebahagiaan
      gotBonus = true;
    }
    setState(() => finished = true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              PageHeader(title: widget.stack.name),
              const SizedBox(height: 24),
              Expanded(child: finished ? buildFinished() : buildStep()),
            ],
          ),
        ),
      ),
    );
  }

  /// Tampilan satu langkah: habit yang sedang dikerjakan.
  Widget buildStep() {
    final habit = habits[step];
    final done = habit.isDoneOn(today);
    final isLast = step == habits.length - 1;

    return Column(
      children: [
        // Progres: "Langkah 2 dari 3"
        Text(
          'Langkah ${step + 1} dari ${habits.length}',
          style: const TextStyle(color: AppColors.textSoft, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(99),
          child: LinearProgressIndicator(
            value: (step + 1) / habits.length,
            minHeight: 8,
            backgroundColor: AppColors.orangeSoft,
          ),
        ),
        const Spacer(),
        ClipOval(
          child: BlendImage(
            habitImage(habit.icon),
            background: Color(habit.color),
            size: 200,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          habit.name,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 8),
        Text(
          done ? 'Sudah selesai hari ini ✓' : 'Kerjakan habit ini, lalu tekan Selesai.',
          style: TextStyle(color: done ? AppColors.green : AppColors.textSoft),
        ),
        const SizedBox(height: 8),
        if (!isLast)
          Text(
            'Berikutnya: ${habits[step + 1].name}',
            style: const TextStyle(color: AppColors.textSoft),
          ),
        const Spacer(),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: FilledButton(
            onPressed: completeStep,
            child: Text(done ? 'Lanjut' : 'Selesai'),
          ),
        ),
        TextButton(
          onPressed: nextStep,
          child: const Text('Lewati'),
        ),
      ],
    );
  }

  /// Tampilan akhir setelah semua langkah dilewati.
  Widget buildFinished() {
    final pet = widget.petStore.pet;

    String message;
    if (gotBonus) {
      message = 'Bonus stack untuk ${pet?.name ?? 'pet'}: '
          '+${Pet.stackXp} XP dan +${Pet.stackHappiness} kebahagiaan!';
    } else if (allDoneToday()) {
      message = 'Semua habit di stack ini sudah selesai hari ini.';
    } else {
      message = 'Ada habit yang dilewati, jadi belum dapat bonus stack.';
    }

    return Column(
      children: [
        const Spacer(),
        BlendImage(
          pet?.image ?? 'assets/images/pet_happy.png',
          background: AppColors.background,
          size: 200,
        ),
        const SizedBox(height: 20),
        Text(
          gotBonus ? 'Rutinitas Selesai!' : 'Stack Selesai Dijalankan',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 8),
        Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.textSoft),
        ),
        const Spacer(),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Kembali'),
          ),
        ),
      ],
    );
  }
}
