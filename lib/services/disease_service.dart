import 'package:cloud_firestore/cloud_firestore.dart';

class DiseaseService {
  final _db = FirebaseFirestore.instance;

  // =========================
  // SEARCH DISEASE
  // =========================
  Future<List<Map<String, dynamic>>> searchDisease(String keyword) async {
    final lowerKeyword = keyword.toLowerCase();

    final snapshot = await _db.collection('diseases').get();

    return snapshot.docs
        .map((doc) {
          final data = doc.data();

          return {
            "id": doc.id,
            "name": data["name"],
            "description": data["description"],
          };
        })
        .where((item) {
          final name =
              (item["name"] ?? "").toString().toLowerCase();

          return name.contains(lowerKeyword);
        })
        .toList();
  }

  Future<Map<String, dynamic>?> getDiseaseById(String id) async {
    if (id.isEmpty) return null;

    final doc =
        await _db.collection('diseases').doc(id).get();

    if (!doc.exists) return null;

    return {
      "id": doc.id,
      ...doc.data() as Map<String, dynamic>,
    };
  }

  // =========================
  // RESOLVE SYMPTOM NAMES
  // =========================
  Future<List<String>> getSymptomNames(
      List<dynamic> symptomIds) async {
    if (symptomIds.isEmpty) return [];

    final futures = symptomIds.map((id) async {
      final doc = await _db.collection('symptoms').doc(id).get();
      return doc.exists ? doc['name'] as String : null;
    });

    final results = await Future.wait(futures);
    return results.whereType<String>().toList();
  }

  // =========================
  // RESOLVE MEDICINE NAMES
  // =========================
  Future<List<String>> getMedicineNames(
      List<dynamic> medicineIds) async {
    if (medicineIds.isEmpty) return [];

    final futures = medicineIds.map((id) async {
      final doc = await _db.collection('medicines').doc(id).get();
      return doc.exists ? doc['name'] as String : null;
    });

    final results = await Future.wait(futures);
    return results.whereType<String>().toList();
  }
}
