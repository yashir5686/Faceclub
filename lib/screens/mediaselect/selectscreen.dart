import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:instagrampub/main.dart';
import 'package:instagrampub/screens/camera_screen/nested_screens/edit_photo_screen.dart';
import 'package:instagrampub/models/file.dart';
import 'package:storage_path/storage_path.dart';

class SelectMediaScreen extends StatefulWidget {
  SelectMediaScreen({Key key}) : super(key: key);
  @override
  _SelectMediaScreenState createState() => _SelectMediaScreenState();
}

class _SelectMediaScreenState extends State<SelectMediaScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MediaGrid(),
    );
  }
}

class MediaGrid extends StatefulWidget {
  @override
  _MediaGridState createState() => _MediaGridState();
}

class _MediaGridState extends State<MediaGrid> {
  List<FileModel> files;
  FileModel selectedModel;
  String image;
  bool imageselected = true;
  @override
  void initState() {
    super.initState();
    getImagesPath();
  }

  getImagesPath() async {
    var imagePath = await StoragePath.imagesPath;
    var images = jsonDecode(imagePath) as List;
    files = images.map<FileModel>((e) => FileModel.fromJson(e)).toList();
    if (files != null && files.length > 0)
      setState(() {
        selectedModel = files[0];
        image = files[0].files[0];
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                
                Icon(Icons.upload_rounded),
                Row(
                  children: [
                    SizedBox(width: 10),
                    DropdownButtonHideUnderline(
                        child: DropdownButton<FileModel>(
                      dropdownColor: Theme.of(context).accentColor,
                      items: getItems(),
                      onChanged: (FileModel d) {
                        assert(d.files.length > 0);
                        image = d.files[0];
                        setState(() {
                          selectedModel = d;
                        });
                      },
                      value: selectedModel,
                    ))
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                EditPhotoScreen(imageFile: File(image))));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Next',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                )
              ],
            ),
            Divider(),
            Container(
                height: MediaQuery.of(context).size.height * 0.45,
                child: image != null
                    ? Image.file(File(image),
                        height: MediaQuery.of(context).size.height * 0.45,
                        width: MediaQuery.of(context).size.width)
                    : Container()),
            Divider(),
            selectedModel == null && selectedModel.files.length < 1
                ? Container()
                : Container(
                    height: MediaQuery.of(context).size.height * 0.38,
                    child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            crossAxisSpacing: 4,
                            mainAxisSpacing: 4),
                        itemBuilder: (_, i) {
                          var file = selectedModel.files[i];
                          return GestureDetector(
                            child: Image.file(
                              File(file),
                              fit: BoxFit.cover,
                            ),
                            onTap: () {
                              setState(() {
                                image = file;
                              });
                            },
                          );
                        },
                        itemCount: selectedModel.files.length),
                  )
          ],
        ),
      ),
    );
  }

  List<DropdownMenuItem> getItems() {
    return files
            .map((e) => DropdownMenuItem(
                  child: Text(
                    e.folder,
                    style: TextStyle(color: Colors.black),
                  ),
                  value: e,
                ))
            .toList() ??
        [];
  }
}
