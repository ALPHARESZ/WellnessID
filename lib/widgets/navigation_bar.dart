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
            context.go('/profile');
            break;
        }
      },
      items: [
        BottomNavigationBarItem(
          icon: Image.asset(
            currentIndex == 0
                ? 'assets/images/SelectedHome.png'
                : 'assets/images/UnselectedHome.png',
            width: 32,
          ),
          label: 'Beranda',
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            currentIndex == 1
                ? 'assets/images/SelectedMedicine.png'
                : 'assets/images/UnselectedMedicine.png',
            width: 32,
          ),
          label: 'Obat',
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            currentIndex == 2
                ? 'assets/images/SelectedChat.png'
                : 'assets/images/UnselectedChat.png',
            width: 32,
          ),
          label: 'Chat',
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            currentIndex == 3
                ? 'assets/images/SelectedProfile.png'
                : 'assets/images/UnselectedProfile.png',
            width: 32,
          ),
          label: 'Akun',
        ),
      ],
    );
  }
}
