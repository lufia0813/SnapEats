import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'user_profile.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final userProfile = context.watch<UserProfile>();

    //Varaibles 
    //
    //
    //
    // Calculate BMR (Basal Metabolic Rate) using the Mifflin-St Jeor equation.
    double bmr = 0;
    double bmi = 0.0;
    if (userProfile.gender == 'Male') {
      bmr = 10 * (userProfile.weight ?? 70) +
          6.25 * (userProfile.height ?? 175) -
          5 * (userProfile.age ?? 25) +
          5;
    } else if (userProfile.gender == 'Female') {
      bmr = 10 * (userProfile.weight ?? 70) +
          6.25 * (userProfile.height ?? 175) -
          5 * (userProfile.age ?? 25) -
          161;
    }

    //calculate bmi  = weight/m^2
    bmi  = (userProfile.weight ?? 1) / ((userProfile.height ?? 1) /100  * (userProfile.height ?? 1)/100 );
    
    // Adjust calories based on the goal (Gain or Lose)
    double calorieTarget = bmr * 1.2; // Sedentary activity level
    if (userProfile.goals == 'Gain') {
      calorieTarget *= 1.15; // 15% surplus
    } else if (userProfile.goals == 'Lose') {
      calorieTarget *= 0.85; // 15% deficit
    }

    // Calculate macronutrient targets (example distribution)
    double protein = (calorieTarget * 0.3) / 4; // 30% of calories, 4 kcal per gram
    double carbs = (calorieTarget * 0.5) / 4; // 50% of calories, 4 kcal per gram
    double fat = (calorieTarget * 0.2) / 9; // 20% of calories, 9 kcal per gram


    //What you see on the screen 
    //
    //
    //
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
              Text("Enter your profile to get started",
              style: TextStyle(fontSize: 16, color: Colors.grey[700]))
            else 
              Text(
                'Your goal is to ${userProfile.goals }. Here’s your nutrition summary for today:',
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
                    if(bmi != 10000)
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
