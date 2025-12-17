import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/medicines.dart';
import '../widgets/page_header.dart';

class MedicineDetailsScreen extends StatelessWidget {
  const MedicineDetailsScreen({super.key});

  // Widget untuk menampilkan deskripsi obat dengan gaya card
  Widget _buildDescriptionSection(String title, String content) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: "Poppins",
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF003B88),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            content.isNotEmpty ? content : "-",
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: "Poppins",
              fontSize: 15,
              color: Colors.black87,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = GoRouterState.of(context).extra;

    if (data == null) {
      return const Scaffold(
        body: Center(
          child: Text(
            "Data obat tidak ditemukan.",
            style: TextStyle(
              fontFamily: "Poppins",
              fontSize: 16,
            ),
          ),
        ),
      );
    }

    final Medicines medicines = data is Medicines
        ? data
        : Medicines.fromMap(data as Map<String, dynamic>);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      body: SafeArea(
        child: Column(
          children: [
            // Header dengan tombol back otomatis dari PageHeader
            PageHeader(
              title: "Detail Obat",
              onBack: () => context.pop(),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // 🔹 Nama obat
                    Text(
                      medicines.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF003B88),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Divider(
                      color: Color(0xFF22B3E3),
                      thickness: 2,
                      indent: 100,
                      endIndent: 100,
                    ),

                    // 🔹 Hanya bagian Deskripsi
                    _buildDescriptionSection("Deskripsi", medicines.description),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
