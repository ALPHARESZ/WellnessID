import 'package:flutter/material.dart';

import '../widgets/page_header.dart';

class DiseaseDetailScreen extends StatelessWidget {
  final String diseaseName;

  const DiseaseDetailScreen({
    super.key,
    this.diseaseName = "Covid",
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      body: SafeArea(
        child: Column(
          children: [
            PageHeader(
              title: "Detail Penyakit",
              onBack: () => Navigator.pop(context),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  children: [
                    Text(
                      diseaseName,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 20),

                    _buildSection(
                      title: "Gejala",
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text("• Gejala 1"),
                          Text("• Gejala 2"),
                          Text("• Gejala 3"),
                          Text("• Gejala 4"),
                          Text("• Gejala 5"),
                          Text("• Gejala 6"),
                          Text("• Gejala 7"),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),

                    _buildSection(
                      title: "Cara Pencegahan",
                      child: const Text(
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, "
                        "sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. "
                        "Ut enim ad minim veniam...",
                        textAlign: TextAlign.justify,
                      ),
                    ),
                    const SizedBox(height: 18),

                    _buildSection(
                      title: "Cara Penanganan",
                      child: const Text(
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, "
                        "sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                        textAlign: TextAlign.justify,
                      ),
                    ),
                    const SizedBox(height: 18),

                    _buildSection(
                      title: "Saran Obat",
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text("• Obat 1"),
                          Text("• Obat 2"),
                          Text("• Obat 3"),
                          Text("• Obat 4"),
                          Text("• Obat 5"),
                          Text("• Obat 6"),
                          Text("• Obat 7"),
                        ],
                      ),
                    ),
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

  Widget _buildSection({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFE9E9E9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(color: Colors.white),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: child,
          ),
        ],
      ),
    );
  }
}
