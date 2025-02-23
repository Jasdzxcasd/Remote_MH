import 'package:flutter/material.dart';
import 'db_service.dart';

class ViewResultsScreen extends StatefulWidget {
  @override
  _ViewResultsScreenState createState() => _ViewResultsScreenState();
}

class _ViewResultsScreenState extends State<ViewResultsScreen> {
  List<Map<String, dynamic>> _depressionScores = [];
  List<Map<String, dynamic>> _neuroticScores = [];

  @override
  void initState() {
    super.initState();
    _loadUserScores();
  }

  Future<void> _loadUserScores() async {
    // Fetch depression test results
    final depressionScores = await DatabaseService.instance.getUserScores();
    // Fetch neurotic test results
    final neuroticScores = await DatabaseService.instance.getNeuroticTestScores();

    setState(() {
      _depressionScores = depressionScores;
      _neuroticScores = neuroticScores;
    });
  }

  String _formatDate(String dateString) {
    final dateTime = DateTime.parse(dateString);
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  Widget _buildDepressionTestResults() {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Text(
          'Depression Test Results',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 10),
        if (_depressionScores.isEmpty)
          Center(child: const Text('No depression test results found.')),
        ..._depressionScores.map((user) {
          return ListTile(
            title: Text('Name: ${user['name']}'),
            subtitle: Text(
              'Score: ${user['score']}\n'
                  'Severity: ${user['severity']}\n'
                  'Date: ${_formatDate(user['date'])}',
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildNeuroticTestResults() {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Text(
          'Neurotic Personality Test Results',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 10),
        if (_neuroticScores.isEmpty)
          Center(child: const Text('No neurotic test results found.')),
        ..._neuroticScores.map((user) {
          return ListTile(
            title: Text('Name: ${user['name']}'),
            subtitle: Text(
              'Score: ${user['score']}\n'
                  'Risk Level: ${user['risk_level']}\n'
                  'Date: ${_formatDate(user['date'])}',
            ),
          );
        }).toList(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Test Results")),
      body: PageView(
        children: [
          _buildDepressionTestResults(),
          _buildNeuroticTestResults(),
        ],
      ),
    );
  }
}
