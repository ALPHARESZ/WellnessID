import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/navigation_bar.dart';

class MedicineScreen extends StatelessWidget {
  const MedicineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),

      bottomNavigationBar: const AppNavigationBar(currentIndex: 1),

      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              height: 80,
              color: Colors.white,
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/Logo.jpg',
                    width: 55,
                    height: 55,
                  ),
                  const SizedBox(width: 12),
                  const Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "Wellness",
                          style: TextStyle(
                            color: Color(0xFF003B88),
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        TextSpan(
                          text: "ID",
                          style: TextStyle(
                            color: Color(0xFF006EFF),
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: GestureDetector(
                onTap: () => context.push('/search-medicine'),
                child: Container(
                  height: 135,
                  decoration: BoxDecoration(
                    color: const Color(0xFF22B3E3),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFF006EFF),
                      width: 2,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 10),
                      )
                    ],
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 30),
                      Image.asset(
                        'assets/images/Logo.jpg',
                        width: 75,
                        height: 75,
                      ),
                      const Spacer(),
                      const Padding(
                        padding: EdgeInsets.only(right: 30),
                        child: Text(
                          'Cari Info\nObat',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: GestureDetector(
                onTap: () => context.push('/saved-medicine'),
                child: Container(
                  height: 135,
                  decoration: BoxDecoration(
                    color: const Color(0xFF22B3E3),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFF006EFF),
                      width: 2,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 10),
                      )
                    ],
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 30),
                      Image.asset(
                        'assets/images/Logo.jpg',
                        width: 75,
                        height: 75,
                      ),
                      const Spacer(),
                      const Padding(
                        padding: EdgeInsets.only(right: 30),
                        child: Text(
                          'Obat\nTersimpan',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
