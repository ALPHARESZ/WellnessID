import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/navigation_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      bottomNavigationBar: const AppNavigationBar(currentIndex: 0),

      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 700;

            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
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

                    SizedBox(height: isWide ? 30 : 40),

                    Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: isWide ? 600 : double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: GestureDetector(
                            onTap: () => context.push('/identity'),
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
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  const SizedBox(width: 30),
                                  Image.asset(
                                    'assets/images/Diagnose.png',
                                    width: 75,
                                    height: 75,
                                  ),
                                  const Spacer(),
                                  const Padding(
                                    padding: EdgeInsets.only(right: 30),
                                    child: Text(
                                      'Diagnosa\nPenyakit',
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
                      ),
                    ),

                    SizedBox(height: isWide ? 30 : 40),

                    Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: isWide ? 600 : double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: GestureDetector(
                            onTap: () => context.push('/search-disease'),
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
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  const SizedBox(width: 30),
                                  Image.asset(
                                    'assets/images/DiseaseList.png',
                                    width: 75,
                                    height: 75,
                                  ),
                                  const Spacer(),
                                  const Padding(
                                    padding: EdgeInsets.only(right: 30),
                                    child: Text(
                                      'Cari Info\nPenyakit',
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
                      ),
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
