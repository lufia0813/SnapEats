import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'user_profile.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final userProfile = context.watch<UserProfile>();

    // Get the goals and nutrition data from UserProfile
    double calorieTarget = userProfile.getCalorieTarget;
    double protein = userProfile.getProteinTarget;
    double carbs = userProfile.getCarbsTarget;
    double fat = userProfile.getFatTarget;

    // Get BMI (if available in UserProfile)
    double bmi = 0.0;
    if (userProfile.height != null && userProfile.weight != null) {
      bmi = userProfile.weight! / ((userProfile.height! / 100) * (userProfile.height! / 100)); // BMI = weight / height^2 (in meters)
    }

    // What you see on the screen
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SnapEats',
          style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 124, 189, 220),
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
            if (userProfile.goals == null)
              Text(
                "Enter your profile to get started",
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              )
            else 
              Text(
                'Your goal is to ${userProfile.goals}. Here’s your nutrition summary for today:',
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
                      'Calories Target: ${calorieTarget.toStringAsFixed(0)} kcal',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Protein: ${protein.toStringAsFixed(1)}g',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Carbs: ${carbs.toStringAsFixed(1)}g',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Fat: ${fat.toStringAsFixed(1)}g',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    if (bmi != 10000) // Only show BMI if it's valid
                      Text(
                        'BMI: ${bmi.toStringAsFixed(0)}',
                        style: const TextStyle(fontSize: 16),
                      )
                    else
                      const Text(
                        'BMI: 0 ',
                        style: TextStyle(fontSize: 16),
                      ),
                    const SizedBox(height: 8),
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
  // Need to change this part later for location and restaurant recommendation
  Widget buildFoodTile(String title, String subtitle) {
    return ListTile(
      leading: const Icon(Icons.restaurant, color: Colors.green),
      title: Text(title),
      subtitle: Text(subtitle),
    );
  }
}
