import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../utils/snackbar_helper.dart';
import '../utils/validators.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscurePass = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

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
    final success = await authProvider.registerWithEmail(
      email: email,
      password: password,
      displayName: _nameController.text.trim(),
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (success) {
      SnackbarHelper.showSuccess(context, 'Sign up berhasil!');
      context.go('/home');
    } else {
      SnackbarHelper.showError(
        context,
        authProvider.errorMessage ?? 'Sign up gagal',
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
              keyboardDismissBehavior:
                  ScrollViewKeyboardDismissBehavior.onDrag,
              physics: const BouncingScrollPhysics(),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 420, // 🔑 tablet, web, desktop
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 30,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          /// ================= HEADER =================
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/Logo.jpg',
                                height: 50,
                                width: 50,
                              ),
                              const SizedBox(width: 10),
                              RichText(
                                text: const TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "Wellness",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 28,
                                        color: Color(0xFF003B88),
                                      ),
                                    ),
                                    TextSpan(
                                      text: "ID",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 28,
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
                            "Daftar",
                            style: TextStyle(
                              fontSize: 28,
                              color: Color(0xFF00A9FF),
                            ),
                          ),

                          const SizedBox(height: 30),

                          _buildTextField(
                            controller: _nameController,
                            label: "Nama",
                            validator: (v) =>
                                v == null || v.isEmpty
                                    ? "Nama tidak boleh kosong"
                                    : null,
                          ),

                          const SizedBox(height: 20),

                          _buildTextField(
                            controller: _emailController,
                            label: "Email",
                            keyboardType: TextInputType.emailAddress,
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return "Email tidak boleh kosong";
                              }
                              final valid = RegExp(
                                      r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$')
                                  .hasMatch(v);
                              return valid
                                  ? null
                                  : "Format email tidak valid";
                            },
                          ),

                          const SizedBox(height: 20),

                          _buildTextField(
                            controller: _passwordController,
                            label: "Kata Sandi",
                            obscureText: _obscurePass,
                            suffixIcon: IconButton(
                              icon: Icon(_obscurePass
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              onPressed: () => setState(
                                  () => _obscurePass = !_obscurePass),
                            ),
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return "Password tidak boleh kosong";
                              }
                              if (v.length < 6) {
                                return "Password minimal 6 karakter";
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 20),

                          _buildTextField(
                            controller: _confirmPasswordController,
                            label: "Konfirmasi Kata Sandi",
                            obscureText: _obscureConfirm,
                            suffixIcon: IconButton(
                              icon: Icon(_obscureConfirm
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              onPressed: () => setState(() =>
                                  _obscureConfirm = !_obscureConfirm),
                            ),
                            validator: (v) =>
                                v != _passwordController.text
                                    ? "Password tidak sesuai"
                                    : null,
                          ),

                          const SizedBox(height: 40),

                          SizedBox(
                            width: double.infinity,
                            height: 55,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _register,
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color(0xFF22B3E4),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: const Text(
                                "Daftar",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Sudah Punya Akun? "),
                              GestureDetector(
                                onTap: () => context.go('/login'),
                                child: const Text(
                                  "Masuk",
                                  style: TextStyle(
                                    color: Colors.lightBlue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          labelText: label,
          border: InputBorder.none,
          suffixIcon: suffixIcon,
        ),
        validator: validator,
      ),
    );
  }
}