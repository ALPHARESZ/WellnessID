import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

class EmailConfirmScreen extends StatefulWidget {
  const EmailConfirmScreen({super.key});

  @override
  State<EmailConfirmScreen> createState() => _EmailConfirmScreenState();
}

class _EmailConfirmScreenState extends State<EmailConfirmScreen> {
  final TextEditingController emailC = TextEditingController();
  bool _isValid = false;

  @override
  void dispose() {
    emailC.dispose();
    super.dispose();
  }

  void _checkEmail() {
    final email = emailC.text.trim();
    final valid = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
    setState(() => _isValid = valid);
  }

  Future<void> _sendResetEmail() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailC.text.trim());

      // Notifikasi sukses
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Email reset kata sandi telah dikirim!"),
          backgroundColor: Colors.green,
        ),
      );

      // Arahkan kembali ke halaman login
      context.go('/login');
    } catch (e) {
      // Tampilkan error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Gagal mengirim email reset: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lupa Kata Sandi"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              "Masukkan email kamu untuk menerima link reset password.",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: emailC,
              keyboardType: TextInputType.emailAddress,
              onChanged: (_) => _checkEmail(),
              decoration: const InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isValid ? _sendResetEmail : null,
                child: const Text("Kirim Link Reset"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
