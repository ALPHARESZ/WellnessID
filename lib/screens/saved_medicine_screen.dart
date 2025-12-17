import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/search.dart';
import '../widgets/page_header.dart';
import '../widgets/card_list.dart';
import '../widgets/confirmation_popup.dart';
import '../models/medicines.dart';
import '../services/medicines_service.dart';

class SavedMedicineScreen extends StatefulWidget {
  const SavedMedicineScreen({super.key});

  @override
  State<SavedMedicineScreen> createState() => _SavedMedicineScreenState();
}

class _SavedMedicineScreenState extends State<SavedMedicineScreen> {
  final MedicinesService _medicineService = MedicinesService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String searchQuery = '';

  /// 🔹 Hapus obat dari Firestore
  Future<void> _deleteMedicine(Medicines medicine) async {
    final user = _auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Anda harus login untuk menghapus obat."),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    await _medicineService.deleteSavedMedicine(user.uid, medicine.id);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("${medicine.name} berhasil dihapus."),
        backgroundColor: Colors.redAccent,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(
          child: Text(
            "Silakan login terlebih dahulu.",
            style: TextStyle(
              fontFamily: "Poppins",
              fontSize: 16,
            ),
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final bool isWideScreen = screenWidth > 600;

        return Scaffold(
          backgroundColor: const Color(0xFFF8F9FE),
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(56),
            child: PageHeader(
              title: "Daftar Obat Tersimpan",
              onBack: () => Navigator.pop(context),
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),

                  /// 🔍 Search bar
                  SearchBarWidget(
                    hint: "Cari Obat Tersimpan di sini",
                    icon: Icons.search,
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                  ),

                  const SizedBox(height: 20),

                  /// 🔄 StreamBuilder: mendengarkan data Firestore secara real-time
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(user.uid)
                          .collection('saved_medicines')
                          .orderBy('dateSaved', descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return Center(
                            child: Text(
                              "Tidak ada obat tersimpan",
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 18,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          );
                        }

                        final docs = snapshot.data!.docs;
                        final medicines = docs.map((doc) {
                          final data = doc.data() as Map<String, dynamic>;
                          return Medicines(
                            id: doc.id,
                            name: data['name'] ?? '',
                            description: data['description'] ?? '',
                            usage: data['usage'] ?? '',
                            sideEffects: data['sideEffects'] ?? '',
                            relatedDiseases: List<String>.from(
                                data['relatedDiseases'] ?? []),
                          );
                        }).toList();

                        // 🔎 Filter berdasarkan pencarian
                        final filteredList = medicines.where((m) {
                          return m.name
                              .toLowerCase()
                              .contains(searchQuery.toLowerCase());
                        }).toList();

                        if (filteredList.isEmpty) {
                          return Center(
                            child: Text(
                              "Tidak ada obat ditemukan.",
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 18,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          );
                        }

                        // ✅ Tampilkan daftar obat tersimpan
                        return ListView.builder(
                          itemCount: filteredList.length,
                          itemBuilder: (context, index) {
                            final item = filteredList[index];
                            return CardList(
                              title: item.name,
                              subtitle: "Deskripsi: ${item.description}",
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
                                          _deleteMedicine(item);
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
                                  child: Icon(
                                    Icons.delete,
                                    size: isWideScreen ? 26 : 22,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                              onTap: () {
                                context.push('/medicine-detail', extra: item);
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
          ),
        );
      },
    );
  }
}
