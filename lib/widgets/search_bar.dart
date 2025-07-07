import 'package:flutter/material.dart';

/// 식당 검색창 위젯
class SearchBar extends StatelessWidget {
  final String hintText;
  final ValueChanged<String> onChanged;
  final TextEditingController? controller;

  const SearchBar({
    Key? key,
    required this.hintText,
    required this.onChanged,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.red),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
        ),
        onChanged: onChanged,
      ),
    );
  }
} 