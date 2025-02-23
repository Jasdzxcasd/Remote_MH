import 'package:flutter/material.dart';
import 'db_service.dart';

class ProfileCreationScreen extends StatefulWidget {
  @override
  _ProfileCreationScreenState createState() => _ProfileCreationScreenState();
}

class _ProfileCreationScreenState extends State<ProfileCreationScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  int? _userId;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  // Load the user profile if it exists
  Future<void> _loadUserProfile() async {
    // Assuming there’s a method to fetch user details by a specific ID
    final profile = await DatabaseService.instance.getUserById(1); // Default to user ID 1 or use a specific ID logic
    if (profile != null) {
      setState(() {
        _nameController.text = profile['name'];
        _ageController.text = profile['age'].toString();
        _userId = profile['id'];
      });
    }
  }

  Future<void> _saveProfile() async {
    final name = _nameController.text.trim();
    final age = int.tryParse(_ageController.text) ?? 0;

    // Ensure valid name and age inputs
    if (name.isNotEmpty && age > 0) {
      if (_userId != null) {
        // Update existing profile
        await DatabaseService.instance.updateUser(_userId!, name, age);
      } else {
        // Insert new profile
        final userId = await DatabaseService.instance.insertUser(name, age);
        if (userId > 0) {
          _userId = userId;
        }
      }

      // Navigate to the test screen, passing user ID as an argument
      Navigator.pushReplacementNamed(
        context,
        '/test',
        arguments: _userId,
      );
    } else {
      // Show error if input is invalid
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid name and age.')),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _ageController,
              decoration: const InputDecoration(labelText: 'Age'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _saveProfile,
              child: const Text('Save Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
