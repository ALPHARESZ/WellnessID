import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

import '../screens/login_screen.dart';
import '../screens/register_screen.dart';
import '../screens/email_confirm_screen.dart';
import '../screens/splash_screen.dart';
import '../screens/home_screen.dart';
import '../screens/identity_screen.dart';
import '../screens/symptoms_screen.dart';
import '../screens/diagnose_result_screen.dart';
import '../screens/disease_detail_screen.dart';
import '../screens/search_disease_screen.dart';
import '../screens/disease_result_screen.dart';
import '../screens/medicine_screen.dart';
import '../screens/medicine_result_screen.dart';
import '../screens/medicine_detail_screen.dart';
import '../screens/saved_medicine_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/diagnose_detail_screen.dart';
import '../screens/setting_screen.dart';
import '../screens/input_box_screen.dart';
import '../screens/change_profile_screen.dart';
import '../screens/change_password_screen.dart';
import '../screens/delete_account_screen.dart';


final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  redirect: (context, state) {
    final user = FirebaseAuth.instance.currentUser;
    final isAuthenticated = user != null;
    final isAuthRoute =
        state.matchedLocation == '/login' ||
        state.matchedLocation == '/register' ||
        state.matchedLocation == '/reset-email' ||
        state.matchedLocation == '/otp' ||
        state.matchedLocation == '/reset-password';
    if (!isAuthenticated && !isAuthRoute) {
      return '/login';
    }
    if (isAuthenticated && isAuthRoute) {
      return '/home';
    }
    return null;
  },
  refreshListenable: AuthStateNotifier(),
  routes: [
    GoRoute(
      path: '/',
      name: 'splash_screen',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/register',
      name: 'register',
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(
      path: '/reset-email',
      name: 'reset_email',
      builder: (context, state) => const EmailConfirmScreen(),
    ),
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/identity',
      name: 'identity',
      builder: (context, state) => const IdentityScreen(),
    ),
    GoRoute(
      path: '/symptoms',
      name: 'symptoms',
      builder: (context, state) => const SymptomsPage(),
    ),
    GoRoute(
      path: '/result',
      name: 'result',
      builder: (context, state) => const DiagnoseResultPage(),
    ),
    GoRoute(
      path: '/search-disease',
      name: 'search_disease',
      builder: (context, state) => const SearchDiseaseScreen(),
    ),
    GoRoute(
      path: '/disease-result',
      builder: (context, state) {
        final keyword = state.extra as String;
        return DiseaseResultScreen(keyword: keyword);
      },
    ),
    GoRoute(
      path: '/disease-detail',
      builder: (context, state) {
        final extra = state.extra;

        if (extra is String) {
          return DiseaseDetailScreen(diseaseId: extra);
        }

        if (extra is Map) {
          final disease = extra['disease'];
          return DiseaseDetailScreen(diseaseId: disease.id);
        }

        return const Scaffold(
          body: Center(child: Text("Invalid route parameter")),
        );
      },
    ),
    GoRoute(
      path: '/medicine',
      name: 'medicine',
      builder: (context, state) => const MedicineScreen(),
    ),
    GoRoute(
      path: '/medicine-result',
      name: 'medicine-result',
      builder: (context, state) => const MedicineResultScreen(),
    ),
    GoRoute(
      path: '/saved-medicine',
      name: 'saved-medicine',
      builder: (context, state) => const SavedMedicineScreen(),
    ),
    GoRoute(
      path: '/medicine-detail',
      name: 'medicine-detail',
      builder: (context, state) => const MedicineDetailScreen(),
    ),
    GoRoute(
      path: '/profile',
      name: 'profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/diagnose-detail',
      name: 'diagnose-detail',
      builder: (context, state) => const DiagnoseDetailScreen(),
    ),
    GoRoute(
      path: '/setting',
      name: 'setting,',
      builder: (context, state) => const SettingScreen(),
    ),
    GoRoute(
      path: '/input-box',
      name: 'input-box,',
      builder: (context, state) => const InputBoxScreen(),
    ),
    GoRoute(
      path: '/change-profile',
      name: 'change-profile,',
      builder: (context, state) => const ChangeProfile(),
    ),
    GoRoute(
      path: '/change-password',
      name: 'change-password,',
      builder: (context, state) => const ChangePassword(),
    ),
    GoRoute(
      path: '/delete-account',
      name: 'delete-account,',
      builder: (context, state) => const DeleteAccount(),
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(child: Text('Halaman tidak ditemukan: ${state.error}')),
  ),
);

class AuthStateNotifier extends ChangeNotifier {
  AuthStateNotifier() {
    FirebaseAuth.instance.authStateChanges().listen((_) {
      notifyListeners();
    });
  }
}