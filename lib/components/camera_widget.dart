import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:math' as math;

class CameraWidget extends StatelessWidget {
  final CameraController? controller;

  const CameraWidget({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller!.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    bool isFrontCamera = controller!.description.lensDirection == CameraLensDirection.front;
    double aspectRatio = controller!.value.aspectRatio;

    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16), // Rounded corners for a clean UI
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.6, // Adjust height
          child: Transform(
            alignment: Alignment.center,
            transform: isFrontCamera
                ? (Matrix4.identity()
              ..rotateY(math.pi) // ✅ Mirror the front camera preview
              ..rotateZ(math.pi / -2)) // ✅ Rotate to portrait
                : (Matrix4.identity()..rotateZ(math.pi / 2)), // ✅ Rotate back camera to portrait
            child: AspectRatio(
              aspectRatio: 1 / aspectRatio, // Keep correct proportions
              child: CameraPreview(controller!),
            ),
          ),
        ),
      ),
    );
  }
}
