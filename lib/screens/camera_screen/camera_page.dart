// import 'dart:io';
// import 'dart:math';

// import 'package:camera/camera.dart';
// import 'package:cross_file/cross_file.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:instagram/screens/camera_screen/nested_screens/edit_photo_screen.dart';
// import 'package:instagram/screens/camera_screen/supporting%20pages/CameraView.dart';
// import 'package:instagram/screens/camera_screen/supporting%20pages/VideoView.dart';
// import 'package:instagram/screens/home_screen/home_screen.dart';
// import 'package:instagram/screens/mediaselect/selectioncreen.dart';
// import 'package:instagram/screens/profile_screen/profile_screen.dart';
// import 'package:instagram/screens/stories_screen/widgets/circular_icon_button.dart';
// import 'package:instagram/utilities/constants.dart';
// import 'package:instagram/utilities/themes.dart';
// import 'package:ionicons/ionicons.dart';
// import 'package:path/path.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:story_designer/story_designer.dart';

// List<CameraDescription> cameras;

// class CameraScreen extends StatefulWidget {
//   // final Function backToHomeScreen;
//   // final CameraConsumer cameraConsumer;
//   // CameraScreen(this.backToHomeScreen, this.cameraConsumer);

//   @override
//   _CameraScreenState createState() => _CameraScreenState();
// }

// class _CameraScreenState extends State<CameraScreen> {
//   CameraController _cameraController;
//   Future<void> cameraValue;
//   bool isRecoring = false;
//   bool iscamerafront = true;
//   double transform = 0;
//   final _picker = ImagePicker();
//   bool isphoto;
//   //CameraConsumer _cameraConsumer = CameraConsumer.post;

//   @override
//   void initState() {
//     super.initState();
//     _cameraController = CameraController(cameras[0], ResolutionPreset.high);
//     cameraValue = _cameraController.initialize();
//     // if (widget.cameraConsumer != CameraConsumer.post) {
//     //   changeConsumer(widget.cameraConsumer);
//     // }
//     // Function backToHomeScreen;
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _cameraController.dispose();
//   }

//   // void changeConsumer(CameraConsumer cameraConsumer) {
//   //   if (_cameraConsumer != cameraConsumer) {
//   //     setState(() => _cameraConsumer = cameraConsumer);
//   //   }
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           FutureBuilder(
//               future: cameraValue,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.done) {
//                   return Container(
//                       width: MediaQuery.of(context).size.width,
//                       height: MediaQuery.of(context).size.height,
//                       child: CameraPreview(_cameraController));
//                 } else {
//                   return Center(
//                     child: CircularProgressIndicator(),
//                   );
//                 }
//               }),
//           Positioned(
//             bottom: 0.0,
//             child: Container(
//               color: Colors.black,
//               padding: EdgeInsets.only(top: 5, bottom: 5),
//               width: MediaQuery.of(context).size.width,
//               child: Column(
//                 children: [
//                   Row(
//                     mainAxisSize: MainAxisSize.max,
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       GestureDetector(
//                         onLongPress: () async {
//                           await _cameraController.startVideoRecording();
//                           setState(() {
//                             isRecoring = true;
//                           });
//                         },
//                         onLongPressUp: () async {
//                           XFile videopath =
//                               await _cameraController.stopVideoRecording();
//                           setState(() {
//                             isRecoring = false;
//                           });
//                           Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (builder) => VideoViewPage(
//                                         path: videopath.path,
//                                       )));
//                         },
//                         onTap: () {
//                           if (!isRecoring) takePhoto(context);
//                         },
//                         child: isRecoring
//                             ? Icon(
//                                 Icons.radio_button_on,
//                                 color: Colors.red,
//                                 size: 80,
//                               )
//                             : Icon(
//                                 Icons.panorama_fish_eye,
//                                 color: Colors.white,
//                                 size: 70,
//                               ),
//                       ),
//                       IconButton(
//                           icon: Transform.rotate(
//                             angle: transform,
//                             child: Icon(
//                               Icons.flip_camera_ios,
//                               color: Colors.white,
//                               size: 28,
//                             ),
//                           ),
//                           onPressed: () async {
//                             setState(() {
//                               iscamerafront = !iscamerafront;
//                               transform = transform + pi;
//                             });
//                             int cameraPos = iscamerafront ? 0 : 1;
//                             _cameraController = CameraController(
//                                 cameras[cameraPos], ResolutionPreset.high);
//                             cameraValue = _cameraController.initialize();
//                           }),
//                     ],
//                   ),
//                   SizedBox(
//                     height: 4,
//                   ),
//                   Text(
//                     "Hold for Video, tap for photo",
//                     style: TextStyle(
//                       color: Colors.white,
//                     ),
//                     textAlign: TextAlign.center,
//                   )
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void takePhoto(BuildContext context) async {
//     XFile file = await _cameraController.takePicture();
//     File imageFile = File(file.path);
//     // if (_cameraConsumer == CameraConsumer.post) {
//     //   setState(() {
//     //     isphoto = true;
//     //   });
//     //   Navigator.push(
//     //       context,
//     //       MaterialPageRoute(
//     //           builder: (context) => EditPhotoScreen(imageFile: imageFile)));
//     // }
//     // if (_cameraConsumer == CameraConsumer.story) {
//     //   setState(() {
//     //     isphoto = true;
//     //   });
//     //   File editedFile = await Navigator.of(context).push(
//     //                   new MaterialPageRoute(builder: (context)=> StoryDesigner(
//     //                     filePath: file.path,
//     //                   ))
//     //   );

//     // }
//   }
// }

// // import 'dart:math';

// // import 'package:camera/camera.dart';
// // import 'package:flutter/material.dart';
// // import 'package:instagram/screens/camera_screen/supporting%20pages/CameraView.dart';
// // import 'package:instagram/screens/camera_screen/supporting%20pages/VideoView.dart';

// // List<CameraDescription> cameras;

// // class CameraScreen extends StatefulWidget {
// //   CameraScreen({Key key}) : super(key: key);

// //   @override
// //   _CameraScreenState createState() => _CameraScreenState();
// // }

// // class _CameraScreenState extends State<CameraScreen> {
// //   CameraController _cameraController;
// //   Future<void> cameraValue;
// //   bool isRecoring = false;
// //   bool flash = false;
// //   bool iscamerafront = true;
// //   double transform = 0;

// //   // @override
// //   // void initState() {
// //   //   super.initState();
// //   //   _cameraController = CameraController(cameras[0], ResolutionPreset.high);
// //   //   cameraValue = _cameraController.initialize();
// //   // }

// //   @override
// //   void initState() {
// //     super.initState();
// //     _cameraController = CameraController(cameras[0], ResolutionPreset.high);
// //     cameraValue = _cameraController.initialize();
// //   }

// //   @override
// //   void dispose() {
// //     super.dispose();
// //     _cameraController.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //         body: Container(
// //       color: Colors.blue,
// //     )
//         // Stack(
//         //   children: [
//         //     FutureBuilder(
//         //         future: cameraValue,
//         //         builder: (context, snapshot) {
//         //           if (snapshot.connectionState == ConnectionState.done) {
//         //             return Container(
//         //                 width: MediaQuery.of(context).size.width,
//         //                 height: MediaQuery.of(context).size.height,
//         //                 child: CameraPreview(_cameraController));
//         //           } else {
//         //             return Center(
//         //               child: CircularProgressIndicator(),
//         //             );
//         //           }
//         //         }),
//         //     Positioned(
//         //       bottom: 0.0,
//         //       child: Container(
//         //         color: Colors.black,
//         //         padding: EdgeInsets.only(top: 5, bottom: 5),
//         //         width: MediaQuery.of(context).size.width,
//         //         child: Column(
//         //           children: [
//         //             Row(
//         //               mainAxisSize: MainAxisSize.max,
//         //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         //               children: [
//         //                 GestureDetector(
//         //                   onLongPress: () async {
//         //                     await _cameraController.startVideoRecording();
//         //                     setState(() {
//         //                       isRecoring = true;
//         //                     });
//         //                   },
//         //                   onLongPressUp: () async {
//         //                     XFile videopath =
//         //                         await _cameraController.stopVideoRecording();
//         //                     setState(() {
//         //                       isRecoring = false;
//         //                     });
//         //                     // Navigator.push(
//         //                     //     context,
//         //                     //     MaterialPageRoute(
//         //                     //         builder: (builder) => VideoViewPage(
//         //                     //               path: videopath.path,
//         //                     //             )));
//         //                   },
//         //                   onTap: () {
//         //                     if (!isRecoring) takePhoto(context);
//         //                   },
//         //                   child: isRecoring
//         //                       ? Icon(
//         //                           Icons.radio_button_on,
//         //                           color: Colors.red,
//         //                           size: 80,
//         //                         )
//         //                       : Icon(
//         //                           Icons.panorama_fish_eye,
//         //                           color: Colors.white,
//         //                           size: 70,
//         //                         ),
//         //                 ),
//         //                 IconButton(
//         //                     icon: Transform.rotate(
//         //                       angle: transform,
//         //                       child: Icon(
//         //                         Icons.flip_camera_ios,
//         //                         color: Colors.white,
//         //                         size: 28,
//         //                       ),
//         //                     ),
//         //                     onPressed: () async {
//         //                       setState(() {
//         //                         iscamerafront = !iscamerafront;
//         //                         transform = transform + pi;
//         //                       });
//         //                       int cameraPos = iscamerafront ? 0 : 1;
//         //                       _cameraController = CameraController(
//         //                           cameras[cameraPos], ResolutionPreset.high);
//         //                       cameraValue = _cameraController.initialize();
//         //                     }),
//         //               ],
//         //             ),
//         //             SizedBox(
//         //               height: 4,
//         //             ),
//         //             Text(
//         //               "Hold for Video, tap for photo",
//         //               style: TextStyle(
//         //                 color: Colors.white,
//         //               ),
//         //               textAlign: TextAlign.center,
//         //             )
//         //           ],
//         //         ),
//         //       ),
//         //     ),
//         //   ],
//         // ),
//   //       );
//   // }

//   // void takePhoto(BuildContext context) async {
//   //   XFile file = await _cameraController.takePicture();
//   //   // Navigator.push(
//   //   //     context,
//   //   //     MaterialPageRoute(
//   //   //         builder: (builder) => CameraViewPage(
//   //   //               path: file.path,
//   //   //             )));
//   // }
// //}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagrampub/screens/camera_screen/nested_screens/create_story_screen.dart';
import 'package:instagrampub/screens/camera_screen/nested_screens/create_video_post.dart';
import 'package:instagrampub/utilities/constants.dart';

// class PhotoCamera extends StatefulWidget {
//   //final CameraConsumer _cameraConsumer;
//   //PhotoCamera(this._cameraConsumer);

//   @override
//   _PhotoCameraState createState() => _PhotoCameraState();
// }

// class _PhotoCameraState extends State<PhotoCamera> {
//   //final CameraConsumer _cameraConsumer;
//   //_PhotoCameraState(this._cameraConsumer);
//   //CameraController controller;

//   @override
//   void initState() {
//     super.initState();
//     //_openCamera();
//   }

//   // _openCamera() async {
//   //   PickedFile pickedFile = await ;
//   //   File imageFile = File(pickedFile.path);
//   //
//   //   if (imageFile != null) {
//   //     if (_cameraConsumer == CameraConsumer.post) {
//   //       Navigator.push(
//   //           context,
//   //           MaterialPageRoute(
//   //               builder: (BuildContext context) =>
//   //                   EditPhotoScreen(imageFile: imageFile, isphoto: true,)));
//   //     } else {
//   //       Navigator.push(
//   //           context,
//   //           MaterialPageRoute(
//   //               builder: (BuildContext context) =>
//   //                   CreateStoryScreen(imageFile, true)));
//   //     }
//   //   }
//   // }

//   @override
//   Widget build(BuildContext context) {
//     //   Container(
//     //   color: Theme.of(context).backgroundColor,
//     //   child: Center(
//     //     child: Container(
//     //       margin: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
//     //       child: ElevatedButton(
//     //           onPressed: () => _openCamera(),
//     //           child: Row(
//     //             children: [
//     //               Container(
//     //                 height: 38,
//     //                 margin: const EdgeInsets.symmetric(horizontal: 4.0),
//     //                 decoration: BoxDecoration(
//     //                   shape: BoxShape.circle,
//     //                   color: Colors.lightBlue[400],
//     //                 ),
//     //                 child: IconButton(
//     //                   icon: Icon(
//     //                     Icons.camera_alt,
//     //                     color: Colors.white,
//     //                     size: 20,
//     //                   ),
//     //                   onPressed: () => _openCamera(),
//     //                 ),
//     //               ),
//     //               Text("Open Camera")
//     //             ],
//     //           )),
//     //     ),
//     //   ),
//     // );
//   }
// }

class VideoCameraPage extends StatefulWidget {
  final CameraConsumer _cameraConsumer;
  VideoCameraPage(this._cameraConsumer);

  @override
  _VideoCameraPageState createState() =>
      _VideoCameraPageState(this._cameraConsumer);
}

class _VideoCameraPageState extends State<VideoCameraPage> {
  final CameraConsumer _cameraConsumer;
  _VideoCameraPageState(this._cameraConsumer);

  @override
  void initState() {
    super.initState();
    _openCamera();
  }

  _openCamera() async {
    PickedFile pickedFile = await ImagePicker().getVideo(
        source: ImageSource.camera, maxDuration: Duration(seconds: 60));
    File imageFile = File(pickedFile.path);

    if (imageFile != null) {
      if (_cameraConsumer == CameraConsumer.post) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) =>
                    CreateVideoPost(imageFile: imageFile, isphoto: false,)));
      } else {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) =>
                    CreateStoryScreen(imageFile, false)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).backgroundColor,
      child: Center(
        child: Container(
          margin: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
          child: Padding(
            padding: EdgeInsets.only(left: 8, right: 8, bottom: 8),
            child: ElevatedButton(
                onPressed: () => _openCamera(),
                child: Row(
                  children: [
                    Container(
                      height: 38,
                      margin: const EdgeInsets.symmetric(horizontal: 4.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.lightBlue[400],
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: () => _openCamera(),
                      ),
                    ),
                    Text("Open Camera")
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
