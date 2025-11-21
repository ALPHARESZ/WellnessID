import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/navigation_bar.dart';
import '../widgets/card_list.dart';
import '../widgets/confirmation_popup.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final List<Map<String, String>> _diagnosisHistory = [
    {"title": "Hasil Diagnosa 1", "subtitle": "Tanggal Diagnosa: 10 - 10 - 2025"},
    {"title": "Hasil Diagnosa 2", "subtitle": "Tanggal Diagnosa: 14 - 10 - 2025"},
  ];

  void _deleteItem(int index) {
    setState(() {
      _diagnosisHistory.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Column(
          children: [
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
                      icon: const Icon(Icons.settings, color: Colors.white, size: 28),
                      onPressed: () {
                        context.push('/setting');
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

            const Text(
              "Anwar Winata",
              style: TextStyle(
                fontSize: 26,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: List.generate(_diagnosisHistory.length, (index) {
                    final item = _diagnosisHistory[index];

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
                                title: "Hapus Riwayat?",
                                onConfirm: () {
                                  Navigator.pop(context);
                                  _deleteItem(index);
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
                        context.push('/diagnose-detail');
                      },
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AppNavigationBar(currentIndex: 3),
    );
  }
}
