import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/page_header.dart';
import '../widgets/search.dart';
import '../services/expert_system_service.dart';
import '../models/symptom.dart';

class SymptomsPage extends StatefulWidget {
  const SymptomsPage({super.key});

  @override
  State<SymptomsPage> createState() => _SymptomsPageState();
}

class _SymptomsPageState extends State<SymptomsPage> {
  final ExpertSystemService _expertSystem = ExpertSystemService();

  List<Symptom> symptoms = [];
  Set<String> selectedSymptomIds = {};
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadSymptoms();
  }

  Future<void> loadSymptoms() async {
    final data = await _expertSystem.getSymptoms();
    setState(() {
      symptoms = data;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: PageHeader(
          title: 'Diagnosa Penyakit',
          onBack: () => context.pop(),
        ),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  SearchBarWidget(
                    hint: 'Cari Gejala di sini',
                    icon: CupertinoIcons.search,
                  ),
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
                        final isSelected = selectedSymptomIds.contains(s.id);

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                isSelected
                                    ? selectedSymptomIds.remove(s.id)
                                    : selectedSymptomIds.add(s.id);
                              });
                            },
                            child: Row(
                              children: [
                                Checkbox(
                                  value: isSelected,
                                  onChanged: (value) {
                                    setState(() {
                                      value!
                                          ? selectedSymptomIds.add(s.id)
                                          : selectedSymptomIds.remove(s.id);
                                    });
                                  },
                                  activeColor: const Color(0xFF22B3E3),
                                ),
                                Text(
                                  s.name,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
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
                        backgroundColor: selectedSymptomIds.isEmpty
                            ? Colors.grey
                            : const Color(0xFF22B3E3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: selectedSymptomIds.isEmpty
                          ? null
                          : () {
                              context.push(
                                '/result',
                                extra: selectedSymptomIds.toList(),
                              );
                            },
                      child: const Text(
                        'Lihat Hasil Diagnosa',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }
}
