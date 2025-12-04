import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart'; // 🟢 Tambahkan import ini

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

  List<Medicines> savedMedicines = [];
  bool loading = true;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadSavedMedicines();
  }

  /// 🔹 Ambil data obat tersimpan dari Firestore berdasarkan user login
  Future<void> _loadSavedMedicines() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      // Jika belum login, beri peringatan
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Silakan login terlebih dahulu."),
          backgroundColor: Colors.redAccent,
        ),
      );
      setState(() {
        loading = false;
      });
      return;
    }

    final data = await _medicineService.getSavedMedicines(user.uid);
    setState(() {
      savedMedicines = data;
      loading = false;
    });
  }

  /// 🔹 Hapus obat dari Firestore
  Future<void> _deleteMedicine(Medicines medicine) async {
    final user = FirebaseAuth.instance.currentUser;
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
    await _loadSavedMedicines();

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
    final filteredList = savedMedicines.where((m) {
      return m.name.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),

      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: PageHeader(
          title: "Daftar Obat Tersimpan",
          onBack: () => Navigator.pop(context),
        ),
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),

                  // 🔍 Search bar
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

                  Expanded(
                    child: filteredList.isEmpty
                        ? Center(
                            child: Text(
                              "Tidak ada obat tersimpan",
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 18,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          )
                        : ListView.builder(
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
                                      barrierColor:
                                          Colors.black.withOpacity(0.3),
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
                                    child: const Icon(
                                      Icons.delete,
                                      size: 22,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  context.push('/medicine-detail', extra: item);
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
