import 'package:flutter/material.dart';

import 'data/habit_store.dart';
import 'screens/home_screen.dart';
import 'theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final store = HabitStore()..load(); // ambil data dari penyimpanan lokal
  runApp(HabitPetApp(store: store));
}

class HabitPetApp extends StatelessWidget {
  const HabitPetApp({super.key, required this.store});

  final HabitStore store;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Habit Pet',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.orange,
          primary: AppColors.orange,
          surface: AppColors.background,
        ),
        scaffoldBackgroundColor: AppColors.background,
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: AppColors.orange,
          foregroundColor: Colors.white,
        ),
      ),
      home: HomeScreen(store: store),
    );
  }
}
