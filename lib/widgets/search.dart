import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  final String hint;
  final IconData icon;
  final Function(String)? onSubmitted;

  const SearchBarWidget({
    super.key,
    required this.hint,
    required this.icon,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey),
          const SizedBox(width: 12),

          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: hint,          // ← placeholder kini aktif
                border: InputBorder.none,
                hintStyle: const TextStyle(
                  fontSize: 16,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                  color: Colors.grey,
                ),
              ),
              textInputAction: TextInputAction.search,
              onSubmitted: onSubmitted,  // ← fungsi pencarian
            ),
          ),
        ],
      ),
    );
  }
}
