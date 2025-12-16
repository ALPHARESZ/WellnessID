import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../widgets/page_header.dart';
import '../providers/diagnose_provider.dart';
import '../utils/snackbar_helper.dart';

class IdentityScreen extends StatefulWidget {
  const IdentityScreen({super.key});

  @override
  State<IdentityScreen> createState() => _IdentityScreenState();
}

class _IdentityScreenState extends State<IdentityScreen> {
  final TextEditingController umurC = TextEditingController();
  final TextEditingController tinggiC = TextEditingController();
  final TextEditingController beratC = TextEditingController();

  String gender = "Laki-Laki";
  String alergi = "Tidak";

  void _submit() {
    final umurText = umurC.text.trim();
    final tinggiText = tinggiC.text.trim();
    final beratText = beratC.text.trim();

    if (umurText.isEmpty ||
        tinggiText.isEmpty ||
        beratText.isEmpty) {
      SnackbarHelper.showError(
        context,
        "Semua data wajib diisi",
      );
      return;
    }

    final umur = int.tryParse(umurText);
    final tinggi = double.tryParse(tinggiText);
    final berat = double.tryParse(beratText);

    if (umur == null || umur <= 0) {
      SnackbarHelper.showError(
        context,
        "Umur harus berupa angka yang valid",
      );
      return;
    }

    if (tinggi == null || tinggi <= 0) {
      SnackbarHelper.showError(
        context,
        "Tinggi badan harus berupa angka yang valid",
      );
      return;
    }

    if (berat == null || berat <= 0) {
      SnackbarHelper.showError(
        context,
        "Berat badan harus berupa angka yang valid",
      );
      return;
    }

    context.read<DiagnosisProvider>().setIdentity(
      userAge: umur,
      userGender: gender,
      userHeight: tinggi,
      userWeight: berat,
      userAllergies: alergi,
    );

    context.push('/symptoms');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 700;

            return SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 30),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    width: isWide ? 600 : double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PageHeader(
                          title: "Diagnosa Penyakit",
                          onBack: () => context.pop(),
                        ),

                        const SizedBox(height: 10),

                        _inputBox(
                          label: "Umur",
                          child: TextField(
                            controller: umurC,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Masukkan umur",
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        _inputBox(
                          label: "Jenis Kelamin",
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _toggleButton(
                                text: "Laki-Laki",
                                active: gender == "Laki-Laki",
                                onTap: () =>
                                    setState(() => gender = "Laki-Laki"),
                              ),
                              _toggleButton(
                                text: "Perempuan",
                                active: gender == "Perempuan",
                                onTap: () =>
                                    setState(() => gender = "Perempuan"),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        _inputBox(
                          label: "Tinggi Badan (cm)",
                          child: TextField(
                            controller: tinggiC,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Masukkan tinggi badan",
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        _inputBox(
                          label: "Berat Badan (Kg)",
                          child: TextField(
                            controller: beratC,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Masukkan berat badan",
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        _inputBox(
                          label: "Alergi Obat",
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _toggleButton(
                                text: "Ya",
                                active: alergi == "Ya",
                                onTap: () =>
                                    setState(() => alergi = "Ya"),
                              ),
                              _toggleButton(
                                text: "Tidak",
                                active: alergi == "Tidak",
                                onTap: () =>
                                    setState(() => alergi = "Tidak"),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 40),

                        Center(
                          child: GestureDetector(
                            onTap: _submit,
                            child: Container(
                              width: 300,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 18),
                              decoration: BoxDecoration(
                                color: const Color(0xFF22B3E3),
                                borderRadius: BorderRadius.circular(50),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 6,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: const Text(
                                "Lanjut Diagnosa",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                ),
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
          },
        ),
      ),
    );
  }

  Widget _inputBox({required String label, required Widget child}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontFamily: 'Poppins',
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 6),
          child,
        ],
      ),
    );
  }

  Widget _toggleButton({
    required String text,
    required bool active,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 110,
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: active ? const Color(0xFF22B3E3) : Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: const Color(0xFF22B3E3)),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 2,
              offset: Offset(0, 2),
            )
          ],
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: active ? Colors.white : const Color(0xFF22B3E3),
          ),
        ),
      ),
    );
  }
}