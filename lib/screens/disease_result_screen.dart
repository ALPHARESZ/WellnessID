import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/search.dart';
import '../widgets/page_header.dart';
import '../widgets/card_list.dart';
import '../services/disease_service.dart';

class DiseaseResultScreen extends StatefulWidget {
  const DiseaseResultScreen({super.key});

  @override
  State<DiseaseResultScreen> createState() =>
      _DiseaseResultScreenState();
}

class _DiseaseResultScreenState
    extends State<DiseaseResultScreen> {
  String _keyword = "";
  Future<List<Map<String, dynamic>>>? _future;

  void _onSearch(String value) {
    final input = value.trim();
    if (input.isEmpty) return;

    setState(() {
      _keyword = input;
      _future = DiseaseService().searchDisease(input);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: PageHeader(
          title: "Cari Info Penyakit",
          onBack: () => context.go('/home'),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            /// Batasi lebar konten agar rapi di tablet / web / desktop
            final maxWidth = constraints.maxWidth > 900
                ? 900.0
                : constraints.maxWidth;

            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: maxWidth,
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      const SizedBox(height: 12),

                      /// SEARCH BAR
                      SearchBarWidget(
                        hint: "Cari Info Penyakit di sini",
                        icon: Icons.search,
                        onChanged: _onSearch,
                        onSubmitted: _onSearch,
                      ),

                      const SizedBox(height: 16),

                      /// ======================
                      /// KONTEN UTAMA (RESPONSIVE)
                      /// ======================
                      Expanded(
                        child: _keyword.isEmpty
                            ? _buildEmptyState()
                            : _buildResultList(),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// ======================
  /// EMPTY STATE
  /// ======================
  Widget _buildEmptyState() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isLandscape =
            constraints.maxHeight < 400;

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search_rounded,
                    size: isLandscape ? 80 : 120,
                    color: Colors.grey.withOpacity(0.3),
                  ),
                  const SizedBox(height: 12),
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
          ),
        );
      },
    );
  }

  /// ======================
  /// RESULT LIST
  /// ======================
  Widget _buildResultList() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState ==
            ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (!snapshot.hasData ||
            snapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              "Tidak ada hasil ditemukan.",
              style: TextStyle(
                fontFamily: 'Poppins',
              ),
            ),
          );
        }

        final results = snapshot.data!;

        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 12),
          itemCount: results.length,
          itemBuilder: (context, index) {
            final item = results[index];

            return CardList(
              title: item["name"] ?? "",
              subtitle:
                  "Deskripsi: ${item["description"] ?? "-"}",
              onTap: () {
                context.push(
                  "/disease-detail",
                  extra: item["id"],
                );
              },
            );
          },
        );
      },
    );
  }
}
