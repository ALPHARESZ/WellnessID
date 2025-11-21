import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class InputBoxScreen extends StatefulWidget {
  const InputBoxScreen({super.key});

  @override
  State<InputBoxScreen> createState() => _InputBoxScreenState();
}

class _InputBoxScreenState extends State<InputBoxScreen> {
  final TextEditingController messageController = TextEditingController();

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
                onPressed: () {
                  debugPrint("Pesan: ${messageController.text}");
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,       
                  foregroundColor: Colors.white,       
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text("Kirim Masukan"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
