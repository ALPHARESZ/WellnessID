import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/search.dart';
import '../widgets/page_header.dart';

class SearchDiseaseScreen extends StatelessWidget {
  const SearchDiseaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
          children: [
            const SizedBox(height: 10),

            // SearchBarWidget sekarang punya onSubmitted: (String)
            SearchBarWidget(
              hint: "Cari Info Penyakit di sini",
              icon: Icons.search,
              onSubmitted: (value) {
                final keyword = value.trim();
                if (keyword.isNotEmpty) {
                  context.push('/disease-result', extra: keyword);
                }
              },
            ),

            const SizedBox(height: 50),

            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.search_rounded,
                    size: 120,
                    color: Colors.grey.withOpacity(0.3),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "Silahkan Cari Informasi Penyakit",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      color: Color(0xFFB6B6B6),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
