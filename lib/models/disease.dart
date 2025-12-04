class Disease {
  final String id;                 // doc ID: "D1"
  final String name;
  final String description;
  final List<String> symptomIds;   // daftar ID gejala yang terkait
  final double threshold;          // ambang minimal kecocokan (0–1)

  Disease({
    required this.id,
    required this.name,
    required this.description,
    required this.symptomIds,
    required this.threshold,
  });

  factory Disease.fromFirestore(String id, Map<String, dynamic> data) {
    return Disease(
      id: id,
      name: data['name'] as String,
      description: data['description'] as String,
      symptomIds: List<String>.from(data['symptoms'] ?? []),
      threshold: (data['threshold'] ?? 0.5).toDouble(),
    );
  }

  // Map<String, dynamic> toMap() {
  //   return {
  //     'name': name,
  //     'description': description,
  //     'symptomIds': symptomIds,
  //     'threshold': threshold,
  //   };
  // }
}
