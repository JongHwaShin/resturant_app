import 'package:flutter/material.dart';

/// 커스텀 AppBar 위젯
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.actions,
    this.leading,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      backgroundColor: Colors.red,
      foregroundColor: Colors.white,
      elevation: 2,
      leading: leading,
      actions: actions,
    );
  }
} 