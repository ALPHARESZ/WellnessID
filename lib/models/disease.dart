import 'dart:convert';

class Disease {
  final String id;
  final String name;
  final String description;
  final List<String> symptoms; // sumbernya field 'symptoms' pada Firestore
  final double threshold;
  final String solution;

  Disease({
    required this.id,
    required this.name,
    required this.description,
    required this.symptoms,
    required this.threshold,
    required this.solution,
  });

  factory Disease.fromFirestore(String id, Map<String, dynamic> data) {
    // read symptoms, support both: array OR stringified-json OR legacy 'symptoms' field
    dynamic s = data['symptoms'] ?? data['symptoms'] ?? [];
    List<String> symptomList = [];

    if (s is String) {
      try {
        final parsed = json.decode(s);
        if (parsed is List) {
          symptomList = parsed.map((e) => e.toString()).toList();
        } else {
          // fallback: maybe comma separated
          symptomList = s.replaceAll('[', '').replaceAll(']', '').split(',').map((e) => e.trim().replaceAll('"','')).where((e) => e.isNotEmpty).toList();
        }
      } catch (_) {
        symptomList = s.replaceAll('[', '').replaceAll(']', '').split(',').map((e) => e.trim().replaceAll('"','')).where((e) => e.isNotEmpty).toList();
      }
    } else if (s is List) {
      symptomList = s.map((e) => e.toString()).toList();
    } else {
      symptomList = [];
    }

    return Disease(
      id: id,
      name: (data['name'] ?? '') as String,
      description: (data['description'] ?? '') as String,
      symptoms: symptomList,
      threshold: ((data['threshold'] ?? 0.5) as num).toDouble(),
      solution: (data['solution'] ?? '') as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'symptoms': symptoms,
      'threshold': threshold,
      'solution': solution,
    };
  }
}
