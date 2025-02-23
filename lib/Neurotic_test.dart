import 'package:flutter/material.dart';
import 'db_service.dart';

class NeuroticPersonalityTestScreen extends StatefulWidget {
  final int userId;

  NeuroticPersonalityTestScreen({required this.userId});

  @override
  _NeuroticPersonalityTestScreenState createState() => _NeuroticPersonalityTestScreenState();
}

class _NeuroticPersonalityTestScreenState extends State<NeuroticPersonalityTestScreen> {
  int _totalScore = 0;
  int _currentQuestionIndex = 0;
  List<int?> _selectedAnswers = [];

  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'Do you often feel anxious or stressed?',
      'options': [
        {'text': 'Rarely', 'score': 0},
        {'text': 'Sometimes', 'score': 1},
        {'text': 'Often', 'score': 2},
        {'text': 'Almost always', 'score': 3},
      ]
    },
    {
      'question': 'Do you feel overwhelmed by small tasks?',
      'options': [
        {'text': 'Rarely', 'score': 0},
        {'text': 'Sometimes', 'score': 1},
        {'text': 'Often', 'score': 2},
        {'text': 'Almost always', 'score': 3},
      ]
    },
    {
      'question': 'Do you tend to overthink situations?',
      'options': [
        {'text': 'Rarely', 'score': 0},
        {'text': 'Sometimes', 'score': 1},
        {'text': 'Often', 'score': 2},
        {'text': 'Almost always', 'score': 3},
      ]
    },
    // Add more questions as needed
  ];

  @override
  void initState() {
    super.initState();
    _selectedAnswers = List<int?>.filled(_questions.length, null);
  }

  String _determineRiskLevel() {
    if (_totalScore >= (_questions.length * 3) / 2) {
      return 'High Risk';
    } else if (_totalScore >= (_questions.length * 3) / 4) {
      return 'Moderate Risk';
    } else {
      return 'Low Risk';
    }
  }

  Future<void> _calculateResult() async {
    String riskLevel = _determineRiskLevel();

    await DatabaseService.instance.insertNeuroticTestResult(
      widget.userId,
      _totalScore,
      riskLevel,
    );

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Neurotic Personality Test Result'),
        content: Text('Score: $_totalScore\nRisk Level: $riskLevel'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pushNamed(context, '/home');
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _nextQuestion() {
    if (_selectedAnswers[_currentQuestionIndex] != null) {
      if (_currentQuestionIndex < _questions.length - 1) {
        setState(() {
          _currentQuestionIndex++;
        });
      } else {
        _calculateResult();
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select an answer before proceeding.")),
      );
    }
  }

  Widget _buildQuestion() {
    final question = _questions[_currentQuestionIndex];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question['question'],
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
        ...question['options'].map<Widget>((option) {
          int score = option['score'];
          String text = option['text'];
          return RadioListTile<int>(
            title: Text(text),
            value: score,
            groupValue: _selectedAnswers[_currentQuestionIndex],
            onChanged: (value) {
              setState(() {
                if (_selectedAnswers[_currentQuestionIndex] != null) {
                  _totalScore -= _selectedAnswers[_currentQuestionIndex]!;
                }
                _totalScore += value ?? 0;
                _selectedAnswers[_currentQuestionIndex] = value;
              });
            },
          );
        }).toList(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Neurotic Personality Test")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _buildQuestion(),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.navigate_next),
        onPressed: _nextQuestion,
      ),
    );
  }
}
