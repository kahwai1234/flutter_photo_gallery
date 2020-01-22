import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_app_photogallery/Networking.dart';
import 'package:flutter_app_photogallery/model.dart';

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
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  void getPhotoData() async {
    var num1 = num.nextInt(96) + 4;
    NetworkHelper networkHelper =
        NetworkHelper('https://picsum.photos/v2/list?page=2&limit=$num1');
    var photoData = await networkHelper.getData();
    photoInfo.clear();
    setState(() {
      for (var i = 0; i < 4; i++) {
        photoInfo.add(ModelData(photoData[i]['download_url'],
            photoData[i]['width'], photoData[i]['height']));
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('initstate');
    handleRefresh();
  }

  Future<Null> handleRefresh() async {
    print(refreshKey.currentState);
    refreshKey.currentState?.show();
    await Future.delayed(
        Duration(seconds: 2)); // delayed 2 seconds for new data loading
    getPhotoData();
    return null;
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
      body: RefreshIndicator(
        key: refreshKey,
        child: ListView.builder(
          itemCount: photoInfo?.length,
          itemBuilder: (context, i) => GestureDetector(
            onLongPressStart: (details) {
              handleRefresh();
              photoInfo.clear();
            },
            child: Card(
              margin: EdgeInsets.only(top: 8, right: 8, left: 8),
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
        onRefresh: handleRefresh,
      ),
    );
  }
}
