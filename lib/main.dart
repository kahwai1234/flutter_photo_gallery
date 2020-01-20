import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_app_photogallery/Networking.dart';
import 'package:flutter_app_photogallery/model.dart';
import 'model.dart';

void main() => runApp(MaterialApp(
      home: PhotoGallery(),
      debugShowCheckedModeBanner: false,
    ));

class PhotoGallery extends StatefulWidget {
  @override
  _PhotoGalleryState createState() => _PhotoGalleryState();
}

class _PhotoGalleryState extends State<PhotoGallery> {
  List<ModelData> photoInfo = [];
  var num = Random();

  void getPhotoData() async {
    var num1 = num.nextInt(100);
    print(num1);
    print('ssss');
    NetworkHelper networkHelper =
        NetworkHelper('https://picsum.photos/v2/list?page=2&limit=$num1');

    var photoData = await networkHelper.getData();

    setState(() {
      for (var i = 0; i < 4; i++) {
        photoInfo.add(ModelData(photoData[i]['download_url'],
            photoData[i]['width'], photoData[i]['height']));
      }
    });
    print(photoInfo[0].width);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPhotoData();
  }

  @override
  Widget build(BuildContext context) {
    print('d');
    return Scaffold(
      backgroundColor: Colors.teal[200],
      appBar: AppBar(
        title: Text('Photo Gallery'),
        backgroundColor: Colors.teal,
      ),
      body: GestureDetector(
        onLongPressEnd: (details) {
          photoInfo.clear();
          print('listClear');
          getPhotoData();
          print('longPressEnd');
        },
        child: ListView.builder(
          itemCount: photoInfo?.length,
          itemBuilder: (context, i) => Card(
            margin: EdgeInsets.only(top: 10, right: 10, left: 10),
            elevation: 3.0,
            child: Column(
              children: <Widget>[
                Container(
                  child: AspectRatio(
                    aspectRatio: photoInfo[i].width / photoInfo[i].height,
                    child: Image.network(photoInfo[i].url),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
