import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/search.dart';
import '../widgets/page_header.dart';
import '../widgets/card_list.dart';
import '../services/disease_service.dart';

class DiseaseResultScreen extends StatelessWidget {
  final String keyword;

  const DiseaseResultScreen({super.key, required this.keyword});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),

      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: PageHeader(
          title: "Hasil Pencarian",
          onBack: () => context.pop(),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 10),

            // Search bar yang bekerja
            SearchBarWidget(
              hint: keyword,
              icon: Icons.search,
              onSubmitted: (value) {
                context.push('/disease-result', extra: value);
              },
            ),

            const SizedBox(height: 20),

            Expanded(
              child: FutureBuilder(
                future: DiseaseService().searchDisease(keyword),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text("Tidak ada hasil ditemukan."),
                    );
                  }

                  final results = snapshot.data!;

                  return ListView.builder(
                    itemCount: results.length,
                    itemBuilder: (context, index) {
                      final item = results[index];

                      return CardList(
                        title: item["name"] ?? "",
                        subtitle: item["description"] ?? "",
                        onTap: () {
                          context.push("/disease-detail", extra: item["id"]);
                        },
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
