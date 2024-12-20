import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'user_profile.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  String? _gender;
  String? _goals;

  @override
  void initState() {
    super.initState();
    _loadUserProfile(); // Populate fields with saved data
  }

  void _loadUserProfile() {
    final userProfile = context.read<UserProfile>();

    _heightController.text = userProfile.height?.toString() ?? '';
    _weightController.text = userProfile.weight?.toString() ?? '';
    _ageController.text = userProfile.age?.toString() ?? '';
    _gender = userProfile.gender;
    _goals = userProfile.goals;
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = context.read<UserProfile>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 124, 189, 220),
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
                  .map((gender) => DropdownMenuItem<String>(value: gender, child: Text(gender)))
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
                  .map((goals) => DropdownMenuItem<String>(value: goals, child: Text(goals)))
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

                // Check if inputs are correct or empty
                if (height == null || weight == null || age == null || _gender == null || _goals == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please fill in all fields")),
                  );
                  return;
                }

                // Save data to the global UserProfile instance
                userProfile.updateProfile(height, weight, age, _gender!, _goals!);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Details Saved")),
                );
              },
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}
