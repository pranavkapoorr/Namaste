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
    setCamController(0);

  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
  void setCamController(int num){
    if(widget.cameras!=null && !widget.cameras.isEmpty) {
      print("setting cam to $num");
      _controller =
      new CameraController(widget.cameras[num], ResolutionPreset.high);
      _controller.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_controller==null || !_controller.value.isInitialized) {
      return new Scaffold(body: new Center(child: new Column(children: <Widget>[new CircularProgressIndicator()],),) );
    }
    return new Stack(
        fit: StackFit.expand,
        children:[
          new AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: new CameraPreview(_controller),
          ),
          new Column(mainAxisAlignment: MainAxisAlignment.start,children: <Widget>[
            new Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                 new SizedBox(
                    width: 90.0,
                    child: new IconButton(icon:new Icon(Icons.camera_alt,color: Colors.white,), onPressed: (){
                      print("controllername:");
                      print(_controller.description.name);
                      if(_controller.description.name.endsWith("1")){
                        setState(() {
                        setCamController(0);
                        });
                      }else if(_controller.description.name.endsWith("0")){
                        setState(() {
                        setCamController(1);
                        });
                      }
                      }
                      ),
                ),
              ],
            ),
          ]
          ),
          new Column(mainAxisAlignment: MainAxisAlignment.end,children: <Widget>[
            new SizedBox(
                width: 90.0,
                child: new IconButton(icon: new Icon(Icons.camera, color: Colors.white),iconSize: 50.0, onPressed: null)
            ),
          ]),
        ]


    );
  }



}