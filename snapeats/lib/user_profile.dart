// user_profile.dart
import 'package:flutter/material.dart';

class UserProfile with ChangeNotifier {
  double? height;
  double? weight;
  int? age;
  String? gender;
  String? goals;

  // Update the user's profile data
  void updateProfile(double h, double w, int a, String g, String go) {
    height = h;
    weight = w;
    age = a;
    gender = g;
    goals = go;
    print(go);
    notifyListeners(); // Notify listeners when data changes
  }
}
