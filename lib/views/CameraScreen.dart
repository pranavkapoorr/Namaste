import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:async';

class CameraScreen extends StatefulWidget {
   List<CameraDescription> cameras;

  Future<Null> main() async {
    this.cameras = await availableCameras();
  }

  CameraScreen() {
    main();
  }

  @override
  _CameraScreenState createState() => new _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
    new CameraController(widget.cameras[0], ResolutionPreset.medium);
    _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return new Container();
    }
    return new AspectRatio(
      aspectRatio: _controller.value.aspectRatio,
      child: new CameraPreview(_controller),
    );
  }
}