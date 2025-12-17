import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/page_header.dart';
import '../services/expert_system_service.dart';
import '../models/symptom.dart';

class SymptomsPage extends StatefulWidget {
  const SymptomsPage({super.key});

  @override
  State<SymptomsPage> createState() => _SymptomsPageState();
}

class _SymptomsPageState extends State<SymptomsPage> {
  final ExpertSystemService _expert = ExpertSystemService();
  List<Symptom> symptoms = [];
  final Set<String> selected = {};
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final s = await _expert.getSymptoms();
    setState(() {
      symptoms = s;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: PageHeader(title: 'Diagnosa Penyakit', onBack: () => context.pop()),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth >= 700;

                return Align(
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    width: isWide ? 700 : double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 25),
                          const Text(
                            'Gejala',
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Expanded(
                            child: ListView.builder(
                              itemCount: symptoms.length,
                              itemBuilder: (context, index) {
                                final s = symptoms[index];
                                final isSelected = selected.contains(s.id);
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isSelected
                                            ? selected.remove(s.id)
                                            : selected.add(s.id);
                                      });
                                    },
                                    child: Row(
                                      children: [
                                        Checkbox(
                                          value: isSelected,
                                          onChanged: (v) => setState(
                                            () => v!
                                                ? selected.add(s.id)
                                                : selected.remove(s.id),
                                          ),
                                          activeColor: const Color(0xFF22B3E3),
                                        ),
                                        Expanded(
                                          child: Text(
                                            s.name,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: selected.isEmpty
                                    ? Colors.grey
                                    : const Color(0xFF22B3E3),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                              ),
                              onPressed: selected.isEmpty
                                  ? null
                                  : () {
                                      context.push(
                                        '/result',
                                        extra: selected.toList(),
                                      );
                                    },
                              child: const Text(
                                'Lihat Hasil Diagnosa',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
