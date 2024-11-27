import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'user_profile.dart';
import 'dart:math';

class MapPage extends StatefulWidget {
  @override
  State<MapPage> createState() => _MapPageState();
}
//hallo
class _MapPageState extends State<MapPage> {
  // Sample restaurant data
  List<Map<String, dynamic>> restaurants = [
    {"name": "Healthy Bites", "calories": 450, "protein": 35},
    {"name": "Muscle Grill", "calories": 700, "protein": 50},
    {"name": "Veggie Delight", "calories": 300, "protein": 10},
    {"name": "Fast Food Express", "calories": 1000, "protein": 25},
    {"name": "Rowans Canteen", "calories": 2000, "protein": 135},
     {"name": "Timmys Canteen (not as good)", "calories": 1800, "protein": 200},
  ];

  @override
  Widget build(BuildContext context) {
    final userProfile = context.watch<UserProfile>(); // Watch user profile for changes

    // Determine currentMode and weights based on the user's goal
    String currentMode = userProfile.goals ?? "Lose Fat";  // Default to "Lose Fat" if no goal is set

    // Weights based on goals
    Map<String, Map<String, double>> modeWeights = {
      "Lose Fat": {"calories": 0.7, "protein": 0.3},  // prioritize calories for fat loss
      "Gain Muscle": {"calories": 0.4, "protein": 0.6}, // prioritize protein for muscle gain
      "Maintain": {"calories": 0.5, "protein": 0.5}, // equal focus on both for maintenance
    };

    // Fetch user's macronutrient goals from the user profile
    double proteinGoal = userProfile.proteinTarget ?? 50;  // Default protein goal
    double calorieGoal = userProfile.calorieTarget ?? 500;  // Default calorie goal
    double calorieWeight = modeWeights[currentMode]!["calories"] ?? 0.5;
    double proteinWeight = modeWeights[currentMode]!["protein"] ?? 0.5;

    // Function to calculate the squared difference and score for a restaurant
    double calculateScore(Map<String, dynamic> restaurant, double calorieGoal, double proteinGoal, double calorieWeight, double proteinWeight) {
      double score = 0;

      // Calorie score: lower calories are better
      score += calorieWeight * pow((restaurant["calories"] - calorieGoal), 2);

      // Protein score: higher protein is better
      score += proteinWeight * pow((restaurant["protein"] - proteinGoal), 2);
      return score;
    }

    // Sort restaurants by score
    List<Map<String, dynamic>> sortedRestaurants = List.from(restaurants);
    sortedRestaurants.sort((a, b) {
      double scoreA = calculateScore(a, calorieGoal, proteinGoal, calorieWeight, proteinWeight);
      double scoreB = calculateScore(b, calorieGoal, proteinGoal, calorieWeight, proteinWeight);
      return scoreA.compareTo(scoreB); // Sort in ascending order of score
    });

    // Calculate the maximum score for normalization
    double maxScore = sortedRestaurants.isNotEmpty
        ? calculateScore(sortedRestaurants[sortedRestaurants.length - 1], calorieGoal, proteinGoal, calorieWeight, proteinWeight)
        : 1;

    // Normalize the score to percentage (percent fit)
    double calculatePercentFit(Map<String, dynamic> restaurant) {
      double score = calculateScore(restaurant, calorieGoal, proteinGoal, calorieWeight, proteinWeight);
      return 100-((score / maxScore) * 100); // Normalize to percentage
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Find Restaurants",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 124, 189, 220),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display user's goals at the top of the screen
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Your Goals:",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text("Calorie Goal: $calorieGoal kcal", style: TextStyle(fontSize: 16)),
                    Text("Protein Goal: $proteinGoal g", style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Display weight settings for decision making
            const Text(
              "Weights for Decision Making:",
              style: TextStyle(fontSize: 16),
            ),
            Text("Calorie Weight: ${(calorieWeight * 100).toStringAsFixed(1)}%", style: TextStyle(fontSize: 14)),
            Text("Protein Weight: ${(proteinWeight * 100).toStringAsFixed(1)}%", style: TextStyle(fontSize: 14)),
            const SizedBox(height: 24),
            // Display restaurant rankings based on the user profile and goals
            Expanded(
              child: ListView.builder(
                itemCount: sortedRestaurants.length,
                itemBuilder: (context, index) {
                  var restaurant = sortedRestaurants[index];
                  double percentFit = calculatePercentFit(restaurant);

                  return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      title: Text(restaurant["name"]),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              "Calories: ${restaurant["calories"]}, Protein: ${restaurant["protein"]}g"),
                          Text("Percent Fit: ${percentFit.toStringAsFixed(2)}%"),
                          SizedBox(height: 8),
                          // Circular Progress Indicator
                          CircularProgressIndicator(
                            value: percentFit / 100,
                            strokeWidth: 8,
                            backgroundColor: Colors.grey[300],
                            valueColor: AlwaysStoppedAnimation<Color>(
                              percentFit > 50 ? Colors.green : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
