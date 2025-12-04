import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../services/expert_system_service.dart';
import '../widgets/card_list.dart';
import '../widgets/page_header.dart';
import '../models/disease.dart';

class DiagnoseResultPage extends StatelessWidget {
  const DiagnoseResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> selectedSymptomIds =
        (GoRouterState.of(context).extra as List).cast<String>();

    final expertSystem = ExpertSystemService();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: PageHeader(
          title: "Diagnosa Penyakit",
          onBack: () => context.pop(),
        ),
      ),
      body: FutureBuilder<Disease?>(
        future: expertSystem.diagnose(selectedSymptomIds),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Terjadi error: ${snapshot.error}',
                style: const TextStyle(fontFamily: 'Poppins'),
              ),
            );
          }

          final result = snapshot.data;

          if (result == null) {
            return const Center(
              child: Text(
                "Tidak ditemukan penyakit yang cocok dengan gejala yang dipilih.",
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Poppins',
                ),
                textAlign: TextAlign.center,
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ListView(
              children: [
                const SizedBox(height: 10),

                CardList(
                  title: result.name,
                  subtitle: "Tingkat kecocokan: ${((selectedSymptomIds.length / result.symptomIds.length) * 100).toInt()}%",
                  onTap: () {
                    context.go('/disease-detail', extra: result);
                  },
                ),

                const SizedBox(height: 30),

                const Text(
                  "Solusi",
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 10),

                CardList(
                  title: "Rekomendasi",
                  subtitle: result.description,
                  onTap: () {},
                ),

                const SizedBox(height: 30),
              ],
            ),
          );
        },
      ),
    );
  }
}
