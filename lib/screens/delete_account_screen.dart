import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../utils/snackbar_helper.dart';

class DeleteAccount extends StatefulWidget {
  const DeleteAccount({super.key});

  @override
  State<DeleteAccount> createState() => _DeleteAccountState();
}

class _DeleteAccountState extends State<DeleteAccount> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();

  bool obscure1 = true;
  bool obscure2 = true;

  Future<void> _deleteAccount() async {
    final authProvider = context.read<AuthProvider>();

    final success = await authProvider.deleteAccount(
      email: emailController.text.trim(),
      password: passController.text,
    );

    if (success) {
      if (!mounted) return;
      SnackbarHelper.showSuccess(context, 'Berhasil Hapus Akun!');
      context.go('/login');
    } else {
      if (!mounted) return;
      final errorMessage = authProvider.errorMessage ?? 'Gagal Hapus Akun!';
      SnackbarHelper.showError(context, errorMessage);
    }
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Hapus Akun?",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Akun Anda akan dihapus permanen dan tidak dapat dipulihkan.",
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade300,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 28, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text("Batal"),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        await _deleteAccount();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 28, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text("Hapus"),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _inputField({
    required String label,
    required TextEditingController controller,
    bool obscure = false,
    VoidCallback? onToggle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xffe8f0fe),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 6,
                offset: const Offset(2, 4),
              )
            ],
          ),
          child: TextField(
            controller: controller,
            obscureText: obscure,
            decoration: InputDecoration(
              hintText: label,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              border: InputBorder.none,
              suffixIcon: onToggle != null
                  ? IconButton(
                      icon: const Icon(Icons.visibility_off),
                      onPressed: onToggle,
                    )
                  : null,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffafafa),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          "Hapus Akun",
          style: TextStyle(
            color: Colors.red,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            keyboardDismissBehavior:
                ScrollViewKeyboardDismissBehavior.onDrag,
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 500, // tablet & desktop friendly
                  minHeight: constraints.maxHeight,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _inputField(
                        label: "Email",
                        controller: emailController,
                      ),

                      const SizedBox(height: 25),

                      _inputField(
                        label: "Kata Sandi",
                        controller: passController,
                        obscure: obscure1,
                        onToggle: () {
                          setState(() {
                            obscure1 = !obscure1;
                          });
                        },
                      ),

                      const SizedBox(height: 25),

                      _inputField(
                        label: "Konfirmasi Kata Sandi",
                        controller: confirmPassController,
                        obscure: obscure2,
                        onToggle: () {
                          setState(() {
                            obscure2 = !obscure2;
                          });
                        },
                      ),

                      const SizedBox(height: 40),

                      GestureDetector(
                        onTap: _showDeleteAccountDialog,
                        child: Container(
                          width: double.infinity,
                          padding:
                              const EdgeInsets.symmetric(vertical: 18),
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                blurRadius: 6,
                                offset: const Offset(2, 4),
                              )
                            ],
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            "Hapus Akun",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
