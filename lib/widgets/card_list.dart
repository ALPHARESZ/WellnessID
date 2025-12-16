import 'package:flutter/material.dart';

class CardList extends StatelessWidget {
  final String title;
  final String subtitle;
  final void Function()? onTap;
  final Widget? trailing;

  const CardList({
    super.key,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.trailing,
  });

  // Fungsi untuk memotong teks deskripsi agar tidak terlalu panjang
  String _truncateText(String text, {int maxLength = 65}) {
    if (text.length <= maxLength) return text;
    return "${text.substring(0, maxLength)}...";
  }

  @override
  Widget build(BuildContext context) {
    // Pisahkan teks berdasarkan tanda ":" jika ada
    final parts = subtitle.split(":");
    final label = parts.isNotEmpty ? parts.first : "";
    final value = parts.length > 1 ? parts.sublist(1).join(":").trim() : subtitle;

    // Terapkan pemotongan teks pada bagian deskripsi/value
    final truncatedValue = _truncateText(value);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Color(0x33000000),
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center, // posisi vertikal tengah
          children: [
            // Bagian teks di sisi kiri
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: label.isNotEmpty ? "$label: " : "",
                          style: const TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: truncatedValue,
                          style: const TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 15,
                            color: Color(0xFF006EFF),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Tombol di sisi kanan tengah
            if (trailing != null)
              Align(
                alignment: Alignment.centerRight,
                child: trailing!,
              ),
          ],
        ),
      ),
    );
  }
}
