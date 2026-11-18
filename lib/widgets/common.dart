import 'package:flutter/material.dart';

import '../theme.dart';

/// Kartu putih dengan sudut membulat.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });

  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(color: Color(0x0D000000), blurRadius: 12, offset: Offset(0, 4)),
        ],
      ),
      child: child,
    );
  }
}

/// Ilustrasi berlatar putih yang "menyatu" dengan warna di belakangnya.
/// Caranya: gambar dikalikan (multiply) dengan warna latar,
/// sehingga bagian putih berubah jadi warna latar.
class BlendImage extends StatelessWidget {
  const BlendImage(
    this.path, {
    super.key,
    required this.background,
    required this.size,
  });

  final String path;
  final Color background;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      path,
      width: size,
      height: size,
      color: background,
      colorBlendMode: BlendMode.multiply,
    );
  }
}

/// Tombol bulat kecil berlatar putih.
class CircleButton extends StatelessWidget {
  const CircleButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.color = AppColors.orange,
  });

  final IconData icon;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(side: BorderSide(color: AppColors.border)),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(9),
          child: Icon(icon, size: 20, color: color),
        ),
      ),
    );
  }
}

/// Header halaman: tombol kembali, judul di tengah, tombol opsional di kanan.
class PageHeader extends StatelessWidget {
  const PageHeader({super.key, required this.title, this.trailing});

  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleButton(
          icon: Icons.arrow_back_rounded,
          onTap: () => Navigator.pop(context),
        ),
        Expanded(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
        ),
        trailing ?? const SizedBox(width: 40),
      ],
    );
  }
}

/// Label kecil berbentuk pil, mis. "3 habit".
class Pill extends StatelessWidget {
  const Pill(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.orangeSoft,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          color: AppColors.orange,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// Info streak kecil: ikon api + jumlah hari (A4).
class StreakLabel extends StatelessWidget {
  const StreakLabel(this.streak, {super.key});

  final int streak;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.local_fire_department_rounded,
          size: 16,
          color: streak > 0 ? AppColors.orange : AppColors.textSoft,
        ),
        const SizedBox(width: 2),
        Text(
          '$streak hari streak',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: streak > 0 ? AppColors.orange : AppColors.textSoft,
          ),
        ),
      ],
    );
  }
}

/// Tampilan saat belum ada habit.
class EmptyHabits extends StatelessWidget {
  const EmptyHabits({
    super.key,
    required this.message,
    required this.onAdd,
    this.background = Colors.white,
  });

  final String message;
  final VoidCallback onAdd;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        children: [
          BlendImage('assets/images/pet_happy.png', background: background, size: 130),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.textSoft),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add_rounded),
            label: const Text('Tambah Habit'),
          ),
        ],
      ),
    );
  }
}
