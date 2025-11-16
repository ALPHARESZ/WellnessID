import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/search.dart';
import '../widgets/page_header.dart';
import '../widgets/card_list.dart';
import '../widgets/confirmation_popup.dart';

class SavedMedicineScreen extends StatelessWidget {
  const SavedMedicineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> medicines = [
      {"title": "Paracetamol", "subtitle": "Deskripsi: Lorem Ipsum..."},
      {"title": "Etanol", "subtitle": "Deskripsi: Lorem Ipsum..."},
      {"title": "Antibiotik", "subtitle": "Deskripsi: Lorem Ipsum..."},
      {"title": "Minyak Makan", "subtitle": "Deskripsi: Lorem Ipsum..."},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),

      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: PageHeader(
          title: "Daftar Obat Tersimpan",
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
              hint: "Cari Obat Tersimpan di sini",
              icon: Icons.search,
            ),

            const SizedBox(height: 20),

            Expanded(
              child: ListView.builder(
                itemCount: medicines.length,
                itemBuilder: (context, index) {
                  final item = medicines[index];
                  return CardList(
                    title: item["title"]!,
                    subtitle: item["subtitle"]!,
                    trailing: GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          barrierColor: Colors.black.withOpacity(0.3),
                          builder: (context) {
                            return ConfirmationPopup(
                              title: "Hapus Obat?",
                              onConfirm: () {
                                Navigator.pop(context);
                                // TODO: tambahkan logic hapus jika sudah ada databasenya
                              },
                              onCancel: () {
                                Navigator.pop(context);
                              },
                            );
                          },
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.delete,
                          size: 22,
                          color: Colors.red,
                        ),
                      ),
                    ),
                    onTap: () {
                      context.push('/medicine-detail');
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