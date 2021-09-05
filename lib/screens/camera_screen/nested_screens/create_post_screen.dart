import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagrampub/models/post.dart';
import 'package:instagrampub/models/user_data.dart';
import 'package:instagrampub/screens/camera_screen/widgets/location_form.dart';
import 'package:instagrampub/screens/camera_screen/widgets/post_caption_form.dart';
import 'package:instagrampub/services/api/sqldatabase.dart';
import 'package:instagrampub/utilities/constants.dart';
import 'package:instagrampub/utilities/custom_navigation.dart';
import 'package:provider/provider.dart';

class CreatePostScreen extends StatefulWidget {
  final Post post;
  final PostStatus postStatus;
  final File imageFile;
  //final bool isphoto;
  CreatePostScreen({
    this.post,
    this.postStatus,
    this.imageFile,
    //this.isphoto,
  });

  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  TextEditingController _captionController = TextEditingController();
  TextEditingController _locationController = TextEditingController();

  //bool isphoto;
  //_CreatePostScreenState(this.isphoto);

  final _formKey = GlobalKey<FormState>();

  String _caption = '';
  bool _isLoading = false;
  Post _post;
  String _currentUserId;
  //String selectedcategory = null;

  // var categories = [
  //   'Memes',
  //   'Pets & Animals',
  //   'People',
  //   'Sports',
  //   'Music',
  //   'Movies',
  //   'Food',
  //   'Comedy',
  //   'Gaming',
  //   'News & Politics',
  //   'Anime',
  //   'Cars & Vehicles',
  //   'Education',
  //   'Entertainment',
  //   'Health & Fitness',
  //   'Fashion',
  //   'Facts',
  //   'Science & Tech',
  //   'Non-Profit & Activism',
  //   'other'
  // ];
  @override
  initState() {
    super.initState();

    String currentUserId =
        Provider.of<UserData>(context, listen: false).currentUserId;

    setState(() {
      _currentUserId = currentUserId;
    });
    if (widget.post != null) {
      setState(() {
        _captionController.value = TextEditingValue(text: widget.post.caption);
        _locationController.value =
            TextEditingValue(text: widget.post.location);
        _caption = widget.post.caption;
        _post = widget.post;
      });
    }
  }

  @override
  void dispose() {
    _captionController?.dispose();
    _locationController?.dispose();
    super.dispose();
  }

  void _submit() async {
    FocusScope.of(context).unfocus();

    if (!_isLoading &&
        _formKey.currentState.validate() &&
        (widget.imageFile != null || _post.imageUrl != null)) {
      _formKey.currentState.save();

      if (mounted) {
        setState(() {
          _isLoading = true;
        });
      }

      if (_post != null) {
        // Edit existing Post
        Post post = Post(
          id: _post.id,
          imageUrl: _post.imageUrl,
          isphoto: _post.isphoto,
          //Category: selectedcategory,
          caption: _captionController.text.trim(),
          location: _locationController.text.trim(),
          likeCount: _post.likeCount,
          authorId: _post.authorId,
          timestamp: _post.timestamp,
          commentsAllowed: _post.commentsAllowed,
        );

        //DatabaseService.editPost(post, widget.postStatus);
      } else {
        //Create new Post
        // String imageUrl = await StroageService.uploadPost(widget.imageFile);
        // PostModel post = PostModel(
        //   imageUrl: imageUrl,
        //   isphoto: isphoto,
        //   Category: selectedcategory,
        //   caption: _captionController.text,
        //   location: _locationController.text,
        //   likeCount: 0,
        //   authorId: _currentUserId,
        //   timestamp: Timestamp.fromDate(DateTime.now()),
        //   commentsAllowed: true,
        // );

        // DatabaseService.createPost(post);
        // final statuscode = await SQLDatabase.uploadPost(
        //     widget.imageFile,
        //     widget.isphoto,
        //     _currentUserId,
        //     selectedcategory,
        //     _captionController.text,
        //     _locationController.text);

        // final statuscode = await SQLDatabase.uploadPost(
        //     widget.imageFile,
        //     widget.isphoto,
        //     _currentUserId,
        //     selectedcategory,
        //     _captionController.text,
        //     _locationController.text);

        //String photoorvideo = widget.isphoto == true ? '1' : '0';

        await SQLDatabase.createpost(
          widget.imageFile,
          _currentUserId,
          //photoorvideo,
          //selectedcategory,
          _captionController.text,
          _locationController.text
        );

        // if (statuscode == 200) {
        //   return showDialog(
        //       context: context,
        //       builder: (BuildContext context) => AlertDialog(
        //         title: Text('Post Created Succesfully'),
        //         content: Container(
        //         height: 500,
        //         width: 500,
        //         child: FlareActor(
        //           'assets/Checkmark Animation.flr',
        //           alignment: Alignment.bottomCenter,
        //           fit: BoxFit.cover,
        //           animation: "appear",
        //         ),
        //       ),
        //       actions: [
        //         TextButton(
        //           child: Text('Ok'),
        //           onPressed: () => _goToHomeScreen(),
        //         )
        //       ]
        //       ),
        //       );
        // }else{
        //   return showDialog(
        //       context: context,
        //       builder: (BuildContext context) => Container(
        //         height: 600,
        //         width: 600,
        //         child: AlertDialog(
        //           title: Text('Post Created Succesfully'),
        //           content: Container(
        //           height: 500,
        //           width: 500,
        //           child: Icon(Icons.warning)
        //         ),
        //         actions: [
        //           TextButton(
        //             child: Text('Ok'),
        //             onPressed: () => _goToHomeScreen(),
        //           )
        //         ]
        //         ),
        //       ),
        //       );
        // }
      }
      _goToHomeScreen();
    }
  }

  compressphoto() {}

  void _goToHomeScreen() {
    CustomNavigation.navigateToHomeScreen(context, _currentUserId);
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.color,
          centerTitle: true,
          title: Text(widget.imageFile == null ? 'Edit Post' : 'New Post'),
          actions: <Widget>[
            !_isLoading
                ? TextButton(
                    onPressed: () {
                      //if (selectedcategory != null) {
                        if (_caption.trim().length > 3) {
                          return _submit();
                        } else {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Please Write Caption'),
                                );
                              });
                        }
                      // } else {
                      //   showDialog(
                      //       context: context,
                      //       builder: (BuildContext context) {
                      //         return AlertDialog(
                      //           title: Text('Please Select Category'),
                      //         );
                      //       });
                      // }
                    },
                    child: Text(
                      widget.imageFile == null ? 'Save' : 'Share',
                      style: TextStyle(
                          color: _caption.trim().length > 3
                              ? Theme.of(context).accentColor
                              : Theme.of(context).hintColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0),
                    ))
                : Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: Center(
                      child: SizedBox(
                        child: CircularProgressIndicator(),
                        width: 20,
                        height: 20,
                      ),
                    ),
                  )
          ],
        ),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                PostCaptionForm(
                  screenSize: screenSize,
                  imageUrl: _post?.imageUrl,
                  controller: _captionController,
                  imageFile: widget?.imageFile,
                  onChanged: (val) {
                    setState(() {
                      _caption = val;
                    });
                  },
                ),
                Divider(),
                LocationForm(
                  screenSize: screenSize,
                  controller: _locationController,
                ),
                Divider(),
                // DropdownButton(
                //   value: selectedcategory,
                //   hint: Text(
                //     'Please Choose Category',
                //     style: TextStyle(
                //       fontWeight: FontWeight.bold,
                //       fontSize: 20,
                //       color: Colors.black,
                //     ),
                //   ),
                //   iconSize: 30,
                //   icon: Icon(Icons.keyboard_arrow_down),
                //   items: categories.map((String categories) {
                //     return DropdownMenuItem(
                //         value: categories, child: Text(categories));
                //   }).toList(),
                //   onChanged: (String newValue) {
                //     setState(() {
                //       selectedcategory = newValue;
                //     });
                //   },
                // )
              ],
            ),
          ),
        ));
  }
}
