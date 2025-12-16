import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../utils/snackbar_helper.dart';

class InputBoxScreen extends StatefulWidget {
  const InputBoxScreen({super.key});

  @override
  State<InputBoxScreen> createState() => _InputBoxScreenState();
}

class _InputBoxScreenState extends State<InputBoxScreen> {
  final TextEditingController messageController = TextEditingController();
  bool isLoading = false;

  Future<void> sendMessage() async {
    final message = messageController.text.trim();
    final user = FirebaseAuth.instance.currentUser;

    if (message.isEmpty) {
      SnackbarHelper.showError(context, 'Pesan tidak boleh kosong');
      return;
    }

    if (user == null) {
      SnackbarHelper.showError(context, 'Silakan login terlebih dahulu');
      return;
    }

    setState(() => isLoading = true);

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('messages')
          .add({
        'description': message,
        'createdAt': FieldValue.serverTimestamp(),
      });

      messageController.clear();
      SnackbarHelper.showSuccess(context, 'Masukan berhasil dikirim!');
    } catch (e) {
      SnackbarHelper.showError(context, 'Gagal mengirim pesan. Silakan coba lagi.');
    } finally {
      setState(() => isLoading = false);
    }
  }

  void showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        behavior: SnackBarBehavior.floating,
      ),
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
          "Kotak Masukan",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Jika ingin menghubungi kami atau memiliki kritik dan saran silakan isi kolom di bawah ini",
              style: TextStyle(fontSize: 15),
            ),

            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: messageController,
                maxLines: 10,
                decoration: const InputDecoration(
                  hintText: "Tulis pesan Anda di sini...",
                  border: InputBorder.none,
                ),
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : sendMessage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Kirim Masukan"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
