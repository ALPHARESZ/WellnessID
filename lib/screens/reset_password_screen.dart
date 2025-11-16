import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController passC = TextEditingController();
  final TextEditingController confirmC = TextEditingController();
  bool obscure1 = true;
  bool obscure2 = true;

  void _submit() {
    if (passC.text.length < 6) {
      _showError("Password minimal 6 karakter");
      return;
    }
    if (passC.text != confirmC.text) {
      _showError("Konfirmasi password tidak sesuai");
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Kata sandi berhasil diganti!"), backgroundColor: Colors.green),
    );
    Future.delayed(const Duration(seconds: 1), () {
      context.go('/login');
    });
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/Logo.jpg', height: 50),
                  const SizedBox(width: 10),
                  const Text.rich(
                    TextSpan(children: [
                      TextSpan(
                        text: 'Wellness',
                        style: TextStyle(
                            color: Color(0xFF003B88),
                            fontSize: 28,
                            fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: 'ID',
                        style: TextStyle(
                            color: Color(0xFF006FFF),
                            fontSize: 28,
                            fontWeight: FontWeight.bold),
                      ),
                    ]),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              const Text(
                "Ganti Password",
                style: TextStyle(
                    color: Color(0xFF00A9FF),
                    fontSize: 28,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),

              _buildPasswordField(
                  controller: passC,
                  label: "Kata Sandi Baru",
                  obscure: obscure1,
                  toggle: () => setState(() => obscure1 = !obscure1)),

              const SizedBox(height: 20),

              _buildPasswordField(
                  controller: confirmC,
                  label: "Konfirmasi Kata Sandi Baru",
                  obscure: obscure2,
                  toggle: () => setState(() => obscure2 = !obscure2)),

              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF22B3E4),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  child: const Text(
                    "Kirim",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool obscure,
    required VoidCallback toggle,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: IconButton(
          icon: Icon(
            obscure ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: toggle,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }
}
