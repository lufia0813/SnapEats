import 'package:flutter/material.dart';

class UserProfile extends ChangeNotifier {
  double? height;
  double? weight;
  int? age;
  String? gender;
  String? goals;

  // Initialize as nullable with a fallback
  double? calorieTarget = 0;
  double? proteinTarget = 0;
  double? carbsTarget = 0;
  double? fatTarget = 0;

  void updateProfile(double height, double weight, int age, String gender, String goals) {
    this.height = height;
    this.weight = weight;
    this.age = age;
    this.gender = gender;
    this.goals = goals;

    _calculateTargets();
    notifyListeners(); // Notify listeners about the changes
  }

  void _calculateTargets() {
    // Ensure that the values are not null before doing calculations
    double bmr = 0;
    if (gender == 'Male') {
      bmr = 10 * weight! + 6.25 * height! - 5 * age! + 5;
    } else if (gender == 'Female') {
      bmr = 10 * weight! + 6.25 * height! - 5 * age! - 161;
    }

    // Adjust calories based on the goal (Gain or Lose)
    calorieTarget = bmr * 1.2; // Sedentary activity level
    if (goals == 'Gain Muscle') {
      calorieTarget = calorieTarget!* 1.15; // 15% surplus
    } else if (goals == 'Lose Fat') {
      calorieTarget = calorieTarget!* 0.85; // 15% deficit
    }

    // Calculate macronutrient targets
    proteinTarget = (calorieTarget! * 0.3) / 4; // 30% of calories, 4 kcal per gram
    carbsTarget = (calorieTarget! * 0.5) / 4; // 50% of calories, 4 kcal per gram
    fatTarget = (calorieTarget! * 0.2) / 9; // 20% of calories, 9 kcal per gram
  }

  // Getter methods for the macronutrient targets
  double get getProteinTarget => proteinTarget ?? 0;
  double get getCarbsTarget => carbsTarget ?? 0;
  double get getFatTarget => fatTarget ?? 0;
  double get getCalorieTarget => calorieTarget ?? 0;
}
