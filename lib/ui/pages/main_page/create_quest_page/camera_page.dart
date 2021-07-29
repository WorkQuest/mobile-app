import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'create_quest_page.dart';

// A screen that allows users to take a picture using a given camera.
class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    Key? key,
    required this.cameras,
  }) : super(key: key);

  final List<CameraDescription> cameras;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

late CameraController _controller;

class TakePictureScreenState extends State<TakePictureScreen> {
  int selectedCameraIdx = 0;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(widget.cameras.first, ResolutionPreset.max);
    _initCameraController(widget.cameras.first).then((value) => () {});
  }

  Future _initCameraController(CameraDescription cameraDescription) async {
    await _controller.dispose();

    _controller = CameraController(cameraDescription, ResolutionPreset.high);

    // If the controller is updated then update the UI.
    // 4
    _controller.addListener(() {
      if (mounted) {
        setState(() {});
      }
      if (_controller.value.hasError) {
        print('Camera error ${_controller.value.errorDescription}');
      }
    });
    try {
      await _controller.initialize();
    } on CameraException catch (e) {}

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(title: const Text('Take a picture')),
      body: CameraPreview(_controller),
      floatingActionButton: Container(
        padding: EdgeInsets.symmetric(
          vertical: 10.0,
          horizontal: 10.0,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(50.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FloatingActionButton(
              mini: true,
              onPressed: () {},
              child: Center(child: _cameraTogglesRowWidget()),
            ),
            const SizedBox(
              width: 20.0,
            ),
            FloatingActionButton(
              // Provide an onPressed callback.
              onPressed: () async {
                // Take the Picture in a try / catch block. If anything goes wrong,
                // catch the error.
                try {
                  // Ensure that the camera is initialized.

                  // Attempt to take a picture and get the file `image`
                  // where it was saved.
                  final image = await _controller.takePicture();

                  // If the picture was taken, display it on a new screen.
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => DisplayPictureScreen(
                        // Pass the automatically generated path to
                        // the DisplayPictureScreen widget.
                        imagePath: image.path,
                      ),
                    ),
                  );
                } catch (e) {
                  // If an error occurs, log the error to the console.
                  print(e);
                }
              },
              child: const Icon(Icons.camera_alt),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cameraTogglesRowWidget() {
    CameraDescription selectedCamera = widget.cameras[selectedCameraIdx];
    CameraLensDirection lensDirection = selectedCamera.lensDirection;

    return IconButton(
      onPressed: _onSwitchCamera,
      icon: Icon(_getCameraLensIcon(lensDirection)),
    );
  }

  IconData _getCameraLensIcon(CameraLensDirection direction) {
    switch (direction) {
      case CameraLensDirection.back:
        return Icons.camera_rear;
      case CameraLensDirection.front:
        return Icons.camera_front;
      case CameraLensDirection.external:
        return Icons.camera;
      default:
        return Icons.device_unknown;
    }
  }

  void _onSwitchCamera() {
    selectedCameraIdx = selectedCameraIdx < widget.cameras.length - 1
        ? selectedCameraIdx + 1
        : 0;
    CameraDescription selectedCamera = widget.cameras[selectedCameraIdx];
    _initCameraController(selectedCamera);
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({Key? key, required this.imagePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Image.file(File(imagePath)),
      persistentFooterButtons: [
        TextButton(
          style: TextButton.styleFrom(
            padding: const EdgeInsets.all(16.0),
            primary: Colors.black,
            textStyle: const TextStyle(fontSize: 20),
          ),
          onPressed: () {
            Navigator.pushNamed(context, CreateQuestPage.routeName);
          },
          child: const Text('OK'),
        ),
        TextButton(
          style: TextButton.styleFrom(
            padding: const EdgeInsets.all(16.0),
            primary: Colors.black,
            textStyle: const TextStyle(fontSize: 20),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Retake'),
        ),
      ],
    );
  }
}
