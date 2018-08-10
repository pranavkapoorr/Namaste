import 'dart:async';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:Namaste/resources/UiResources.dart';
import 'package:flutter/material.dart';

class AlbumUploader extends StatefulWidget{
  @override
  _AlbumUploader createState()=>_AlbumUploader();
}
class _AlbumUploader extends State<AlbumUploader> {
  List<Widget> _imageTiles = new List();
  File _image;



  @override
  void initState() {
    super.initState();
    _addImages(6);

  }
  Future getImage() async {
    var img = await ImagePicker.pickImage(source: ImageSource.gallery);
        setState(() {
          print("adding new image $img");
          _imageTiles.insert(_imageTiles.length-1,_makeImageBox(Image.file(img, fit: BoxFit.cover,)));
        });

  }
  Widget _makeImageBox(Image image){
    return Container(
        margin: EdgeInsets.all(2.0),
        decoration: BoxDecoration(color: Colors.white),
        child: SizedBox(width: 400.0,height: 400.0,child: image));
  }
  void _addImages(int count){
    var addImageTile = Container(
      margin: EdgeInsets.all(2.0),
      constraints: BoxConstraints.expand(width: 400.0,height: 400.0),
      decoration: BoxDecoration(color: Colors.white),
      child: IconButton(
          icon: Icon(Icons.add), onPressed:getImage),);
    var image = _makeImageBox(Image.asset("images/bg.jpg",fit: BoxFit.cover,));
    for(int i = 0; i < count; i++){
      _imageTiles.add(i==0?addImageTile:image);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(gradient: myGradient,),
        child: new Scaffold(
            backgroundColor: Colors.transparent,
            appBar: new AppBar(title: new Text(
              "Manage Album", style: TextStyle(color: Colors.white),),
              backgroundColor: Colors.transparent,),
            body: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          blurRadius: .5,
                          spreadRadius: 1.0,
                          color: Colors.black.withOpacity(.12))
                    ],
                    borderRadius: BorderRadius.all(Radius.circular(5.0))
                ),
                child: GridView(
                              gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                              children: _imageTiles
                          ),
            )
        )
    );
  }
  @override
  void dispose() {
    _imageTiles.clear();
    super.dispose();
  }
}