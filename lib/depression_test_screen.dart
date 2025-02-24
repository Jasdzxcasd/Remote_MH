import 'package:flutter/material.dart';
import 'db_service.dart';

class DepressionTestScreen extends StatefulWidget {
  final int userId;
  final String emotion;
  DepressionTestScreen({required this.userId,required this.emotion});

  @override
  _DepressionTestScreenState createState() => _DepressionTestScreenState();
}

class _DepressionTestScreenState extends State<DepressionTestScreen> {
  int _totalScore = 0;
  int _currentQuestionIndex = 0;
  List<int> _selectedAnswers = [];

  // Questions and scoring values
  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'Do you feel sad?\n'
          'Note: today and for the past 2 weeks',
      'options': [
        {'text': 'I do not feel sad.', 'score': 0},
        {'text': 'I feel sad much of the time.', 'score': 1},
        {'text': 'I am sad all the time.', 'score': 2},
        {'text': 'I am so sad or unhappy that I can\'t stand it.', 'score': 3},
      ]
    },
    {
      'question': 'Are you discouraged about your future?\n'
          'Note: today and for the past 2 weeks',
      'options': [
        {'text': 'I am not discouraged about my future.', 'score': 0},
        {'text': 'I feel more discouraged about my future than I used to.', 'score': 1},
        {'text': 'I do not expect things to work out for me.', 'score': 2},
        {'text': 'I feel my future is hopeless and will only get worse.', 'score': 3},
      ]
    },
    {
      'question': 'Do you feel like a failure?\n'
          'Note: today and for the past 2 weeks',
      'options': [
        {'text': 'I do not feel like a failure.', 'score': 0},
        {'text': 'I have failed more than I should have.', 'score': 1},
        {'text': 'As I look back, I see a lot of failures.', 'score': 2},
        {'text': 'I feel I am a total failure as a person.', 'score': 3},
      ]
    },
    {
      'question': 'Do you still get pleasure from things you enjoy doing?\n'
          'Note: today and for the past 2 weeks',
      'options': [
        {'text': 'I get as much pleasure as I ever did from the things I enjoy.', 'score': 0},
        {'text': 'I don\'t enjoy things as much as I used to.', 'score': 1},
        {'text': 'I get very little pleasure from the things I used to enjoy.', 'score': 2},
        {'text': 'I can\'t get any pleasure from the things I used to enjoy.', 'score': 3},
      ]
    },
    {
      'question': 'Do you have guilty feelings?\n'
          'Note: today and for the past 2 weeks',
      'options': [
        {'text': 'I don\'t feel particularly guilty.', 'score': 0},
        {'text': 'I feel guilty over many things I have done or should have done.', 'score': 1},
        {'text': 'I feel quite guilty most of the time.', 'score': 2},
        {'text': 'I feel guilty all of the time.', 'score': 3},
      ]
    },
    {
      'question': 'Do you feel you are being punished?\n'
          'Note: today and for the past 2 weeks',
      'options': [
        {'text': 'I don\'t feel I am being punished.', 'score': 0},
        {'text': 'I feel I may be punished.', 'score': 1},
        {'text': 'I expect to be punished.', 'score': 2},
        {'text': 'I feel I am being punished.', 'score': 3},
      ]
    },
    {
      'question': 'Do you dislike yourself?\n'
          'Note: today and for the past 2 weeks',
      'options': [
        {'text': 'I feel the same about myself as ever.', 'score': 0},
        {'text': 'I have lost confidence in myself.', 'score': 1},
        {'text': 'I am disappointed in myself.', 'score': 2},
        {'text': 'I dislike myself.', 'score': 3},
      ]
    },
    {
      'question': 'Do you criticize yourself?\n'
          'Note: today and for the past 2 weeks',
      'options': [
        {'text': 'I don\'t criticize or blame myself more than usual.', 'score': 0},
        {'text': 'I am more critical of myself than I used to be.', 'score': 1},
        {'text': 'I criticize myself for all of my faults.', 'score': 2},
        {'text': 'I blame myself for everything bad that happens.', 'score': 3},
      ]
    },
    {
      'question': 'Do you have suicidal thoughts?\n'
          'Note: today and for the past 2 weeks',
      'options': [
        {'text': 'I don\'t have any thoughts of killing myself.', 'score': 0},
        {'text': 'I have thoughts of killing myself, but I would not carry them out.', 'score': 1},
        {'text': 'I would like to kill myself.', 'score': 2},
        {'text': 'I would kill myself if I had the chance.', 'score': 3},
      ]
    },
    {
      'question': 'Do you feel like crying?\n'
          'Note: today and for the past 2 weeks',
      'options': [
        {'text': 'I don\'t cry anymore than I used to.', 'score': 0},
        {'text': 'I cry more than I used to.', 'score': 1},
        {'text': 'I cry over every little thing.', 'score': 2},
        {'text': 'I feel like crying, but I can\'t.', 'score': 3},
      ]
    },
    {
      'question': 'Loss of Interest?\n'
          'Note: today and for the past 2 weeks',
      'options': [
        {'text': 'I have not lost interest in other people or activities.', 'score': 0},
        {'text': 'I am less interested in other people or thing than before.', 'score': 1},
        {'text': 'I have lost most of my interest in other people or things.', 'score': 2},
        {'text': 'It\'s hard to get interested in anything.', 'score': 3},
      ]
    },
    {
      'question': 'Indecisiveness\n'
          'Note: today and for the past 2 weeks',
      'options': [
        {'text': 'I make decisions about as well as ever.', 'score': 0},
        {'text': 'I find it more difficult to make decisions than usual.', 'score': 1},
        {'text': 'I have much greater difficulty in making decisions than I used to.', 'score': 2},
        {'text': 'I have trouble making any decisions.', 'score': 3},
      ]
    },
    {
      'question': 'Worthlessness\n'
          'Note: today and for the past 2 weeks',
      'options': [
        {'text': 'I do not feel I am worthless.', 'score': 0},
        {'text': 'I don\'t consider myself as worthwhile and useful as I used to.', 'score': 1},
        {'text': 'I feel more worthless as compared to others.', 'score': 2},
        {'text': 'I feel utterly worthless.', 'score': 3},
      ]
    },
    {
      'question': 'Loss of Energy\n'
          'Note: today and for the past 2 weeks',
      'options': [
        {'text': 'I have as much energy as ever.', 'score': 0},
        {'text': 'I have less energy than I used to have.', 'score': 1},
        {'text': 'I don\'t have enough energy to do very much.', 'score': 2},
        {'text': 'I don\'t have enough energy to do anything.', 'score': 3},
      ]
    },
    {
      'question': 'Changes in Sleeping Pattern\n'
          'Note: today and for the past 2 weeks',
      'options': [
        {'text': 'I have not experienced any change in my sleeping.', 'score': 0},
        {'text': 'I sleep somewhat more or less than usual.', 'score': 1},
        {'text': 'I sleep a lot more or less than usual.', 'score': 2},
        {'text': 'I sleep most of the day, may wake up 1-2 hours early and can\'t get back to sleep.', 'score': 3},
      ]
    },
    {
      'question': 'Irritability\n'
          'Note: today and for the past 2 weeks',
      'options': [
        {'text': 'I am not more irritable than usual.', 'score': 0},
        {'text': 'I am more irritable than usual.', 'score': 1},
        {'text': 'I am much more irritable than usual.', 'score': 2},
        {'text': 'I am irritable all the time.', 'score': 3},
      ]
    },
    {
      'question': 'Changes in Appetite\n'
          'Note: today and for the past 2 weeks',
      'options': [
        {'text': 'I have not experienced any change in my appetite.', 'score': 0},
        {'text': 'My appetite is somewhat more or less than usual.', 'score': 1},
        {'text': 'My appetite is much greater or less than before', 'score': 2},
        {'text': 'I have no appetite at all / I crave food all the time.', 'score': 3},
      ]
    },
    {
      'question': 'Concentration Difficulty\n'
          'Note: today and for the past 2 weeks',
      'options': [
        {'text': 'I can concentrate as well as ever.', 'score': 0},
        {'text': 'I can\'t concentrate as well as usual.', 'score': 1},
        {'text': 'It\'s hard to keep my mind on anything for very long.', 'score': 2},
        {'text': 'I find I can\'t concentrate on anything.', 'score': 3},
      ]
    },
    {
      'question': 'Tiredness or Fatigue\n'
          'Note: today and for the past 2 weeks',
      'options': [
        {'text': 'I am no more tired or fatigued than usual.', 'score': 0},
        {'text': 'I get more tired or fatigued more easily than usual.', 'score': 1},
        {'text': 'I am too tired or fatigued to do a lot of the things I used to do', 'score': 2},
        {'text': 'I am too tired or fatigued to do most of the things I used to do.', 'score': 3},
      ]
    },
    {
      'question': 'Agitation\n'
          'Note: today and for the past 2 weeks',
      'options': [
        {'text': 'I am no more restless or wound up than usual.', 'score': 0},
        {'text': 'I feel more restless or wound up than usual.', 'score': 1},
        {'text': 'I am so restless or agitated, it\'s hard to stay still.', 'score': 2},
        {'text': 'I am so restless or agitated that I have to keep moving or doing something.', 'score': 3},
      ]
    },
    // Add remaining questions in the same format
  ];


  @override
  void initState() {
    super.initState();
    // Initialize _selectedAnswers with -1 values for each question
    _selectedAnswers = List<int>.filled(_questions.length, -1);
  }

  void _calculateSeverity() {
    final maxScore = _questions.length * 3;
    String severity;

    if (_totalScore <= maxScore * 0.25) {
      severity = 'Mild or No Depression';
    } else if (_totalScore <= maxScore * 0.5) {
      severity = 'Moderate Depression';
    } else if (_totalScore <= maxScore * 0.75) {
      severity = 'Moderately Severe Depression';
    } else {
      severity = 'Severe Depression';
    }

    _saveTestResult(severity);
  }

  Future<void> _saveTestResult(String severity) async {
    await DatabaseService.instance.insertTestResult(
      widget.userId,
      _totalScore,
      severity,
      widget.emotion,
    );

    showDialog(
      context: context,
      barrierDismissible: false, // Prevents closing by tapping outside
      builder: (ctx) => AlertDialog(
        title: Text('Test Result'),
        content: Text('Score: $_totalScore\nSeverity: $severity\nEmotion: ${widget.emotion}'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx); // Close the dialog
              Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false); // Navigate to home and remove previous routes
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }


  void _nextQuestion() {
    if (_selectedAnswers[_currentQuestionIndex] == -1) {
      // Show an alert if no answer is selected
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text("No Answer Selected"),
          content: Text("Please select an answer to proceed."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text("OK"),
            ),
          ],
        ),
      );
    } else {
      setState(() {
        _currentQuestionIndex++;
      });
    }
  }

  void _prevQuestion() {
    setState(() {
      if (_currentQuestionIndex > 0) _currentQuestionIndex--;
    });
  }

  Widget _buildQuestion() {
    final question = _questions[_currentQuestionIndex];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question['question'],
          style: TextStyle(fontSize: 18),
        ),
        SizedBox(height: 16),
        ...question['options'].map<Widget>((option) {
          int score = option['score'];
          String text = option['text'];
          return RadioListTile<int>(
            title: Text(text),
            value: score,
            groupValue: _selectedAnswers[_currentQuestionIndex],
            onChanged: (value) {
              setState(() {
                if (_selectedAnswers[_currentQuestionIndex] != -1) {
                  _totalScore -= _selectedAnswers[_currentQuestionIndex];
                }
                _totalScore += value ?? 0;
                _selectedAnswers[_currentQuestionIndex] = value!;
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
      appBar: AppBar(title: Text("Depression Test")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _buildQuestion(),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (_currentQuestionIndex > 0)
            FloatingActionButton(
              onPressed: _prevQuestion,
              child: Icon(Icons.arrow_back),
            ),
          if (_currentQuestionIndex < _questions.length - 1)
            FloatingActionButton(
              onPressed: _nextQuestion,
              child: Icon(Icons.arrow_forward),
            ),
          if (_currentQuestionIndex == _questions.length - 1)
            FloatingActionButton(
              onPressed: _calculateSeverity,
              child: Icon(Icons.check),
            ),
        ],
      ),
    );
  }
}
