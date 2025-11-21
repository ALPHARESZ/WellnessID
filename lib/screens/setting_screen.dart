import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool expandAkun = false;
  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('userData');
    context.go('/login');
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
                      onPressed: () async {
                        Navigator.pop(context);
                        await _logout(context);
                      },
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

  Future<void> _deleteAccount() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    context.go('/login');
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
                onTap: _showDeleteAccountDialog,
              ),
            ),
          ]
        ],
      ),
    );
  }
}
