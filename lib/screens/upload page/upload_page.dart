import 'package:flutter/material.dart';
import 'package:instagrampub/screens/mediaselect/selectioncreen.dart';
import 'package:instagrampub/utilities/constants.dart';

class UploadPage extends StatefulWidget {
  final CameraConsumer _cameraConsumer;
  UploadPage(this._cameraConsumer);

  @override
  _UploadPageState createState() => _UploadPageState(this._cameraConsumer);
}

class _UploadPageState extends State<UploadPage> {
  final CameraConsumer _cameraConsumer;
  _UploadPageState(this._cameraConsumer);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 1,
        child: Scaffold(
          bottomSheet: TabBar(
            tabs: [
              Tab(text: 'Gallery'),
              //Tab(text: 'Camera'),
              // Tab(
              //   text: 'Video',
              // )
            ],
          ),
          body: TabBarView(
            children: [
              SelectScreen(_cameraConsumer),
              //PhotoCamera(),
              //VideoCameraPage(_cameraConsumer),
            ],
          ),
        ));
  }
}
