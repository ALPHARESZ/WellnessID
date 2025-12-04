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

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'usage': usage,
      'sideEffects': sideEffects,
      'relatedDiseases': relatedDiseases,
    };
  }
}
