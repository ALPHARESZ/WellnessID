import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/page_header.dart';
import '../services/diagnose_service.dart';

class DiagnoseDetailScreen extends StatelessWidget {
  const DiagnoseDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final extra = GoRouterState.of(context).extra as Map<String, dynamic>;
    final String diagnosisId = extra['diagnosisId'];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),

      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: PageHeader(
          title: "Hasil Diagnosa 1",
          onBack: () => Navigator.pop(context),
        ),
      ),

      body: LayoutBuilder(
        builder: (context, constraints) {
          return FutureBuilder<Map<String, dynamic>?>(
            future: DiagnosisService().getDiagnosisDetail(diagnosisId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data == null) {
                return const Center(
                  child: Text(
                    "Data diagnosa tidak ditemukan",
                    style: TextStyle(fontFamily: "Poppins"),
                  ),
                );
              }

              final data = snapshot.data!;

              final age = data['age'];
              final height = data['height'];
              final weight = data['weight'];
              final gender = data['gender'];
              final allergies = data['allergies'];

              final List symptoms = data['symptoms'] ?? [];
              final List diseases = data['diseases'] ?? [];

              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 720, // ⬅️ kunci responsive tablet & web
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          // ================= DATA PASIEN =================
                          _buildCard(
                            title: "Data Pasien",
                            content: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _bullet("Umur: $age tahun"),
                                _bullet("Jenis Kelamin: $gender"),
                                _bullet("Berat Badan: $weight Kg"),
                                _bullet("Tinggi Badan: $height cm"),
                                const SizedBox(height: 10),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      const TextSpan(
                                        text: "Alergi Obat: ",
                                        style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontSize: 15,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      TextSpan(
                                        text: allergies,
                                        style: const TextStyle(
                                          fontFamily: "Poppins",
                                          fontSize: 15,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),

                          // ================= GEJALA =================
                          _buildCard(
                            title: "Gejala",
                            content: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: symptoms
                                  .map<Widget>(
                                    (s) => _bullet(s['name'].toString()),
                                  )
                                  .toList(),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // ================= HASIL PREDIKSI =================
                          _buildCard(
                            title: "Hasil Prediksi Penyakit",
                            content: Column(
                              children: diseases.asMap().entries.map<Widget>((e) {
                                final d = e.value;
                                final double score =
                                    (d['score'] ?? 0).toDouble();
                                final int percent = (score * 100).round();

                                String strength;
                                if (percent >= 80) {
                                  strength = "Sangat Kuat";
                                } else if (percent >= 60) {
                                  strength = "Kuat";
                                } else if (percent >= 40) {
                                  strength = "Sedang";
                                } else {
                                  strength = "Lemah";
                                }

                                return _predictionRow(
                                  "${e.key + 1}. ${d['name']}",
                                  strength,
                                );
                              }).toList(),
                            ),
                          ),

                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // ================= CARD =================
  Widget _buildCard({
    required String title,
    required Widget content,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: "Poppins",
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),
          content,
        ],
      ),
    );
  }

  // ================= BULLET =================
  Widget _bullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "• ",
            style: TextStyle(
              fontSize: 15,
              fontFamily: "Poppins",
            ),
          ),
          Expanded(
            child: Text(
              text,
              softWrap: true,
              style: const TextStyle(
                fontSize: 14,
                fontFamily: "Poppins",
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= PREDICTION ROW =================
  Widget _predictionRow(String disease, String strength) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              disease,
              softWrap: true,
              style: const TextStyle(
                fontSize: 15,
                fontFamily: "Poppins",
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: Text(
              strength,
              textAlign: TextAlign.right,
              softWrap: true,
              style: const TextStyle(
                fontSize: 15,
                fontFamily: "Poppins",
              ),
            ),
          ),
        ],
      ),
    );
  }
}
