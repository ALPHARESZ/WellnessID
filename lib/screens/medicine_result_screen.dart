import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/search.dart';
import '../widgets/page_header.dart';
import '../widgets/card_list.dart';

class MedicineResultScreen extends StatefulWidget {
  const MedicineResultScreen({super.key});

  @override
  State<MedicineResultScreen> createState() => _MedicineResultScreenState();
}

class _MedicineResultScreenState extends State<MedicineResultScreen> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<Map<String, dynamic>> filteredMedicines = [];
  Set<String> savedIds = {};
  bool loading = false;
  String lastQuery = "";

  /// 🔍 Fungsi pencarian case-insensitive langsung ke Firestore
  Future<void> _searchMedicine(String query) async {
    final lowerQuery = query.trim().toLowerCase();

    if (lowerQuery.isEmpty) {
      setState(() {
        filteredMedicines = [];
        lastQuery = "";
      });
      return;
    }

    if (lowerQuery == lastQuery) return;

    setState(() {
      loading = true;
      lastQuery = lowerQuery;
    });

    try {
      final snapshot = await _db.collection('medicines').get();
      final results = snapshot.docs.map((doc) {
        return {'id': doc.id, ...doc.data()};
      }).where((m) {
        final name = (m['name'] ?? '').toString().toLowerCase();
        return name.contains(lowerQuery);
      }).toList();

      setState(() {
        filteredMedicines = results;
        loading = false;
      });
    } catch (e) {
      debugPrint("Error searching medicines: $e");
      setState(() => loading = false);
    }
  }

  /// 💾 Simpan obat ke koleksi user
  Future<void> _saveMedicine(Map<String, dynamic> medicine) async {
    final user = _auth.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Silakan login untuk menyimpan obat."),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final userId = user.uid;
    final medicineId = medicine['id'];

    if (savedIds.contains(medicineId)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("${medicine['name']} sudah tersimpan."),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    await _db
        .collection('users')
        .doc(userId)
        .collection('saved_medicines')
        .doc(medicineId)
        .set({
      'name': medicine['name'],
      'description': medicine['description'] ?? '',
      'dateSaved': FieldValue.serverTimestamp(),
    });

    setState(() {
      savedIds.add(medicineId);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("${medicine['name']} berhasil disimpan."),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final bool isWideScreen = screenWidth > 600;

        return Scaffold(
          backgroundColor: const Color(0xFFF8F9FE),
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(56),
            child: PageHeader(
              title: "Cari Info Obat",
              onBack: () => Navigator.pop(context),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1000),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),

                      /// 🔍 Search bar
                      SearchBarWidget(
                        hint: "Cari Info Obat di sini",
                        icon: Icons.search,
                        onChanged: _searchMedicine,
                        onSubmitted: _searchMedicine,
                      ),

                      const SizedBox(height: 20),

                      /// 🔄 Loading / Empty / Hasil Pencarian
                      if (loading)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 100),
                            child: CircularProgressIndicator(),
                          ),
                        )
                      else if (filteredMedicines.isEmpty && lastQuery.isEmpty)
                        const SizedBox(
                          height: 400,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.search, size: 100, color: Colors.grey),
                                SizedBox(height: 10),
                                Text(
                                  "Silahkan cari informasi obat",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontFamily: "Poppins",
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      else if (filteredMedicines.isEmpty)
                        const SizedBox(
                          height: 400,
                          child: Center(
                            child: Text(
                              "Tidak ada obat ditemukan.",
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        )
                      else
                        ListView.builder(
                          itemCount: filteredMedicines.length,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            final item = filteredMedicines[index];
                            final isSaved = savedIds.contains(item['id']);

                            return CardList(
                              title: item["name"] ?? "Tanpa Nama",
                              subtitle:
                                  "Deskripsi: ${item["description"] ?? '-'}",
                              trailing: GestureDetector(
                                onTap: () => _saveMedicine(item),
                                child: Container(
                                  key: ValueKey(isSaved),
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: isSaved
                                        ? Colors.green
                                        : const Color(0xFF22B3E3),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    isSaved ? Icons.check : Icons.add,
                                    size: isWideScreen ? 26 : 22,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              onTap: () {
                                context.push(
                                  '/medicine-detail',
                                  extra: item,
                                );
                              },
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
