import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/medicines.dart';

class MedicinesService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Ambil semua obat dari koleksi 'medicines'
  Future<List<Medicines>> getAllMedicines() async {
    final snapshot = await _db.collection('medicines').get();
    return snapshot.docs
        .map((doc) => Medicines.fromFirestore(doc.id, doc.data()))
        .toList();
  }

  /// 🔍 Cari obat berdasarkan nama (menggunakan Firestore query, bukan fetch semua)
  Future<List<Medicines>> searchMedicines(String query) async {
  final trimmedQuery = query.trim().toLowerCase(); // ubah keyword jadi lowercase
  if (trimmedQuery.isEmpty) return [];

  final snapshot = await _db
      .collection('medicines')
      .where('name_lower', isGreaterThanOrEqualTo: trimmedQuery)
      .where('name_lower', isLessThan: trimmedQuery + '\uf8ff')
      .get();

  return snapshot.docs
      .map((doc) => Medicines.fromFirestore(doc.id, doc.data()))
      .toList();
}



  /// Simpan obat ke daftar tersimpan (per user)
  Future<void> saveMedicine(String userId, Medicines medicine) async {
    await _db
        .collection('users')
        .doc(userId)
        .collection('saved_medicines')
        .doc(medicine.id)
        .set({
      'name': medicine.name,
      'dateSaved': FieldValue.serverTimestamp(),
    });
  }

  /// Ambil semua obat tersimpan user
  Future<List<Medicines>> getSavedMedicines(String userId) async {
    final snapshot = await _db
        .collection('users')
        .doc(userId)
        .collection('saved_medicines')
        .get();

    if (snapshot.docs.isEmpty) return [];

    // ambil id dari obat yang disimpan
    final ids = snapshot.docs.map((doc) => doc.id).toList();

    // ambil detail obat dari koleksi utama 'medicines'
    final medicineSnapshot = await _db
        .collection('medicines')
        .where(FieldPath.documentId, whereIn: ids)
        .get();

    return medicineSnapshot.docs
        .map((doc) => Medicines.fromFirestore(doc.id, doc.data()))
        .toList();
  }

  /// Hapus obat dari daftar tersimpan user
  Future<void> deleteSavedMedicine(String userId, String medicineId) async {
    await _db
        .collection('users')
        .doc(userId)
        .collection('saved_medicines')
        .doc(medicineId)
        .delete();
  }
}
