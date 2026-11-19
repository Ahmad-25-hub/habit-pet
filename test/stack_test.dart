import 'package:flutter_test/flutter_test.dart';
import 'package:habit_pet/data/habit_store.dart';
import 'package:habit_pet/models/habit.dart';
import 'package:habit_pet/models/habit_stack.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Habit habit(String id, String name) => Habit(
        id: id,
        name: name,
        icon: 'reading',
        color: 0xFFFFE6D5,
        days: const [1, 2, 3, 4, 5, 6, 7],
      );

  const pagi = HabitStack(id: 's1', name: 'Rutinitas Pagi', habitIds: ['h2', 'h1']);

  test('B1: stack tersimpan dan urutan habit sesuai pilihan', () async {
    final store = HabitStore();
    await store.load();
    await store.add(habit('h1', 'Minum air'));
    await store.add(habit('h2', 'Olahraga'));
    await store.addStack(pagi);

    // Dibaca ulang dari penyimpanan, seperti saat aplikasi dibuka lagi.
    final reopened = HabitStore();
    await reopened.load();

    expect(reopened.stacks.single.name, 'Rutinitas Pagi');
    expect(
      reopened.habitsInStack(reopened.stacks.single).map((h) => h.name),
      ['Olahraga', 'Minum air'],
    );
  });

  test('B1: edit dan hapus stack', () async {
    final store = HabitStore();
    await store.load();
    await store.addStack(pagi);

    await store.updateStack(
      const HabitStack(id: 's1', name: 'Pagi Sehat', habitIds: ['h1', 'h2']),
    );
    expect(store.stacks.single.name, 'Pagi Sehat');

    await store.deleteStack('s1');
    expect(store.stacks, isEmpty);
  });

  test('B1: habit yang dihapus keluar dari stack', () async {
    final store = HabitStore();
    await store.load();
    await store.add(habit('h1', 'Minum air'));
    await store.add(habit('h2', 'Olahraga'));
    await store.addStack(pagi);

    await store.delete('h2');

    expect(store.stacks.single.habitIds, ['h1']);
  });
}
