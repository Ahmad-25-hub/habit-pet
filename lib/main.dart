import 'package:flutter/material.dart';

import 'data/habit_store.dart';
import 'data/pet_store.dart';
import 'screens/home_screen.dart';
import 'screens/pet_onboarding_screen.dart';
import 'theme.dart';

/// Titik awal aplikasi: memuat data habit & pet, lalu menjalankan app.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Baca habit dan pet dari penyimpanan lokal sebelum layar pertama tampil.
  final store = HabitStore();
  final petStore = PetStore();
  await Future.wait([store.load(), petStore.load()]);

  runApp(HabitPetApp(store: store, petStore: petStore));
}

/// Widget akar aplikasi: mengatur tema dan memilih layar pertama.
class HabitPetApp extends StatelessWidget {
  const HabitPetApp({super.key, required this.store, required this.petStore});

  final HabitStore store;
  final PetStore petStore;

  /// Membuat MaterialApp; menampilkan Home kalau pet sudah ada,
  /// atau layar onboarding kalau belum.
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
        snackBarTheme: const SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Color(0xFF2B2622),
          actionTextColor: Color(0xFFFFB067),
        ),
      ),
      // C1: kalau pet belum punya nama, tampilkan onboarding lebih dulu.
      home: ListenableBuilder(
        listenable: petStore,
        builder: (context, _) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 420),
            switchInCurve: Curves.easeOut,
            switchOutCurve: Curves.easeIn,
            child: petStore.hasPet
                ? HomeScreen(
                    key: const ValueKey('home'),
                    store: store,
                    petStore: petStore,
                  )
                : PetOnboardingScreen(
                    key: const ValueKey('onboarding'),
                    petStore: petStore,
                  ),
          );
        },
      ),
    );
  }
}
