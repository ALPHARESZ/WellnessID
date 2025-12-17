class Medicines {
  final String id;
  final String name;
  final String description;
  final String usage;
  final String sideEffects;
  final List<String> relatedDiseases;

  Medicines({
    required this.id,
    required this.name,
    required this.description,
    required this.usage,
    required this.sideEffects,
    required this.relatedDiseases,
  });

  /// ✅ Buat dari Firestore (dengan document ID)
  factory Medicines.fromFirestore(String id, Map<String, dynamic> data) {
    return Medicines(
      id: id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      usage: data['usage'] ?? '',
      sideEffects: data['sideEffects'] ?? '',
      relatedDiseases: List<String>.from(data['relatedDiseases'] ?? []),
    );
  }

  /// ✅ Tambahkan ini agar bisa terima data dari `context.push(extra: item)`
  factory Medicines.fromMap(Map<String, dynamic> map) {
    return Medicines(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      usage: map['usage'] ?? '',
      sideEffects: map['sideEffects'] ?? '',
      relatedDiseases: List<String>.from(map['relatedDiseases'] ?? []),
    );
  }

  /// ✅ Untuk dikirim balik ke Firestore atau disimpan
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'usage': usage,
      'sideEffects': sideEffects,
      'relatedDiseases': relatedDiseases,
    };
  }
}
