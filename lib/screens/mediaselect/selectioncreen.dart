import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagrampub/main.dart';
import 'package:instagrampub/screens/camera_screen/nested_screens/create_story_screen.dart';
import 'package:instagrampub/screens/camera_screen/nested_screens/edit_photo_screen.dart';
import 'package:instagrampub/utilities/constants.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:video_player/video_player.dart';

class SelectScreen extends StatefulWidget {
  final CameraConsumer _cameraConsumer;
  SelectScreen(this._cameraConsumer);
  @override
  _SelectScreenState createState() => _SelectScreenState(this._cameraConsumer);
}

class _SelectScreenState extends State<SelectScreen> {
  final CameraConsumer _cameraConsumer;
  _SelectScreenState(this._cameraConsumer);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MediaGrid(this._cameraConsumer),
    );
  }
}

class MediaGrid extends StatefulWidget {
  final CameraConsumer _cameraConsumer;
  MediaGrid(this._cameraConsumer);

  @override
  _MediaGridState createState() => _MediaGridState(this._cameraConsumer);
}

class _MediaGridState extends State<MediaGrid> {
  final CameraConsumer _cameraConsumer;
  _MediaGridState(this._cameraConsumer);

  List<Widget> _mediaList = [];
  int currentPage = 0;
  int lastPage;
  String image;
  // ignore: non_constant_identifier_names
  //bool Isvideo = false;
  VideoPlayerController _controller;
  // ignore: non_constant_identifier_names
  int Videoduration;
  // ignore: non_constant_identifier_names
  String Videothumbnail;
  // ignore: unused_field
  File _selectedfile;

  @override
  void initState() {
    super.initState();
    _fetchNewMedia();
  }

  _showErrorDialog() {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text('Error'),
            content: _cameraConsumer == CameraConsumer.post ? Text('Video Post Cannot Be More Than 1 Minute') : Text('Story Cannot Be More Than 15 Seconds'),
            actions: <Widget>[
              TextButton(
                child: Text('Ok'),
                onPressed: () => Navigator.pop(context),
              )
            ],
          );
        });
  }

  @override
  void dispose() {
    super.dispose();
    _initializeVideo();
    _controller.pause().then((_) {
      _controller.dispose();
    });
  }

  _initializeVideo() {
    _controller = VideoPlayerController.file(
      File(image),
    )
      ..setLooping(false)
      ..initialize().then((_) {
        _controller.play();
      });
  }

  _pauseVideo() {
    _controller.pause();
  }

  _handleScrollEvent(ScrollNotification scroll) {
    if (scroll.metrics.pixels / scroll.metrics.maxScrollExtent > 0.33) {
      if (currentPage != lastPage) {
        _fetchNewMedia();
      }
    }
  }

  _fetchNewMedia() async {
    lastPage = currentPage;
    var result = await PhotoManager.requestPermission();
    if (result) {
      // success
//load the album list
      List<AssetPathEntity> albums =
          await PhotoManager.getAssetPathList(onlyAll: true, type: RequestType.image);
      print(albums);
      List<AssetEntity> media =
          await albums[0].getAssetListPaged(currentPage, 60);
      print(media);
      List<Widget> temp = [];
      for (var asset in media) {
        temp.add(
          FutureBuilder(
            future: asset.thumbDataWithSize(200, 200),
            builder: (BuildContext context, snapshot) {
              var part1 = (asset.duration / 60).truncate();
              // ignore: non_constant_identifier_names
              //String Videominutes = (part1 % 60).toString().padLeft(2, '0');
              // ignore: non_constant_identifier_names
              //String Videoseconds =
                  (asset.duration % 60).toString().padLeft(2, '0');
              // ignore: non_constant_identifier_names
              //String Videolength = (Videominutes + ':' + Videoseconds);
              if (snapshot.connectionState == ConnectionState.done)
                return GestureDetector(
                  onTap: () async {
                    File file = await asset.file;
                    _selectedfile = await asset.file;
                    setState(() {
                      image = file.path;
                      print(image);
                      print(asset.title);
                      // if (asset.type == AssetType.video) {
                      //   setState(() {
                      //     //Isvideo = true;
                      //     _initializeVideo();
                      //     Videoduration = asset.duration;
                      //   });
                      // } else {
                      //   if (Isvideo != false) {
                      //     setState(() {
                      //       Isvideo = false;
                      //       _pauseVideo();
                      //     });
                      //   }
                      // }
                    });
                    //upload file to firebase
                  },
                  child: Stack(
                    children: <Widget>[
                      Positioned.fill(
                        child: Image.memory(
                          snapshot.data,
                          fit: BoxFit.cover,
                        ),
                      ),
                      // if (asset.type == AssetType.video)
                      //   Align(
                      //     alignment: Alignment.bottomRight,
                      //     child: Padding(
                      //         padding: EdgeInsets.only(right: 5, bottom: 5),
                      //         child: Text(Videolength)
                      //         // Icon(
                      //         //   Icons.videocam,
                      //         //   color: Colors.white,
                      //         // ),
                      //         ),
                      //   ),
                    ],
                  ),
                );
              return Container();
            },
          ),
        );
      }
      setState(() {
        _mediaList.addAll(temp);
        currentPage++;
      });
    } else {
      // fail
      /// if result is fail, you can call `PhotoManager.openSetting();`  to open android/ios applicaton's setting to get permission
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: IconButton(
        //     onPressed: () {
        //       Navigator.push(
        //           context,
        //           MaterialPageRoute(
        //               builder: (BuildContext context) =>
        //                   EditPhotoScreen(imageFile: File(image))));
        //     },
        //     icon: Icon(Icons.arrow_right_alt_rounded)),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => MyApp(
                                  IsfromotherPage: true,
                                )));
                  },
                  icon: Icon(Icons.clear)),
              IconButton(
                  onPressed: () {
                    // if (Isvideo != false) {
                    //   if (_cameraConsumer == CameraConsumer.post) {
                    //     if (Videoduration > 60) {
                    //       _showErrorDialog();
                    //     } else {
                    //       Navigator.push(
                    //           context,
                    //           MaterialPageRoute(
                    //               builder: (BuildContext context) =>
                    //                   CreateVideoPost(
                    //                       imageFile: File(image),
                    //                       isphoto: false)));
                    //       _pauseVideo();
                    //     }
                    //   } else {
                    //     if (Videoduration > 15) {
                    //       _showErrorDialog();
                    //     }else{
                    //       Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //             builder: (BuildContext context) =>
                    //                 CreateStoryScreen(File(image), false)));
                    //     }
                    //   }
                    // } else {
                      if (_cameraConsumer == CameraConsumer.post) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    EditPhotoScreen(imageFile: File(image))));
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    CreateStoryScreen(File(image), true)));
                      }
                  },
                  icon: Icon(Icons.arrow_right_alt_rounded)),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scroll) {
            _handleScrollEvent(scroll);
            return;
          },
          child: Column(
            children: [
              Container(
                  height: MediaQuery.of(context).size.height * 0.45,
                  child: image != null
                      ? Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.45,
                                  width: MediaQuery.of(context).size.width,
                                  child: Image.file(File(image),
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.45,
                                      width: MediaQuery.of(context).size.width),
                                ) : Container(
                              child: Center(
                                child: Text('Choose a file'),
                              )),
                        ),
              Divider(),
              Container(
                height: MediaQuery.of(context).size.height * 0.38,
                child: GridView.builder(
                    itemCount: _mediaList.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3),
                    itemBuilder: (BuildContext context, int index) {
                      return _mediaList[index];
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
