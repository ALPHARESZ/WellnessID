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
import '../screens/result_screen.dart';
import '../screens/detail_screen.dart';
import '../screens/search_disease_screen.dart';
import '../screens/disease_result_screen.dart';

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
      path: '/detail',
      name: 'detail',
      builder: (context, state) => const DetailScreen(),
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
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(child: Text('Halaman tidak ditemukan: ${state.error}')),
  ),
);
