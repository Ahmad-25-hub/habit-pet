import 'package:flutter/material.dart';

import '../data/pet_store.dart';
import '../theme.dart';
import '../widgets/common.dart';

/// C1: layar pertama saat aplikasi dibuka — pengguna memberi nama pet.
class PetOnboardingScreen extends StatefulWidget {
  const PetOnboardingScreen({super.key, required this.petStore});

  final PetStore petStore;

  @override
  State<PetOnboardingScreen> createState() => _PetOnboardingScreenState();
}

class _PetOnboardingScreenState extends State<PetOnboardingScreen> {
  final _nameController = TextEditingController();
  bool _saving = false;

  static const _suggestions = ['Milo', 'Coco', 'Nala', 'Pip'];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _pickSuggestion(String name) {
    _nameController.text = name;
    _nameController.selection = TextSelection.collapsed(offset: name.length);
    setState(() {});
  }

  Future<void> _start() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Beri nama dulu, ya!')));
      return;
    }

    setState(() => _saving = true);
    try {
      await widget.petStore.createPet(name);
      // Root widget otomatis mengganti layar ini dengan HomeScreen
      // karena mendengarkan perubahan PetStore.
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Dekorasi lingkaran lembut di latar belakang.
          const Positioned(
            top: -70,
            right: -60,
            child: _SoftCircle(size: 220, color: AppColors.orangeSoft),
          ),
          const Positioned(
            bottom: 60,
            left: -80,
            child: _SoftCircle(size: 190, color: Color(0xFFFFF1E6)),
          ),
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(24, 12, 24, 8),
                    children: [
                      const _Brand(),
                      const SizedBox(height: 18),
                      Center(
                        child: TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0.85, end: 1),
                          duration: const Duration(milliseconds: 700),
                          curve: Curves.easeOutBack,
                          builder: (context, value, child) =>
                              Transform.scale(scale: value, child: child),
                          child: Container(
                            width: 216,
                            height: 216,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.orangeSoft,
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0x26FF7A1A),
                                  blurRadius: 30,
                                  offset: Offset(0, 12),
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: BlendImage(
                                'assets/images/pet_happy.png',
                                background: AppColors.orangeSoft,
                                size: 216,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 26),
                      const Text(
                        'Kenalan dulu, yuk!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: AppColors.text,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Ini rubah kecilmu. Beri dia nama supaya dia bisa '
                        'tumbuh bersama kebiasaan baikmu.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.5,
                          color: AppColors.textSoft,
                        ),
                      ),
                      const SizedBox(height: 26),
                      TextField(
                        controller: _nameController,
                        maxLength: 18,
                        textCapitalization: TextCapitalization.words,
                        textInputAction: TextInputAction.done,
                        onChanged: (_) => setState(() {}),
                        onSubmitted: (_) => _start(),
                        decoration: InputDecoration(
                          labelText: 'Nama pet',
                          hintText: 'Contoh: Milo',
                          counterText: '',
                          prefixIcon: const Icon(
                            Icons.pets_rounded,
                            color: AppColors.orange,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              color: AppColors.border,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              color: AppColors.border,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              color: AppColors.orange,
                              width: 1.6,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'Atau pilih nama ini:',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSoft,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final name in _suggestions)
                            _NameSuggestion(
                              name: name,
                              selected: _nameController.text.trim() == name,
                              onTap: () => _pickSuggestion(name),
                            ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const _HintCard(),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 4, 24, 16),
                  child: SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: FilledButton.icon(
                      onPressed: _saving ? null : _start,
                      style: FilledButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        disabledBackgroundColor: AppColors.orange,
                        disabledForegroundColor: Colors.white,
                        textStyle: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      icon: _saving
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.favorite_rounded),
                      label: Text(_saving ? 'Menyimpan...' : 'Mulai Berteman'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Brand extends StatelessWidget {
  const _Brand();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(7),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.orangeSoft,
          ),
          child: const Icon(
            Icons.pets_rounded,
            size: 18,
            color: AppColors.orange,
          ),
        ),
        const SizedBox(width: 8),
        const Text(
          'Habit Pet',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: AppColors.orange,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }
}

class _NameSuggestion extends StatelessWidget {
  const _NameSuggestion({
    required this.name,
    required this.selected,
    required this.onTap,
  });

  final String name;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        decoration: BoxDecoration(
          color: selected ? AppColors.orange : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? AppColors.orange : AppColors.border,
          ),
        ),
        child: Text(
          name,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : AppColors.text,
          ),
        ),
      ),
    );
  }
}

class _SoftCircle extends StatelessWidget {
  const _SoftCircle({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      ),
    );
  }
}

/// Satu baris info kecil di onboarding.
class _Hint extends StatelessWidget {
  const _Hint({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 15, color: AppColors.orange),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 11.5, color: AppColors.textSoft),
          ),
        ),
      ],
    );
  }
}

/// Kartu kecil berisi penjelasan singkat tentang pet.
class _HintCard extends StatelessWidget {
  const _HintCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: const Column(
        children: [
          _Hint(
            icon: Icons.pets_rounded,
            text: 'Satu pet untuk seluruh habitmu.',
          ),
          SizedBox(height: 8),
          _Hint(
            icon: Icons.favorite_rounded,
            text: 'Dia tumbuh setiap kali kamu check-in.',
          ),
        ],
      ),
    );
  }
}
