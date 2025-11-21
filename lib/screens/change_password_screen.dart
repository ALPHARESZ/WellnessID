import 'package:flutter/material.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final TextEditingController currentPass = TextEditingController();
  final TextEditingController newPass = TextEditingController();
  final TextEditingController confirmPass = TextEditingController();

  bool show1 = false;
  bool show2 = false;
  bool show3 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F7FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Ubah Kata Sandi",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),

            label("Kata Sandi Saat Ini"),
            buildPasswordField(currentPass, show1, () {
              setState(() => show1 = !show1);
            }),
            const SizedBox(height: 25),

            label("Kata Sandi  Baru"),
            buildPasswordField(newPass, show2, () {
              setState(() => show2 = !show2);
            }),
            const SizedBox(height: 25),

            label("Konfirmasi Kata Sandi Baru"),
            buildPasswordField(confirmPass, show3, () {
              setState(() => show3 = !show3);
            }),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff19A7CE),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  "Simpan",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget label(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget buildPasswordField(
      TextEditingController controller, bool isVisible, VoidCallback toggle) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xffEAF1FF),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 6,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: !isVisible,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          border: InputBorder.none,
          suffixIcon: IconButton(
            icon: Icon(
              isVisible ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: toggle,
          ),
        ),
      ),
    );
  }
}
