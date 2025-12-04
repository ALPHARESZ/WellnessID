import 'package:flutter/material.dart';
import '../widgets/page_header.dart';
import '../services/disease_service.dart';

class DiseaseDetailScreen extends StatelessWidget {
  final String diseaseId;

  const DiseaseDetailScreen({super.key, required this.diseaseId});

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
              child: FutureBuilder(
                future: DiseaseService().getDiseaseById(diseaseId),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final data = snapshot.data!;
                  final symptoms = List<String>.from(data['symptoms']);

                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data['name'],
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 20),

                        _buildSection(
                          title: "Deskripsi",
                          child: Text(data['description']),
                        ),

                        const SizedBox(height: 18),

                        _buildSection(
                          title: "Gejala",
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: symptoms.map((s) => Text("• $s")).toList(),
                          ),
                        ),

                        const SizedBox(height: 18),

                        _buildSection(
                          title: "Cara Penanganan",
                          child: Text(data['solution']),
                        ),

                        const SizedBox(height: 30),
                      ],
                    ),
                  );
                },
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
