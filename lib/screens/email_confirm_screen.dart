import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ResetEmailPage extends StatefulWidget {
  const ResetEmailPage({super.key});

  @override
  State<ResetEmailPage> createState() => _ResetEmailPageState();
}

class _ResetEmailPageState extends State<ResetEmailPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailC = TextEditingController();
  bool _isValid = false;

  void _validateEmail(String value) {
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    setState(() => _isValid = regex.hasMatch(value));
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
                'Lupa Kata Sandi',
                style: TextStyle(
                  color: Color(0xFF00A9FF),
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Masukkan alamat email anda. Anda akan menerima kode OTP untuk mengganti kata sandi anda.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black87, fontSize: 15),
              ),
              const SizedBox(height: 30),

              Form(
                key: _formKey,
                child: TextFormField(
                  controller: emailC,
                  onChanged: _validateEmail,
                  decoration: InputDecoration(
                    labelText: "Email",
                    prefixIcon: const Icon(Icons.email_outlined),
                    suffixIcon: _isValid
                        ? const Icon(Icons.check_circle, color: Colors.green)
                        : const Icon(Icons.error, color: Colors.red),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    errorText:
                        _isValid || emailC.text.isEmpty ? null : "Alamat email tidak valid.",
                  ),
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isValid
                      ? () {
                          context.go('/otp');
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF22B3E4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 4,
                  ),
                  child: const Text(
                    'Kirim',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
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
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
