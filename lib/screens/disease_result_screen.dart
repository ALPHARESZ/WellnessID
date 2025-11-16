import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/search.dart';
import '../widgets/page_header.dart';
import '../widgets/card_list.dart';

class DiseaseResultPage extends StatelessWidget {
  const DiseaseResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> diseases = [
      {"title": "Kanker Otak Stadium 1", "subtitle": "Saran Obat: Lorem Ipsum..."},
      {"title": "Kanker Otak Stadium 2", "subtitle": "Saran Obat: Lorem Ipsum..."},
      {"title": "Kanker Otak Stadium 3", "subtitle": "Saran Obat: Lorem Ipsum..."},
      {"title": "Kanker Otak Stadium 4", "subtitle": "Saran Obat: Lorem Ipsum..."},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),

      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: PageHeader(
          title: "Cari Info Penyakit",
          onBack: () => context.pop(),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            const SizedBox(height: 10),

            const SearchBarWidget(
              hint: "Kanker Otak",
              icon: Icons.search,
            ),

            const SizedBox(height: 20),

            Expanded(
              child: ListView.builder(
                itemCount: diseases.length,
                itemBuilder: (context, index) {
                  final item = diseases[index];
                  return CardList(
                    title: item["title"]!,
                    subtitle: item["subtitle"]!,
                    onTap: () {
                      context.push('/disease-detail');
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
