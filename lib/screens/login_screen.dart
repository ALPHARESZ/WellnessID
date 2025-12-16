import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../utils/snackbar_helper.dart';
import '../utils/validators.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailC = TextEditingController();
  final TextEditingController passC = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    emailC.dispose();
    passC.dispose();
    super.dispose();
  }

  Future<void> _logIn() async {
    final email = emailC.text.trim();
    final password = passC.text;

    final emailError = Validators.validateEmail(email);
    if (emailError != null) {
      SnackbarHelper.showError(context, emailError);
      return;
    }

    final passwordError = Validators.validatePassword(password);
    if (passwordError != null) {
      SnackbarHelper.showError(context, passwordError);
      return;
    }

    setState(() => _isLoading = true);

    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.logInWithEmail(
      email: email,
      password: password,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (success) {
      SnackbarHelper.showSuccess(context, 'Berhasil Masuk!');
      context.go('/home');
    } else {
      SnackbarHelper.showError(
        context,
        authProvider.errorMessage ?? 'Gagal Masuk!',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FF),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 20),

                        /// LOGO
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/Logo.jpg',
                              height: 48,
                              width: 48,
                            ),
                            const SizedBox(width: 10),
                            RichText(
                              text: const TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Wellness',
                                    style: TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF003B88),
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'ID',
                                    style: TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF006FFF),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 40),

                        const Text(
                          "Masuk",
                          style: TextStyle(
                            fontSize: 26,
                            color: Color(0xFF00A9FF),
                          ),
                        ),

                        const SizedBox(height: 30),

                        _inputBox(
                          child: TextField(
                            controller: emailC,
                            enabled: !_isLoading,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              labelText: "Email",
                              hintText: "example@gmail.com",
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        _inputBox(
                          child: TextField(
                            controller: passC,
                            enabled: !_isLoading,
                            obscureText: _obscurePassword,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              labelText: "Kata Sandi",
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () => context.go('/reset-email'),
                            child: const Text(
                              "Lupa Kata Sandi? →",
                              style: TextStyle(
                                color: Colors.lightBlue,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _logIn,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF22B3E4),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: const Text(
                              "Masuk",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Belum Punya Akun? "),
                            GestureDetector(
                              onTap: () => context.go('/register'),
                              child: const Text(
                                "Daftar",
                                style: TextStyle(
                                  color: Colors.lightBlue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _inputBox({required Widget child}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 4,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: child,
    );
  }
}
