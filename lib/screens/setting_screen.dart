import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../utils/snackbar_helper.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool expandAkun = false;

    Future<void> _logOut() async {
    // Call AuthProvider
    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.logOut();

    // Handle result
    if (success) {
      if (mounted) {
        SnackbarHelper.showSuccess(context, 'Berhasil Keluar!');
        context.go('/login');
      }
    } else {
      if (mounted) {
        final errorMessage = authProvider.errorMessage ?? 'Gagal Keluar';
        SnackbarHelper.showError(context, errorMessage);
      }
    }
  }

  void _showLogoutDialog() {
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
                  "Keluar dari Akun?",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade300,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text("Tidak"),
                    ),

                    ElevatedButton(
                      onPressed: _logOut,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text("Ya"),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          "Pengaturan",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      body: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.mail_outline),
            title: const Text("Kotak Masukan"),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push("/input-box"),
          ),

          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text("Pengaturan Akun"),
            trailing: Icon(
              expandAkun ? Icons.expand_less : Icons.expand_more,
            ),
            onTap: () {
              setState(() {
                expandAkun = !expandAkun;
              });
            },
          ),

          if (expandAkun) ...[
            Padding(
              padding: const EdgeInsets.only(left: 60),
              child: ListTile(
                leading: const Icon(Icons.person),
                title: const Text("Ubah Profil"),
                onTap: () => context.push("/change-profile"),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 60),
              child: ListTile(
                leading: const Icon(Icons.key),
                title: const Text("Ubah Kata Sandi"),
                onTap: () => context.push("/change-password"),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 60),
              child: ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text(
                  "Keluar",
                  style: TextStyle(color: Colors.red),
                ),
                onTap: _showLogoutDialog,
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 60),
              child: ListTile(
                leading: const Icon(Icons.delete_forever, color: Colors.red),
                title: const Text(
                  "Hapus Akun",
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () => context.push("/delete-account"),
              ),
            ),
          ]
        ],
      ),
    );
  }
}
