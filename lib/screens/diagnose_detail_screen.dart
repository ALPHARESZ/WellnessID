import 'package:flutter/material.dart';

import '../widgets/page_header.dart';

class DiagnoseDetailScreen extends StatelessWidget {
  const DiagnoseDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),

      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: PageHeader(
          title: "Hasil Diagnosa 1",
          onBack: () => Navigator.pop(context),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            _buildCard(
              title: "Data Pasien",
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _bullet("Umur: 1000 tahun kalau tak sembahyang apa gunanya"),
                  _bullet("Jenis Kelamin: Laki-Laki (Bukan Transgender dan Suka Perempuan)"),
                  _bullet("Berat Badan: > 1 gram"),
                  _bullet("Tinggi Badan: < 1 kilometer"),
                  const SizedBox(height: 10),
                  RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: "Alergi Obat: ",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextSpan(
                          text: "Sepertinya tidak",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 16),

            _buildCard(
              title: "Gejala",
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _bullet("Gatal-gatal di sekitar dubur"),
                  _bullet("Tenggorakan kering"),
                  _bullet("Susah menelan"),
                  _bullet("Sakit hati"),
                  _bullet("Pening di pinggang"),
                  _bullet("Tangan Encok"),
                ],
              ),
            ),

            const SizedBox(height: 16),

            _buildCard(
              title: "Hasil Prediksi Penyakit",
              content: Column(
                children: [
                  _predictionRow("Penyakit 1", "Sangat Kuat"),
                  _predictionRow("Penyakit 2", "Sangat Kuat Lemah"),
                  _predictionRow("Penyakit 3", "Sangat Lemah"),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({required String title, required Widget content}) {
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
          const SizedBox(height: 10),
          content,
        ],
      ),
    );
  }

  Widget _bullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("• ",
              style: TextStyle(fontSize: 15, fontFamily: "Poppins")),
          Expanded(
            child: Text(
              text,
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

  Widget _predictionRow(String disease, String strength) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            disease,
            style: const TextStyle(
              fontSize: 15,
              fontFamily: "Poppins",
            ),
          ),
          Text(
            strength,
            style: const TextStyle(
              fontSize: 15,
              fontFamily: "Poppins",
            ),
          ),
        ],
      ),
    );
  }
}
