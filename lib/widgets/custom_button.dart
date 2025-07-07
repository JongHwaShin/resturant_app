import 'package:flutter/material.dart';

/// 커스텀 버튼 위젯 (빨간색, 아이콘+텍스트)
class CustomButton extends StatelessWidget {
  final String text;
  final IconData? icon;
  final VoidCallback onPressed;
  final Color? color;

  const CustomButton({
    Key? key,
    required this.text,
    this.icon,
    required this.onPressed,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? Colors.red,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
      icon: icon != null ? Icon(icon) : const SizedBox.shrink(),
      label: Text(text, style: const TextStyle(fontSize: 16)),
      onPressed: onPressed,
    );
  }
} 