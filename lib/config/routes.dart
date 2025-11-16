import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screens/login_screen.dart';
import '../screens/register_screen.dart';
import '../screens/email_confirm_screen.dart';
import '../screens/otp_confirm_screen.dart';
import '../screens/reset_password_screen.dart';
import '../screens/splash_screen.dart';

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
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(child: Text('Halaman tidak ditemukan: ${state.error}')),
  ),
);
