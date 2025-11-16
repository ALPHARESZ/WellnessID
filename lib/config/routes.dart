import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screens/login_screen.dart';
import '../screens/register_screen.dart';
import '../screens/email_confirm_screen.dart';
import '../screens/otp_confirm_screen.dart';
import '../screens/reset_password_screen.dart';
import '../screens/splash_screen.dart';
import '../screens/home_screen.dart';
import '../screens/identity_screen.dart';
import '../screens/symptoms_screen.dart';
import '../screens/diagnose_result_screen.dart';
import '../screens/disease_detail_screen.dart';
import '../screens/search_disease_screen.dart';
import '../screens/disease_result_screen.dart';
import '../screens/medicine_screen.dart';
import '../screens/search_medicine_screen.dart';
import '../screens/medicine_result_screen.dart';
import '../screens/medicine_detail_screen.dart';
import '../screens/saved_medicine_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
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
      builder: (context, state) => const ResetEmailPage(),
    ),
    GoRoute(
      path: '/otp',
      name: 'otp',
      builder: (context, state) => const ResetOtpPage(),
    ),
    GoRoute(
      path: '/reset-password',
      name: 'reset_password',
      builder: (context, state) => const ResetPasswordPage(),
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
      path: '/disease-detail',
      name: 'disease-detail',
      builder: (context, state) => const DiseaseDetailScreen(),
    ),
    GoRoute(
      path: '/search-disease',
      name: 'search_disease',
      builder: (context, state) => const SearchDiseaseScreen(),
    ),
    GoRoute(
      path: '/disease-result',
      name: 'disease-result',
      builder: (context, state) => const DiseaseResultPage(),
    ),
    GoRoute(
      path: '/medicine',
      name: 'medicine',
      builder: (context, state) => const MedicineScreen(),
    ),
    GoRoute(
      path: '/search-medicine',
      name: 'search_medicine',
      builder: (context, state) => const SearchMedicineScreen(),
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
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(child: Text('Halaman tidak ditemukan: ${state.error}')),
  ),
);
