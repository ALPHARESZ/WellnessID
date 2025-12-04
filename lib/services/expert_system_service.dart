import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/disease.dart';
import '../models/symptom.dart';

class DiagnosisResult {
  final Disease disease;
  final double score;

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

  Future<List<DiagnosisResult>> diagnose(List<String> selectedSymptoms) async {
    final diseases = await getDiseases();

    final List<DiagnosisResult> results = [];

    for (final disease in diseases) {
      final total = disease.symptoms.length;
      if (total == 0) {
        continue;
      }

      final matched = disease.symptoms.where((id) => selectedSymptoms.contains(id)).length;

      if (matched == 0) continue;
      
      final score = matched / total;

      print('Disease ${disease.id} (${disease.name}) total=$total matched=$matched score=$score');

      if (score > disease.threshold) {
        results.add(DiagnosisResult(disease: disease, score: score));
      }
    }

    results.sort((a, b) => b.score.compareTo(a.score));

    return results;
  }
}
