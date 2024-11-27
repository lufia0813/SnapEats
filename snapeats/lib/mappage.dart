import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'user_profile.dart';

class MapPage extends StatefulWidget {
  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  String currentMode = "Lose Fat"; // Default mode
  final Map<String, Map<String, double>> modes = {
    "Lose Fat": {"calories": 0.5, "protein": 0.3, "distance": 0.2},
    "Gain Muscle": {"calories": 0.3, "protein": 0.5, "distance": 0.2},
    "Nearby": {"calories": 0.2, "protein": 0.3, "distance": 0.5},
  };

  // Sample restaurant data
  List<Map<String, dynamic>> restaurants = [
    {"name": "Healthy Bites", "calories": 450, "protein": 35, "distance": 1.5},
    {"name": "Muscle Grill", "calories": 700, "protein": 50, "distance": 3.0},
    {"name": "Veggie Delight", "calories": 300, "protein": 10, "distance": 0.8},
    {"name": "Fast Food Express", "calories": 1000, "protein": 25, "distance": 2.5},
  ];

  @override
  Widget build(BuildContext context) {
    final userProfile = context.watch<UserProfile>();

    // Function to calculate restaurant score based on the selected mode
    double calculateScore(Map<String, dynamic> restaurant) {
      Map<String, double> weights = modes[currentMode]!;
      double score = 0;
      score += weights["calories"]! * (1000 - restaurant["calories"]) / 1000; // lower calories better
      score += weights["protein"]! * restaurant["protein"] / 100; // higher protein better
      score += weights["distance"]! * (1 / (1 + restaurant["distance"])); // shorter distance better
      return score;
    }

    // Sort restaurants by score
    restaurants.sort((a, b) => calculateScore(b).compareTo(calculateScore(a)));

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
            if (userProfile.goals != null)
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Your Goal: ${userProfile.goals}",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            const SizedBox(height: 16),
            // Display current mode
            Text(
              "Mode: $currentMode",
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Weights for Decision Making:",
              style: TextStyle(fontSize: 16),
            ),
            ...modes[currentMode]!.entries.map(
              (entry) => Text(
                "${entry.key}: ${(entry.value * 100).toStringAsFixed(1)}%",
                style: const TextStyle(fontSize: 14),
              ),
            ),
            const SizedBox(height: 24),
            // Dropdown for selecting the mode
            DropdownButton<String>(
              value: currentMode,
              items: modes.keys
                  .map((mode) => DropdownMenuItem<String>(
                        value: mode,
                        child: Text(mode),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    currentMode = value;
                  });
                }
              },
            ),
            const SizedBox(height: 24),
            // Display restaurant rankings based on the mode
            Expanded(
              child: ListView.builder(
                itemCount: restaurants.length,
                itemBuilder: (context, index) {
                  var restaurant = restaurants[index];
                  double score = calculateScore(restaurant);
                  return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      title: Text(restaurant["name"]),
                      subtitle: Text(
                          "Calories: ${restaurant["calories"]}, Protein: ${restaurant["protein"]}g, Distance: ${restaurant["distance"]} km\nScore: ${score.toStringAsFixed(2)}"),
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
