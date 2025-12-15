import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DiagnosisService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> saveDiagnosis({
    required Map<String, dynamic> diagnosisData,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception("User not logged in");

    final ref = _db
        .collection('users')
        .doc(user.uid)
        .collection('diagnoses')
        .doc();

    await ref.set({
      "id": ref.id,
      ...diagnosisData,
      "createdAt": FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot> diagnosisStream() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception("User not logged in");

    return _db
        .collection('users')
        .doc(user.uid)
        .collection('diagnoses')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Future<Map<String, dynamic>?> getDiagnosisDetail(String id) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    final doc = await _db
        .collection('users')
        .doc(user.uid)
        .collection('diagnoses')
        .doc(id)
        .get();

    return doc.data();
  }
}