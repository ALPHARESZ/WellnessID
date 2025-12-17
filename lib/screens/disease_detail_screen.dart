import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/disease.dart';
import '../services/disease_service.dart';
import '../widgets/page_header.dart';

class DiseaseDetailScreen extends StatefulWidget {
  final String diseaseId;

  const DiseaseDetailScreen({
    super.key,
    required this.diseaseId,
  });

  @override
  State<DiseaseDetailScreen> createState() =>
      _DiseaseDetailScreenState();
}

class _DiseaseDetailScreenState
    extends State<DiseaseDetailScreen> {
  late Future<_DiseaseDetailData> _future;

  @override
  void initState() {
    super.initState();
    _future = _loadDiseaseDetail();
  }

  Future<_DiseaseDetailData> _loadDiseaseDetail() async {
    final service = DiseaseService();

    final raw =
        await service.getDiseaseById(widget.diseaseId);

    if (raw == null) {
      throw Exception("Disease not found");
    }

    final disease = Disease.fromFirestore(raw["id"], raw);

    final symptomNames =
        await service.getSymptomNames(disease.symptoms);

    final medicineNames =
        await service.getMedicineNames(disease.medicines);

    return _DiseaseDetailData(
      disease: disease,
      symptoms: symptomNames,
      medicines: medicineNames,
    );
  }

  /// ======================
  /// CARD SECTION (KONSISTEN DENGAN MEDICINE DETAIL)
  /// ======================
  Widget _buildCardSection(String title, Widget content) {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: "Poppins",
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF003B88),
            ),
          ),
          const SizedBox(height: 10),
          content,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      body: SafeArea(
        child: Column(
          children: [
            PageHeader(
              title: "Detail Penyakit",
              onBack: () => context.pop(),
            ),

            Expanded(
              child: FutureBuilder<_DiseaseDetailData>(
                future: _future,
                builder: (context, snapshot) {
                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (!snapshot.hasData) {
                    return const Center(
                      child: Text(
                        "Data penyakit tidak ditemukan.",
                        style: TextStyle(fontFamily: "Poppins"),
                      ),
                    );
                  }

                  final data = snapshot.data!;
                  final disease = data.disease;

                  return LayoutBuilder(
                    builder: (context, constraints) {

                      return Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxWidth: 720, // 🔥 KUNCI KONSISTENSI WIDTH
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: ListView(
                              children: [
                                // =====================
                                // NAMA PENYAKIT
                                // =====================
                                Text(
                                  disease.name,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontFamily: "Poppins",
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF003B88),
                                  ),
                                ),

                                const SizedBox(height: 8),
                                const Divider(
                                  color: Color(0xFF22B3E3),
                                  thickness: 2,
                                  indent: 120,
                                  endIndent: 120,
                                ),

                                // =====================
                                // DESKRIPSI
                                // =====================
                                _buildCardSection(
                                  "Deskripsi",
                                  Text(
                                    disease.description,
                                    style: const TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 15,
                                      height: 1.6,
                                    ),
                                  ),
                                ),

                                // =====================
                                // GEJALA
                                // =====================
                                _buildCardSection(
                                  "Gejala",
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: data.symptoms.map(
                                      (s) => Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 2),
                                        child: Text(
                                          "• $s",
                                          style: const TextStyle(
                                            fontFamily: "Poppins",
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    ).toList(),
                                  ),
                                ),

                                // =====================
                                // SOLUSI
                                // =====================
                                _buildCardSection(
                                  "Solusi",
                                  Text(
                                    disease.solution,
                                    style: const TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 15,
                                      height: 1.6,
                                    ),
                                  ),
                                ),

                                // =====================
                                // OBAT
                                // =====================
                                _buildCardSection(
                                  "Obat",
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: data.medicines.map(
                                      (m) => Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 2),
                                        child: Text(
                                          "• $m",
                                          style: const TextStyle(
                                            fontFamily: "Poppins",
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    ).toList(),
                                  ),
                                ),

                                const SizedBox(height: 28),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ===============================
/// DATA HOLDER UNTUK DETAIL PENYAKIT
/// ===============================
class _DiseaseDetailData {
  final Disease disease;
  final List<String> symptoms;
  final List<String> medicines;

  _DiseaseDetailData({
    required this.disease,
    required this.symptoms,
    required this.medicines,
  });
}
