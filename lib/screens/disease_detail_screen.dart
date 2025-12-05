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
  State<DiseaseDetailScreen> createState() => _DiseaseDetailScreenState();
}

class _DiseaseDetailScreenState extends State<DiseaseDetailScreen> {
  late Future<Disease?> _diseaseFuture;

  @override
  void initState() {
    super.initState();
    _diseaseFuture = _loadDisease();
  }

  Future<Disease?> _loadDisease() async {
    final raw = await DiseaseService().getDiseaseById(widget.diseaseId);

    if (raw == null) return null;

    return Disease.fromFirestore(raw["id"], raw);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),

      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: PageHeader(
          title: "Detail Penyakit",
          onBack: () => context.pop(),
        ),
      ),

      body: FutureBuilder<Disease?>(
        future: _diseaseFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("Data penyakit tidak ditemukan."));
          }

          final disease = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                Text(
                  disease.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                Text(
                  disease.description,
                  style: const TextStyle(fontSize: 16),
                ),

                const SizedBox(height: 24),
                const Text(
                  "Gejala:",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),

                ...disease.symptoms.map(
                  (s) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Text("• $s"),
                  ),
                ),

                const SizedBox(height: 24),
                const Text(
                  "Solusi:",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(disease.solution),

                const SizedBox(height: 24),
                const Text(
                  "Obat:",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),

                ...disease.mediciness.map(
                  (m) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Text("• $m"),
                  ),
                ),

                const SizedBox(height: 28),
              ],
            ),
          );
        },
      ),
    );
  }
}
