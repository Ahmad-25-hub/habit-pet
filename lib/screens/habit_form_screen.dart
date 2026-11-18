import 'package:flutter/material.dart';

import '../data/habit_store.dart';
import '../models/habit.dart';
import '../theme.dart';
import '../widgets/common.dart';

/// A1: form tambah / edit habit (nama, ikon, warna, jadwal).
class HabitFormScreen extends StatefulWidget {
  const HabitFormScreen({super.key, required this.store, this.habit});

  final HabitStore store;

  /// null = tambah habit baru, selain itu = edit habit ini.
  final Habit? habit;

  @override
  State<HabitFormScreen> createState() => _HabitFormScreenState();
}

class _HabitFormScreenState extends State<HabitFormScreen> {
  late final nameController = TextEditingController(text: widget.habit?.name);
  late String icon = widget.habit?.icon ?? habitIcons.first;
  late int color = widget.habit?.color ?? habitColors.first.toARGB32();
  late bool everyDay = widget.habit?.isEveryDay ?? true;
  late final Set<int> days = {...widget.habit?.days ?? const [1, 2, 3, 4, 5]};

  bool get isEdit => widget.habit != null;

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  void showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  void save() {
    final name = nameController.text.trim();
    final selectedDays = everyDay ? [1, 2, 3, 4, 5, 6, 7] : (days.toList()..sort());

    if (name.isEmpty) {
      showMessage('Nama habit belum diisi');
      return;
    }
    if (selectedDays.isEmpty) {
      showMessage('Pilih minimal satu hari');
      return;
    }

    final habit = Habit(
      id: widget.habit?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      icon: icon,
      color: color,
      days: selectedDays,
      doneDates: widget.habit?.doneDates ?? const [],
    );

    if (isEdit) {
      widget.store.update(habit);
    } else {
      widget.store.add(habit);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final bg = Color(color);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: PageHeader(title: isEdit ? 'Edit Habit' : 'Habit Baru'),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  // Pratinjau ikon + warna yang dipilih
                  Center(
                    child: ClipOval(
                      child: BlendImage(habitImage(icon), background: bg, size: 150),
                    ),
                  ),
                  const SizedBox(height: 20),

                  _Section(
                    icon: Icons.edit_rounded,
                    title: 'Nama Habit',
                    child: TextField(
                      controller: nameController,
                      maxLength: 40,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        hintText: 'Contoh: Minum air 8 gelas',
                        counterText: '',
                        filled: true,
                        fillColor: AppColors.background,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),

                  _Section(
                    icon: Icons.emoji_emotions_rounded,
                    title: 'Pilih Ikon',
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        for (final item in habitIcons)
                          _IconChoice(
                            icon: item,
                            selected: item == icon,
                            onTap: () => setState(() => icon = item),
                          ),
                      ],
                    ),
                  ),

                  _Section(
                    icon: Icons.palette_rounded,
                    title: 'Pilih Warna',
                    child: Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        for (final c in habitColors)
                          _ColorChoice(
                            color: c,
                            selected: c.toARGB32() == color,
                            onTap: () => setState(() => color = c.toARGB32()),
                          ),
                      ],
                    ),
                  ),

                  _Section(
                    icon: Icons.calendar_month_rounded,
                    title: 'Jadwal',
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _ChoicePill(
                                label: 'Setiap hari',
                                selected: everyDay,
                                onTap: () => setState(() => everyDay = true),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _ChoicePill(
                                label: 'Hari tertentu',
                                selected: !everyDay,
                                onTap: () => setState(() => everyDay = false),
                              ),
                            ),
                          ],
                        ),
                        if (!everyDay) ...[
                          const SizedBox(height: 14),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              for (var d = 1; d <= 7; d++)
                                _DayChoice(
                                  label: dayShort[d - 1],
                                  selected: days.contains(d),
                                  onTap: () => setState(() {
                                    if (days.contains(d)) {
                                      days.remove(d);
                                    } else {
                                      days.add(d);
                                    }
                                  }),
                                ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Tombol simpan
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: FilledButton(
                  onPressed: save,
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  child: Text(isEdit ? 'Simpan Perubahan' : 'Simpan Habit'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Kartu bagian form dengan ikon kecil + judul.
class _Section extends StatelessWidget {
  const _Section({required this.icon, required this.title, required this.child});

  final IconData icon;
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.orangeSoft,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, size: 18, color: AppColors.orange),
                ),
                const SizedBox(width: 10),
                Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
              ],
            ),
            const SizedBox(height: 14),
            child,
          ],
        ),
      ),
    );
  }
}

class _IconChoice extends StatelessWidget {
  const _IconChoice({required this.icon, required this.selected, required this.onTap});

  final String icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 62,
        height: 62,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          border: Border.all(
            color: selected ? AppColors.orange : AppColors.border,
            width: selected ? 2.5 : 1,
          ),
        ),
        child: ClipOval(
          child: BlendImage(habitImage(icon), background: Colors.white, size: 54),
        ),
      ),
    );
  }
}

class _ColorChoice extends StatelessWidget {
  const _ColorChoice({required this.color, required this.selected, required this.onTap});

  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: selected ? AppColors.orange : AppColors.line,
            width: selected ? 2.5 : 1,
          ),
        ),
        child: selected
            ? const Icon(Icons.check_rounded, size: 20, color: AppColors.orange)
            : null,
      ),
    );
  }
}

class _ChoicePill extends StatelessWidget {
  const _ChoicePill({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.orange : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: selected ? AppColors.orange : AppColors.border),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : AppColors.text,
          ),
        ),
      ),
    );
  }
}

class _DayChoice extends StatelessWidget {
  const _DayChoice({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: selected ? AppColors.orange : AppColors.background,
          border: Border.all(color: selected ? AppColors.orange : AppColors.border),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : AppColors.textSoft,
          ),
        ),
      ),
    );
  }
}
