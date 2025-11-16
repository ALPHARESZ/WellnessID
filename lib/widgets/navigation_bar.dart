import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppNavigationBar extends StatelessWidget {
  final int currentIndex;
  const AppNavigationBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      selectedItemColor: const Color(0xFF006EFF),
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      onTap: (index) {
        switch (index) {
          case 0:
            context.go('/home');
            break;
          case 1:
            context.go('/medicine');
            break;
          case 2:
            context.go('/chat');
            break;
          case 3:
            context.go('/pengaturan');
            break;
        }
      },
      items: [
        BottomNavigationBarItem(
          icon: Image.asset('assets/images/Logo.jpg', width: 24),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Image.asset('assets/images/Logo.jpg', width: 24),
          label: 'Medicine',
        ),
        BottomNavigationBarItem(
          icon: Image.asset('assets/images/Logo.jpg', width: 24),
          label: 'Chat',
        ),
        BottomNavigationBarItem(
          icon: Image.asset('assets/images/Logo.jpg', width: 24),
          label: 'Akun',
        ),
      ],
    );
  }
}
