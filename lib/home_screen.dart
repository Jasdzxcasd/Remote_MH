import 'package:flutter/material.dart';
import 'Neurotic_test.dart';
import 'depression_test_screen.dart';
import 'profile_creation_screen.dart';
import 'history_screen.dart';
import 'main.dart'; // Import main to access startSelfieCapture

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '',
          style: TextStyle(
            color: Color(0xFF6C0F7E), // Custom hex color for consistency
            fontSize: 22,
          ),
        ),
        centerTitle: true,
      ),
      body: Center( //to be fixed add child center and set body to container
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logi.png', // Path to your PNG file
                width: 200, // You can specify width and height
                height: 200,
                fit: BoxFit.cover, // Adjust the image fit (optional)
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  // Use startSelfieCapture to capture a selfie before the test
                  startSelfieCapture(context, 1); // Replace '1' with the actual userId
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue, // Text color
                  shadowColor: Colors.grey, // Shadow color
                  elevation: 5, // Elevation for a shadow effect
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // Rounded corners
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 72, vertical: 15),
                  textStyle: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                child: const Text('Take Test'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NeuroticPersonalityTestScreen(userId: 1),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue, // Text color
                  shadowColor: Colors.grey, // Shadow color
                  elevation: 5, // Elevation for a shadow effect
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // Rounded corners
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 72, vertical: 15),
                  textStyle: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                child: const Text('Risk Test'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ViewResultsScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue, // Text color
                  shadowColor: Colors.grey, // Shadow color
                  elevation: 5, // Elevation for a shadow effect
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // Rounded corners
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                  textStyle: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                child: const Text('Test Results'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileCreationScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue, // Text color
                  shadowColor: Colors.grey, // Shadow color
                  elevation: 5, // Elevation for a shadow effect
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // Rounded corners
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 72, vertical: 15),
                  textStyle: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                child: const Text('Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
