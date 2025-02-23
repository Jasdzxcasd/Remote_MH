import 'package:flutter/material.dart';
import 'camera.dart';
import 'profile_creation_screen.dart';
import 'depression_test_screen.dart';
import 'home_screen.dart';
import 'db_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Depression Assessment App',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/home',
      routes: {
        '/home': (context) => const HomeScreen(),
        '/profile': (context) => ProfileCreationScreen(),
        '/test': (context) => DepressionTestScreen(
            userId: ModalRoute.of(context)!.settings.arguments as int),
        '/results': (context) => ViewResultsScreen1(),
      },
    );
  }
}

class ViewResultsScreen1 extends StatefulWidget {
  @override
  _ViewResultsScreenState createState() => _ViewResultsScreenState();
}

class _ViewResultsScreenState extends State<ViewResultsScreen1> {
  List<Map<String, dynamic>> _userScores = [];

  @override
  void initState() {
    super.initState();
    _loadUserScores();
  }

  Future<void> _loadUserScores() async {
    final userScores = await DatabaseService.instance.getUserScores();
    setState(() {
      _userScores = userScores;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Test Results")),
      body: _userScores.isEmpty
          ? const Center(child: Text('No results found.'))
          : ListView.builder(
        itemCount: _userScores.length,
        itemBuilder: (context, index) {
          final user = _userScores[index];
          return ListTile(
            title: Text('Name: ${user['name']}'),
            subtitle: Text(
              'Score: ${user['score']}\n'
                  'Severity: ${user['severity']}\n'
                  'Date: ${user['date']}',
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.home),
        onPressed: () {
          Navigator.pushNamed(context, '/home');
        },
      ),
    );
  }
}

// Selfie Capture and Navigation to Test Screen
void startSelfieCapture(BuildContext context, int userId) async {
  final imagePath = await Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => CameraScreen(userId: userId)),
  );

  // Proceed to the test screen if the selfie was captured or skipped
  if (imagePath != null || imagePath == null) {
    Navigator.pushNamed(context, '/test', arguments: userId);
  }
}

