import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../services/expert_system_service.dart';
import '../widgets/card_list.dart';
import '../widgets/page_header.dart';
import '../providers/diagnose_provider.dart';
import '../services/diagnose_service.dart';

class DiagnoseResultPage extends StatelessWidget {
  const DiagnoseResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> selectedSymptomIds =
        (GoRouterState.of(context).extra as List).cast<String>();

    final expert = ExpertSystemService();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: PageHeader(
          title: "Diagnosa Penyakit",
          onBack: () => context.pop(),
        ),
      ),

      body: FutureBuilder<List<DiagnosisResult>>(
        future: expert.diagnose(selectedSymptomIds),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text("Terjadi error: ${snapshot.error}"),
            );
          }

          final results = snapshot.data ?? [];

          if (results.isEmpty) {
            return const Center(
              child: Text(
                "Tidak ditemukan penyakit yang cocok.",
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: Padding(
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
                                context.push('/disease-detail', extra: {
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
                    ],
                  ),
                ),
              ),

              // ---- Tombol Simpan Diagnosa (sekarang aman) ----
              Container(
                padding: const EdgeInsets.all(20),
                width: double.infinity,
                child: SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () async {
                      final provider = context.read<DiagnosisProvider>();

                      provider.setDiseases(
                        results.map((r) => {
                          "id": r.disease.id,
                          "name": r.disease.name,
                          "score": r.score,
                        }).toList(),
                      );

                      await DiagnosisService().saveDiagnosis(
                        diagnosisData: provider.toFirestore(),
                      );

                      provider.resetAll();
                      context.go('/profile');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF22B3E3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),

                    child: const Text(
                      "Simpan Diagnosa",
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
