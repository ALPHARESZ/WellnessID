import 'package:cloud_firestore/cloud_firestore.dart';

class DiseaseService {
  final CollectionReference diseasesRef =
      FirebaseFirestore.instance.collection('diseases');

  // Search by name
  Future<List<Map<String, dynamic>>> searchDisease(String keyword) async {
  final lowerKeyword = keyword.toLowerCase();

  final querySnapshot = await FirebaseFirestore.instance
      .collection('diseases')
      .get();

  return querySnapshot.docs
      .map((doc) => {...doc.data(), "id": doc.id})
      .where((item) {
        final name = (item["name"] ?? "").toString().toLowerCase();
        final desc = (item["description"] ?? "").toString().toLowerCase();

        return name.contains(lowerKeyword) || desc.contains(lowerKeyword);
      })
      .toList();
}

  // Get detail
  Future<Map<String, dynamic>?> getDiseaseById(String id) async {
    final doc = await diseasesRef.doc(id).get();
    if (!doc.exists) return null;
    return {"id": doc.id, ...doc.data() as Map<String, dynamic>};
  }
}
