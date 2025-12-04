class Symptom {
  final String id;
  final String name;

  Symptom({
    required this.id,
    required this.name,
  });

  factory Symptom.fromFirestore(String id, Map<String, dynamic> data) {
    return Symptom(
      id: id,
      name: data['name'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
    };
  }
}
