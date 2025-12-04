import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/disease.dart';
import '../models/symptom.dart';

class ExpertSystemService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Ambil semua gejala dari Firestore
  Future<List<Symptom>> getSymptoms() async {
    final snapshot = await _db.collection('symptoms').get();

    return snapshot.docs
        .map(
          (doc) => Symptom.fromFirestore(
            doc.id,
            doc.data(),
          ),
        )
        .toList();
  }

  /// Ambil semua penyakit dari Firestore
  Future<List<Disease>> getDiseases() async {
    final snapshot = await _db.collection('diseases').get();

    return snapshot.docs
        .map(
          (doc) => Disease.fromFirestore(
            doc.id,
            doc.data(),
          ),
        )
        .toList();
  }

  /// Fungsi utama diagnosis
  ///
  /// [selectedSymptomIds] = daftar ID gejala yang dicentang user, misal ["S1","S3","S5"]
  /// return: disease dengan skor tertinggi, atau null jika tidak ada yang memenuhi threshold.
  Future<Disease?> diagnose(List<String> selectedSymptomIds) async {
    if (selectedSymptomIds.isEmpty) return null;

    final diseases = await getDiseases();

    Disease? bestDisease;
    double bestScore = 0.0;

    for (final disease in diseases) {
      final score = _calculateMatchScore(
        disease.symptomIds,
        selectedSymptomIds,
      );

      // Hanya pertimbangkan kalau melewati threshold-nya
      if (score >= disease.threshold && score > bestScore) {
        bestScore = score;
        bestDisease = disease;
      }
    }

    return bestDisease;
  }

  /// Hitung skor kecocokan: (jumlah gejala yang cocok) / (total gejala penyakit)
  double _calculateMatchScore(
    List<String> diseaseSymptomIds,
    List<String> selectedSymptomIds,
  ) {
    if (diseaseSymptomIds.isEmpty) return 0.0;

    int matchCount = 0;

    for (final id in diseaseSymptomIds) {
      if (selectedSymptomIds.contains(id)) {
        matchCount++;
      }
    }

    return matchCount / diseaseSymptomIds.length;
  }
}
