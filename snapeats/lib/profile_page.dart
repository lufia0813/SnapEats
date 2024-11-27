// profile_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'user_profile.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  String? _gender;
  String? _goals;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profile",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text(
              "Enter your details:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _heightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Height (cm)",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _weightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Weight (kg)",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _ageController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Age",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _gender,
              items: ["Male", "Female"]
                  .map((gender) => DropdownMenuItem<String>(
                        value: gender,
                        child: Text(gender),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _gender = value;
                });
              },
              decoration: const InputDecoration(
                labelText: "Gender",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),
            DropdownButtonFormField<String>(
              value: _goals,
              items: ["Gain Muscle", "Lose Fat"]
                  .map((goals) => DropdownMenuItem<String>(
                        value: goals,
                        child: Text(goals),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _goals = value;
                });
              },
              decoration: const InputDecoration(
                labelText: "Goals",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                double? height = double.tryParse(_heightController.text);
                double? weight = double.tryParse(_weightController.text);
                int? age = int.tryParse(_ageController.text);


                //Check if inputs are correct or empty
                if (height == null || weight == null || age == null || _gender == null || _goals == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please fill in all fields")),
                  );
                  return;
                }

                // Save data to the global UserProfile instance
                context.read<UserProfile>().updateProfile(height, weight, age, _gender!, _goals!,);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Details Saved")),
                );

                // Clear fields after saving
                _heightController.clear();
                _weightController.clear();
                _ageController.clear();
                setState(() {
                  _gender = null;
                  _goals = null;
                });
              },
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}
