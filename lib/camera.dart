import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'depression_test_screen.dart';

class CameraScreen extends StatefulWidget {
  final int userId;

  CameraScreen({required this.userId});

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final frontCamera = cameras.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.front,
    );

    _controller = CameraController(frontCamera, ResolutionPreset.high);
    await _controller!.initialize();

    if (mounted) {
      setState(() {
        _isCameraInitialized = true;
      });
    }
  }

  Future<String?> _takeSelfie() async {
    if (!_controller!.value.isInitialized) {
      return null;
    }

    XFile image = await _controller!.takePicture();
    final directory = await getApplicationDocumentsDirectory();
    final imagePath = '${directory.path}/${DateTime.now()}.jpg';
    await image.saveTo(imagePath);

    return imagePath;
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Emotion Recognition')),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Center(
            child: _isCameraInitialized
                ? SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.6,
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()..scale(-1.0, 1.0),
                child: CameraPreview(_controller!),
              ),
            )
                : const Center(child: CircularProgressIndicator()),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              String? imagePath = await _takeSelfie();
              if (imagePath != null) {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Selfie Captured'),
                    content: const Text('Emotion Captured: no detection.'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(ctx);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DepressionTestScreen(userId: widget.userId),
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
            child: const Text('Capture Selfie'),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => DepressionTestScreen(userId: widget.userId),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            child: const Text('Take Test'),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
