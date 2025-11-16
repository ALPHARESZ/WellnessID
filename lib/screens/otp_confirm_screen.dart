import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class ResetOtpPage extends StatefulWidget {
  const ResetOtpPage({super.key});

  @override
  State<ResetOtpPage> createState() => _ResetOtpPageState();
}

class _ResetOtpPageState extends State<ResetOtpPage> {
  String currentOtp = "";

  void _validateOtp() {
    if (currentOtp == "123456") {
      context.go('/reset-password');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Kode OTP tidak valid"), backgroundColor: Colors.red),
      );
    }
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
                'Kode OTP',
                style: TextStyle(
                  color: Color(0xFF00A9FF),
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Masukkan kode OTP yang ada pada alamat email anda',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              PinCodeTextField(
                appContext: context,
                length: 6,
                onChanged: (value) => currentOtp = value,
                keyboardType: TextInputType.number,
                animationType: AnimationType.fade,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(10),
                  fieldHeight: 50,
                  fieldWidth: 40,
                  activeFillColor: Colors.white,
                  inactiveFillColor: Colors.white,
                  selectedFillColor: Colors.white,
                  activeColor: Colors.blueAccent,
                ),
              ),

              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _validateOtp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF22B3E4),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  child: const Text("Kirim",
                      style: TextStyle(color: Colors.white, fontSize: 18)),
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Kode OTP baru telah dikirim."),
                        backgroundColor: Colors.green),
                  );
                },
                child: const Text(
                  "Kirim Ulang",
                  style: TextStyle(
                      color: Color(0xFF00A9FF),
                      fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
