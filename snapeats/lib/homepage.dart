// ignore_for_file: use_key_in_widget_constructors
//Set up git for this project
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'user_profile.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProfile = context.watch<UserProfile>();

    // Calculate BMR (Basal Metabolic Rate) using the Mifflin-St Jeor equation.
    double bmr = 0;
    if (userProfile.gender == 'Male') {
      bmr = 10 * (userProfile.weight ?? 70) + 6.25 * (userProfile.height ?? 175) - 5 * (userProfile.age ?? 25) + 5;
    } else if (userProfile.gender == 'Female') {
      bmr = 10 * (userProfile.weight ?? 70) + 6.25 * (userProfile.height ?? 175) - 5 * (userProfile.age ?? 25) - 161;
    }

    // Example static values for protein, carbs, and fat.
    double protein = 50.0; // Can be updated dynamically if needed.
    double carbs = 150.0; // Can be updated dynamically if needed.
    double fat = 30.0; // Can be updated dynamically if needed.
    double caloriesConsumed = bmr * 1.2; // Adjusted for sedentary activity level.

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Nutrition App',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.lightBlue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Hello, User!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Here’s your nutrition summary for today:',
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            const SizedBox(height: 16),
            // Nutrition Progress Card
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Calories Consumed: ${caloriesConsumed.toStringAsFixed(0)} kcal',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Protein: ${protein}g',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Carbs: ${carbs}g',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Fat: ${fat}g',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Recommendations
            const Text(
              'Recommendations for You:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView(
                children: [
                  buildFoodTile('Grilled Chicken Salad', 'High protein, low carbs'),
                  buildFoodTile('Avocado Toast', 'Balanced and nutritious'),
                  buildFoodTile('Smoothie Bowl', 'Rich in vitamins'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Food recommendation tile
  Widget buildFoodTile(String title, String subtitle) {
    return ListTile(
      leading: const Icon(Icons.restaurant, color: Colors.green),
      title: Text(title),
      subtitle: Text(subtitle),
    );
  }
}
