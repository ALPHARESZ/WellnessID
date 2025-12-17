import 'dart:convert';

class Disease {
  final String id;
  final String name;
  final String description;
  final List<String> symptoms;
  final double threshold;
  final String solution;
  final List<String> medicines;

  Disease({
    required this.id,
    required this.name,
    required this.description,
    required this.symptoms,
    required this.threshold,
    required this.solution,
    required this.medicines,
  });

  factory Disease.fromFirestore(String id, Map<String, dynamic> data) {
    dynamic s = data['symptoms'] ?? [];
    dynamic m = data['medicines'] ?? [];

    List<String> symptomList = [];
    List<String> medicineList = [];

    if (s is List) {
      symptomList = s.map((e) => e.toString().trim()).toList();
    } else if (s is String) {
      try {
        final parsed = json.decode(s);
        if (parsed is List) {
          symptomList = parsed.map((e) => e.toString().trim()).toList();
        }
      } catch (_) {
        symptomList = s
            .replaceAll('[', '')
            .replaceAll(']', '')
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();
      }
    }

    if (m is List) {
      medicineList =m.map((e) => e.toString().trim()).toList();
    } else if (m is String) {
      try {
        final parsed = json.decode(m);
        if (parsed is List) {
          medicineList = parsed.map((e) => e.toString().trim()).toList();
        }
      } catch (_) {
        medicineList = m
            .replaceAll('[', '')
            .replaceAll(']', '')
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();
      }
    }

    return Disease(
      id: id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      symptoms: symptomList,
      threshold: ((data['threshold'] ?? 0.5) as num).toDouble(),
      solution: data['solution'] ?? '',
      medicines: medicineList,
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
