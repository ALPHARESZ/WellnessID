import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../utils/snackbar_helper.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final TextEditingController emailController = TextEditingController();
  bool isLoading = false;

  Future<void> sendResetEmail() async {
    final authProvider = context.read<AuthProvider>();
    final inputEmail = emailController.text.trim();

    // 1️⃣ Validasi input
    if (inputEmail.isEmpty) {
      SnackbarHelper.showError(context, 'Email tidak boleh kosong!');
      return;
    }

    // 2️⃣ Pastikan user sedang login
    final isLoggedIn = await authProvider.checkUser();
    if (!isLoggedIn) {
      SnackbarHelper.showError(context, 'Tidak ada pengguna yang sedang login.');
      return;
    }

    // 3️⃣ Ambil email user yang sedang login
    final currentEmail = authProvider.user?.email;
    if (currentEmail == null) {
      SnackbarHelper.showError(context, 'Gagal mengambil data pengguna.');
      return;
    }

    // 4️⃣ Cek kecocokan email
    if (currentEmail != inputEmail) {
      SnackbarHelper.showError(context, 'Email tidak sesuai dengan akun yang sedang digunakan!');
      return;
    }

    setState(() => isLoading = true);

    // 5️⃣ Kirim email reset password
    final success =
        await authProvider.sendPasswordResetEmail(inputEmail);

    setState(() => isLoading = false);

    if (!success) {
      SnackbarHelper.showError(context, authProvider.errorMessage ?? "Gagal mengirim email reset password.");
      return;
    }

    // 6️⃣ Logout setelah email terkirim
    await authProvider.logOut();

    if (!mounted) return;

    SnackbarHelper.showSuccess(context, 'Email reset password berhasil dikirim. Silakan cek email Anda.');

    // 7️⃣ Redirect ke login
    context.go('/login');
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xffF6F7FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Reset Kata Sandi",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 20,
              bottom: MediaQuery.of(context).viewInsets.bottom + 30,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Text(
                  "Masukkan Email Anda",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xffEAF1FF),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 15,
                      ),
                      hintText: "Email",
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : sendResetEmail,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff19A7CE),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text(
                            "Kirim Email Reset",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
