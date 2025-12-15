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
  final user = FirebaseAuth.instance.currentUser;

  Future<String?> _getUserName() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return null;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();

    return doc.data()?['name'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Column(
          children: [
            // ================= HEADER =================
            Container(
              width: double.infinity,
              height: 220,
              decoration: const BoxDecoration(
                color: Color(0xFF22B3E3),
              ),
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
                        width: 110,
                        height: 110,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 4),
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

            const SizedBox(height: 10),

            // ================= USER NAME =================
            FutureBuilder<String?>(
              future: _getUserName(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text(
                    "Loading...",
                    style: TextStyle(
                      fontSize: 22,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  );
                }

                final name = snapshot.data;
                return Text(
                  name == null || name.isEmpty ? "Pengguna" : name,
                  style: const TextStyle(
                    fontSize: 26,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            // ================= DIAGNOSIS HISTORY =================
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: DiagnosisService().diagnosisStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text(
                        "Belum ada riwayat diagnosa",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          fontSize: 16,
                        ),
                      ),
                    );
                  }

                  final docs = snapshot.data!.docs;

                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: List.generate(docs.length, (index) {
                        final doc = docs[index];
                        final data = doc.data() as Map<String, dynamic>;

                        // ==== SAFE TIMESTAMP PARSING ====
                        DateTime date = DateTime.now();
                        if (data['createdAt'] is Timestamp) {
                          date =
                              (data['createdAt'] as Timestamp).toDate();
                        }

                        final formattedDate =
                            "${date.day}-${date.month}-${date.year}";

                        return CardList(
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
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: const Icon(
                                Icons.delete,
                                size: 22,
                                color: Colors.red,
                              ),
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
                        );
                      }),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar:
          const AppNavigationBar(currentIndex: 3),
    );
  }
}