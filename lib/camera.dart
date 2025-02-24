import 'package:flutter/material.dart';
import 'components/camera_widget.dart';
import 'components/capture_button.dart';
import 'components/emotion_detector_controller.dart';
import 'components/emotion_text.dart';
import 'depression_test_screen.dart';

class CameraScreen extends StatefulWidget {
  final int userId;

  CameraScreen({required this.userId});

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  final EmotionDetectorController _controller = EmotionDetectorController();

  @override
  void initState() {
    super.initState();
    _controller.loadModel();
    _controller.initializeCamera().then((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Emotion Recognition')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_controller.cameraController != null &&
                _controller.cameraController!.value.isInitialized)
              SizedBox(
                height: 500,
                child: CameraWidget(controller: _controller.cameraController!),
              )
            else
              const SizedBox(height: 200, child: Center(child: CircularProgressIndicator())),

            const SizedBox(height: 12),

            // Row for buttons (Switch Camera & Capture)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await _controller.switchCamera();
                    setState(() {}); // Refresh UI after switching camera
                  },
                  child: const Icon(Icons.switch_camera),
                ),
                const SizedBox(width: 10), // Space between buttons
                CaptureButton(
                  onCapture: () async {
                    await _controller.captureAndAnalyzeImage(context);
                    if (!mounted) return;

                    String detectedEmotion = _controller.output.value;

                    if (detectedEmotion != "No Emotion Detected") {
                      // Show result only if emotion is detected
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Selfie Captured'),
                          content: Text('Emotion Detected: $detectedEmotion'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(ctx);
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DepressionTestScreen(
                                      userId: widget.userId,
                                      emotion: detectedEmotion,
                                    ),
                                  ),
                                );
                              },
                              child: const Text('Proceed to Test'),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(width: 10), // Space between buttons
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DepressionTestScreen(
                          userId: widget.userId,
                          emotion: _controller.output.value,
                        ),
                      ),
                    );
                  },
                  child: const Text('Take Test'),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Emotion Text below buttons
            ValueListenableBuilder<String>(
              valueListenable: _controller.output,
              builder: (context, value, child) {
                return EmotionText(emotion: value);
              },
            ),
          ],
        ),
      ),
    );
  }
}
