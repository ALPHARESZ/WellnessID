import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/disease.dart';
import '../models/symptom.dart';

class DiagnosisResult {
  final Disease disease;
  final double score; // 0..1

  DiagnosisResult({required this.disease, required this.score});
}

class ExpertSystemService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<Symptom>> getSymptoms() async {
    final snapshot = await _db.collection('symptoms').get();
    return snapshot.docs.map((d) => Symptom.fromFirestore(d.id, d.data())).toList();
  }

  Future<List<Disease>> getDiseases() async {
    final snapshot = await _db.collection('diseases').get();
    return snapshot.docs.map((d) => Disease.fromFirestore(d.id, d.data())).toList();
  }

  /// Kembalikan list hasil (tersaring dengan threshold disease) terurut desc
  Future<List<DiagnosisResult>> diagnose(List<String> selectedSymptoms) async {
    final diseases = await getDiseases();

    final List<DiagnosisResult> results = [];

    for (final disease in diseases) {
      final total = disease.symptoms.length;
      if (total == 0) {
        // jika tidak ada gejala terdaftar, anggap score 0
        continue;
      }

      final matched = disease.symptoms.where((id) => selectedSymptoms.contains(id)).length;

      // dua pilihan perhitungan (pilih yang cocok untuk proyekmu):
      // A) matched / total  (kita gunakan ini sesuai deskripsi awal)
      final score = matched / total;

      // debug print (bisa dilihat di console)
      print('Disease ${disease.id} (${disease.name}) total=$total matched=$matched score=$score');

      if (score > disease.threshold) {
        results.add(DiagnosisResult(disease: disease, score: score));
      }
    }

    // urutkan desc
    results.sort((a, b) => b.score.compareTo(a.score));

    return results;
  }
}
