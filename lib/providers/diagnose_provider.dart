import 'package:flutter/material.dart';

class DiagnosisProvider extends ChangeNotifier {
  // Identity data
  int age = 0;
  String gender = "";
  double height = 0.0;
  double weight = 0.0;
  String allergies = "";

  // Selected symptoms
  List<Map<String, dynamic>> symptoms = [];

  // Diagnosed diseases
  List<Map<String, dynamic>> diseases = [];

  // ---- SETTERS ----
  void setIdentity({
    required int userAge,
    required String userGender,
    required double userHeight,
    required double userWeight,
    required String userAllergies,
  }) {
    age = userAge;
    gender = userGender;
    height = userHeight;
    weight = userWeight;
    allergies = userAllergies;
    notifyListeners();
  }

  void setSymptoms(List<Map<String, dynamic>> selectedSymptoms) {
    symptoms = selectedSymptoms;
    notifyListeners();
  }

  void setDiseases(List<Map<String, dynamic>> diagnoseResults) {
    diseases = diagnoseResults;
    notifyListeners();
  }

  Map<String, dynamic> toFirestore() {
    return {
      "age": age,
      "gender": gender,
      "height": height,
      "weight": weight,
      "allergies": allergies,
      "symptoms": symptoms,
      "diseases": diseases,
    };
  }

  // Reset after saving
  void resetAll() {
    age = 0;
    gender = "";
    height = 0;
    weight = 0;
    allergies = "";
    symptoms = [];
    diseases = [];
    notifyListeners();
  }
}