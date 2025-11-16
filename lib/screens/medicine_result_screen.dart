import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/search.dart';
import '../widgets/page_header.dart';
import '../widgets/card_list.dart';

class MedicineResultScreen extends StatelessWidget {
  const MedicineResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> medicines = [
      {"title": "Paracetamol", "subtitle": "Deskripsi: Lorem Ipsum..."},
      {"title": "Etanol", "subtitle": "Deskripsi: Lorem Ipsum..."},
      {"title": "Antibiotik", "subtitle": "Deskripsi: Lorem Ipsum..."},
      {"title": "Minyak Makan", "subtitle": "Deskripsi: Lorem Ipsum..."},
    ];

    final List<bool> savedStates = List<bool>.filled(medicines.length, false);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),

      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: PageHeader(
          title: "Cari Info Obat",
          onBack: () => Navigator.pop(context),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            const SizedBox(height: 10),

            const SearchBarWidget(
              hint: "Cari Info Obat di sini",
              icon: Icons.search,
            ),

            const SizedBox(height: 20),

            Expanded(
              child: ListView.builder(
                itemCount: medicines.length,
                itemBuilder: (context, index) {
                  final item = medicines[index];

                  return StatefulBuilder(
                    builder: (context, setState) {
                      return CardList(
                        title: item["title"]!,
                        subtitle: item["subtitle"]!,
                        trailing: GestureDetector(
                          onTap: () {
                            if (!savedStates[index]) {
                              setState(() {
                                savedStates[index] = true;
                              });

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text(
                                    'Obat Berhasil Disimpan',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  backgroundColor: Colors.green,
                                  behavior: SnackBarBehavior.floating,
                                  margin: const EdgeInsets.only(
                                    top: 20,
                                    left: 16,
                                    right: 16,
                                  ),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            }
                          },
                          child: Container(
                            key: ValueKey(savedStates[index]),
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Color(0xFF22B3E3),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              savedStates[index]
                                  ? Icons.check
                                  : Icons.add,
                              size: 22,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        onTap: () {
                          context.push('/medicine-detail');
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
