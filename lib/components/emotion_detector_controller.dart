  import 'dart:typed_data';
  import 'package:camera/camera.dart';
  import 'package:flutter/material.dart';
  import 'package:tflite_flutter/tflite_flutter.dart';
  import 'package:image/image.dart' as img;
  import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
  import 'dart:io';

  class EmotionDetectorController {
    CameraController? cameraController;
    ValueNotifier<String> output = ValueNotifier<String>("No Emotion Detected");
    Interpreter? _interpreter;
    List<String> _labels = ['Happiness', 'Sadness', 'Anger', 'Neutral', 'Surprise', 'Disgust', 'Fear'];

    List<CameraDescription> _cameras = [];
    int _selectedCameraIndex = 0;

    final FaceDetector faceDetector = FaceDetector(
      options: FaceDetectorOptions(enableContours: true, enableLandmarks: true),
    );

    Future<void> initializeCamera() async {
      _cameras = await availableCameras();

      // Default to front camera if available
      _selectedCameraIndex = _cameras.indexWhere((camera) => camera.lensDirection == CameraLensDirection.front);
      if (_selectedCameraIndex == -1) _selectedCameraIndex = 0;

      await _startCamera(_selectedCameraIndex);
    }

    Future<void> _startCamera(int cameraIndex) async {
      cameraController = CameraController(_cameras[cameraIndex], ResolutionPreset.medium);
      await cameraController!.initialize();
      await cameraController!.setFlashMode(FlashMode.off);
    }

    Future<void> switchCamera() async {
      if (_cameras.length < 2) return;

      _selectedCameraIndex = _selectedCameraIndex == 0 ? 1 : 0;
      await cameraController?.dispose();
      await _startCamera(_selectedCameraIndex);
    }

    Future<void> loadModel() async {
      try {
        _interpreter = await Interpreter.fromAsset('assets/model.tflite');
        print('✅ Model loaded successfully.');
      } catch (e) {
        print('Error loading model: $e');
      }
    }

    Future<void> captureAndAnalyzeImage(BuildContext context) async {
      if (cameraController == null || !cameraController!.value.isInitialized) return;

      XFile capturedImage = await cameraController!.takePicture();
      File imageFile = File(capturedImage.path);

      // Decode the image
      img.Image? image = img.decodeImage(imageFile.readAsBytesSync());
      if (image == null) return;

      // Correct the image rotation
      img.Image rotatedImage = _fixImageRotation(image);

      // Save the rotated image for face detection
      File rotatedFile = File(imageFile.path)..writeAsBytesSync(img.encodeJpg(rotatedImage));

      bool hasFace = await _detectFace(rotatedFile);
      if (!hasFace) {
        _showNoFaceDialog(context);
        return;
      }

      // Resize the corrected image for model input
      img.Image resizedImage = img.copyResize(rotatedImage, width: 224, height: 224);
      Float32List input = _processImage(resizedImage);

      // Run emotion detection model
      List<List<double>> outputData = List.generate(1, (_) => List.filled(_labels.length, 0.0));
      _interpreter!.run(input.buffer.asUint8List(), outputData);

      if (outputData.isNotEmpty && outputData[0].isNotEmpty) {
        int maxIndex = outputData[0].indexWhere((probability) => probability == outputData[0].reduce((a, b) => a > b ? a : b));
        output.value = _labels[maxIndex];
      }
    }

    /// Fixes image rotation and mirrors it if it's from the front camera.
    img.Image _fixImageRotation(img.Image image) {
      img.Image rotatedImage;

      if (_selectedCameraIndex == 0) { // Front camera
        rotatedImage = img.flipHorizontal(image); // Mirror flip
      } else { // Back camera
        rotatedImage = image;
      }

      return rotatedImage;
    }

    /// Checks if a face is detected in the image
    Future<bool> _detectFace(File imageFile) async {
      final inputImage = InputImage.fromFile(imageFile);
      final List<Face> faces = await faceDetector.processImage(inputImage);
      return faces.isNotEmpty;
    }

    /// Shows a dialog if no face is detected
    void _showNoFaceDialog(BuildContext context) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('No Face Detected'),
          content: const Text('Please make sure your face is visible in the camera.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }

    Float32List _processImage(img.Image image) {
      List<double> imageAsFloatList = image.getBytes().map((pixel) => pixel.toDouble() / 255.0).toList();
      return Float32List.fromList(imageAsFloatList);
    }

    void dispose() {
      cameraController?.dispose();
      _interpreter?.close();
      faceDetector.close();
    }
  }
