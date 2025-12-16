import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/navigation_bar.dart';
import '../widgets/card_list.dart';
import '../widgets/confirmation_popup.dart';
import '../services/diagnose_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future<String?> _getUserName() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return null;

    final doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    return doc.data()?['name'];
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 900),
                child: CustomScrollView(
                  slivers: [
                    // ================= HEADER =================
                    SliverToBoxAdapter(
                      child: Container(
                        height: isLandscape ? 140 : 220, // 🔥 diperkecil
                        width: double.infinity,
                        color: const Color(0xFF22B3E3),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Positioned(
                              right: 20,
                              top: 20,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.settings,
                                  color: Colors.white,
                                  size: 28,
                                ),
                                onPressed: () {
                                  context.go('/setting');
                                },
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: isLandscape ? 80 : 110,
                                  height: isLandscape ? 80 : 110,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Colors.white, width: 4),
                                  ),
                                  child: ClipOval(
                                    child: Image.asset(
                                      'assets/images/Logo.jpg',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    // ================= USER NAME =================
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: FutureBuilder<String?>(
                          future: _getUserName(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: Text(
                                  "Loading...",
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              );
                            }

                            final name = snapshot.data;
                            return Center(
                              child: Text(
                                name == null || name.isEmpty
                                    ? "Pengguna"
                                    : name,
                                style: const TextStyle(
                                  fontSize: 26,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    // ================= DIAGNOSIS LIST =================
                    StreamBuilder<QuerySnapshot>(
                      stream: DiagnosisService().diagnosisStream(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const SliverFillRemaining(
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        if (!snapshot.hasData ||
                            snapshot.data!.docs.isEmpty) {
                          return const SliverFillRemaining(
                            child: Center(
                              child: Text(
                                "Belum ada riwayat diagnosa",
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          );
                        }

                        final docs = snapshot.data!.docs;

                        return SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final doc = docs[index];
                              final data =
                                  doc.data() as Map<String, dynamic>;

                              DateTime date = DateTime.now();
                              if (data['createdAt'] is Timestamp) {
                                date = (data['createdAt'] as Timestamp)
                                    .toDate();
                              }

                              final formattedDate =
                                  "${date.day}-${date.month}-${date.year}";

                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 6),
                                child: CardList(
                                  title: "Hasil Diagnosa ${index + 1}",
                                  subtitle:
                                      "Tanggal Diagnosa: $formattedDate",
                                  trailing: GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        barrierColor:
                                            Colors.black.withOpacity(0.3),
                                        builder: (context) {
                                          return ConfirmationPopup(
                                            title: "Hapus Riwayat?",
                                            onConfirm: () async {
                                              Navigator.pop(context);
                                              await doc.reference.delete();
                                            },
                                            onCancel: () {
                                              Navigator.pop(context);
                                            },
                                          );
                                        },
                                      );
                                    },
                                    child: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                  ),
                                  onTap: () {
                                    context.push(
                                      '/diagnose-detail',
                                      extra: {
                                        "diagnosisId": doc.id,
                                        "data": data,
                                      },
                                    );
                                  },
                                ),
                              );
                            },
                            childCount: docs.length,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),

      bottomNavigationBar: const AppNavigationBar(currentIndex: 3),
    );
  }
}
