import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/medicines.dart';
import '../widgets/page_header.dart';

class MedicineDetailScreen extends StatelessWidget {
  const MedicineDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Medicines medicines = GoRouterState.of(context).extra as Medicines;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      body: SafeArea(
        child: Column(
          children: [
            PageHeader(title: "Detail Obat", onBack: () => context.pop()),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  children: [
                    Text(medicines.name,
                        style: const TextStyle(
                            fontSize: 28, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 20),
                    _buildSection("Deskripsi", medicines.description),
                    _buildSection("Saran Penggunaan", medicines.usage),
                    _buildSection("Efek Samping", medicines.sideEffects),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFE9E9E9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(title,
              style: const TextStyle(
                  fontWeight: FontWeight.w600, fontSize: 16)),
          const SizedBox(height: 8),
          Text(content, textAlign: TextAlign.justify),
        ],
      ),
    );
  }
}
