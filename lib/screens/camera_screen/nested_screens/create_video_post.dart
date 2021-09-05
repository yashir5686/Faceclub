import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagrampub/models/post.dart';
import 'package:instagrampub/models/post_model.dart';
import 'package:instagrampub/models/user_data.dart';
import 'package:instagrampub/screens/camera_screen/widgets/location_form.dart';
import 'package:instagrampub/screens/camera_screen/widgets/post_caption_form.dart';
import 'package:instagrampub/services/api/database_service.dart';
import 'package:instagrampub/services/api/storage_service.dart';
import 'package:instagrampub/utilities/constants.dart';
import 'package:instagrampub/utilities/custom_navigation.dart';
import 'package:provider/provider.dart';

class CreateVideoPost extends StatefulWidget {
  final Post post;
  final PostStatus postStatus;
  final File imageFile;
  final bool isphoto;
  CreateVideoPost({
    this.post,
    this.postStatus,
    this.imageFile,
    this.isphoto,
  });

  @override
  _CreateVideoPostState createState() => _CreateVideoPostState(this.isphoto);
}

class _CreateVideoPostState extends State<CreateVideoPost> {
  TextEditingController _captionController = TextEditingController();
  TextEditingController _locationController = TextEditingController();

  bool isphoto;
  _CreateVideoPostState(this.isphoto);

  final _formKey = GlobalKey<FormState>();

  String _caption = '';
  bool _isLoading = false;
  Post _post;
  String _currentUserId;
  // ignore: avoid_init_to_null
  String selectedcategory = null;

  var categories = [
    'Memes',
    'Pets & Animals',
    'People',
    'Sports',
    'Music',
    'Movies',
    'Food',
    'Comedy',
    'Gaming',
    'News & Politics',
    'Anime',
    'Cars & Vehicles',
    'Education',
    'Entertainment',
    'Health & Fitness',
    'Fashion',
    'Facts',
    'Science & Tech',
    'Non-Profit & Activism'
    'other'
  ];

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
        // // String imageUrl =
        // //     await StroageService.uploadVideoPost(widget.imageFile);
        Post post = Post(
          //imageUrl: imageUrl,
          caption: _captionController.text,
          location: _locationController.text,
          likeCount: 0,
          authorId: _currentUserId,
          timestamp: DateTime.now(),
          commentsAllowed: true,
        );

        //DatabaseService.createPost(post);
      }
      _goToHomeScreen();
    }
  }

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
                      if (selectedcategory != null) {
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
                      } else {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Please Select Category'),
                              );
                            });
                      }
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
                DropdownButton(
                  value: selectedcategory,
                  hint: Text(
                    'Please Choose Category',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                  iconSize: 30,
                  icon: Icon(Icons.keyboard_arrow_down),
                  items: categories.map((String categories) {
                    return DropdownMenuItem(
                        value: categories, child: Text(categories));
                  }).toList(),
                  onChanged: (String newValue) {
                    setState(() {
                      selectedcategory = newValue;
                    });
                  },
                )
              ],
            ),
          ),
        ));
  }
}
