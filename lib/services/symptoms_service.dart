import 'package:cloud_firestore/cloud_firestore.dart';

class SymptomService {
  final _db = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getSymptomsByIds(
      List<String> ids) async {
    if (ids.isEmpty) return [];

    final List<Map<String, dynamic>> result = [];

    // Firestore whereIn max 10
    for (var i = 0; i < ids.length; i += 10) {
      final chunk = ids.sublist(
        i,
        i + 10 > ids.length ? ids.length : i + 10,
      );

      final snapshot = await _db
          .collection('symptoms')
          .where(FieldPath.documentId, whereIn: chunk)
          .get();

      for (final doc in snapshot.docs) {
        result.add({
          "id": doc.id,
          "name": doc['name'],
        });
      }
    }

    return result;
  }
}
