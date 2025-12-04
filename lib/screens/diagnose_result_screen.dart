import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../services/expert_system_service.dart';
import '../widgets/card_list.dart';
import '../widgets/page_header.dart';

class DiagnoseResultPage extends StatelessWidget {
  const DiagnoseResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> selectedSymptomIds = (GoRouterState.of(context).extra as List).cast<String>();
    final expert = ExpertSystemService();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: PreferredSize(preferredSize: const Size.fromHeight(56), child: PageHeader(title: "Diagnosa Penyakit", onBack: () => context.pop())),
      body: FutureBuilder<List<DiagnosisResult>>(
        future: expert.diagnose(selectedSymptomIds),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (snapshot.hasError) {
            return Center(child: Text('Terjadi error: ${snapshot.error}', style: const TextStyle(fontFamily: 'Poppins')));
          }

          final results = snapshot.data ?? [];

          if (results.isEmpty) {
            return const Center(child: Text('Tidak ditemukan penyakit yang cocok dengan gejala yang dipilih.', style: TextStyle(fontSize: 16, fontFamily: 'Poppins')));
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ListView(
              children: [
                const SizedBox(height: 10),
                ...results.map((r) {
                  final percent = (r.score * 100).round();
                  return Column(
                    children: [
                      CardList(
                        title: r.disease.name,
                        subtitle: "Kecocokan: $percent%",
                        onTap: () {
                          // kirim Disease + score + selectedSymptomIds ke detail
                          context.go('/disease-detail', extra: {
                            'disease': r.disease,
                            'score': r.score,
                            'selectedSymptomIds': selectedSymptomIds,
                          });
                        },
                      ),
                      const SizedBox(height: 10),
                    ],
                  );
                }).toList(),
                const SizedBox(height: 30),
                // (opsional) rekomendasi obat/card lain tetap sesuai desain awal
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        color: const Color(0xFFF8F9FE),
        child: SizedBox(
          height: 56,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              context.push('/home');
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF22B3E3), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40))),
            child: const Text("Simpan Diagnosa", style: TextStyle(fontSize: 18, fontFamily: "Poppins", fontWeight: FontWeight.w600, color: Colors.white)),
          ),
        ),
      ),
    );
  }
}
