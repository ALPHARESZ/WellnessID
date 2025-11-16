import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/card_list.dart';
import '../widgets/page_header.dart';

class DiagnoseResultPage extends StatelessWidget {
  const DiagnoseResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),

      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: PageHeader(
          title: "Diagnosa Penyakit",
          onBack: () => Navigator.pop(context),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          children: [
            const SizedBox(height: 10),

            CardList(
              title: "Covid",
              subtitle: "Kecocokan: Sangat Kuat",
              onTap: () {
                context.go('/detail');
              },
            ),

            CardList(
              title: "Influenza",
              subtitle: "Kecocokan: Kuat",
              onTap: () {
                context.go('/detail');
              },
            ),

            CardList(
              title: "Malaria",
              subtitle: "Kecocokan: Sedang",
              onTap: () {
                context.go('/detail');
              },
            ),

            CardList(
              title: "Radang Tenggorokan",
              subtitle: "Kecocokan: Lemah",
              onTap: () {
                context.go('/detail');
              },
            ),

            const SizedBox(height: 30),

            CardList(
              title: "Paracetamol",
              subtitle: "Deskripsi: Lorem Ipsum...",
              trailing: Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Color(0xFF22B3E3),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.add,
                  size: 22,
                  color: Colors.white,
                ),
              ),
              onTap: () {

              },
            ),

            const SizedBox(height: 30),
          ],
        ),
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
    );
  }
}
