import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:instagrampub/models/User.dart';
import 'package:instagrampub/models/user_data.dart';
import 'package:instagrampub/screens/camera_screen/widgets/custom_text_form.dart';
import 'package:instagrampub/screens/camera_screen/widgets/duration_form.dart';
import 'package:instagrampub/screens/camera_screen/widgets/location_form.dart';
import 'package:instagrampub/screens/stories_screen/widgets/circular_icon_button.dart';
import 'package:instagrampub/services/api/storage_service.dart';
import 'package:instagrampub/services/core/liquid_swipe_pages.dart';
import 'package:instagrampub/services/core/url_validator_service.dart';
import 'package:instagrampub/utilities/constants.dart';
import 'package:instagrampub/utilities/custom_navigation.dart';
import 'package:instagrampub/utilities/filters.dart';
import 'package:instagrampub/utilities/show_error_dialog.dart';
import 'package:instagrampub/utilities/themes.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:video_player/video_player.dart';

class CreateStoryScreen extends StatefulWidget {
  final File imageFile;
  final bool isphoto;
  CreateStoryScreen(this.imageFile, this.isphoto);
  @override
  _CreateStoryScreenState createState() => _CreateStoryScreenState();
}

class _CreateStoryScreenState extends State<CreateStoryScreen> {
  final GlobalKey _globalKey = GlobalKey();
  String _filterTitle = '';
  bool _newFilterTitle = false;
  // PageController _pageController = PageController();
  int _selectedFilterIndex = 0;
  bool _isLoading = false;
  LiquidController _liquidController = LiquidController();

  TextEditingController _captionController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _linkController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  String _storyCaption = '';
  String _storyLocation = '';
  String _storyLink = '';
  int _storyDuration = 15;
  Size _screenSize;
  List<Container> _filterPages;
  VideoPlayerController _controller;
  int videolength;

  @override
  void dispose() {
    _captionController?.dispose();
    _locationController?.dispose();
    _linkController?.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.isphoto != true) {
      _initializevideo();
    }
  }

  _initializevideo() {
    _controller = VideoPlayerController.file(widget.imageFile)
      ..setLooping(true)
      ..initialize().then((_) {
        _controller.play();
        setState(() {
          Duration videoduration = _controller.value.duration;
          videolength = videoduration.inSeconds;
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    final User _currentUser = Provider.of<UserData>(context).currentUser;

    setState(() {
      _screenSize = MediaQuery.of(context).size;
      _filterPages = LiquidSwipePagesService.getImageFilteredPaged(
          imageFile: widget.imageFile,
          height: _screenSize.height,
          width: _screenSize.width);
    });

    return Scaffold(
      backgroundColor: Theme.of(context).accentColor,
      body: Stack(
        children: <Widget>[
          widget.isphoto != false
              ? Center(
                  child: RepaintBoundary(
                    key: _globalKey,
                    child: Container(
                      child: LiquidSwipe(
                        pages: _filterPages,
                        onPageChangeCallback: (value) {
                          setState(() => _selectedFilterIndex = value);
                          _setFilterTitle(value);
                        },
                        waveType: WaveType.liquidReveal,
                        liquidController: _liquidController,
                        ignoreUserGestureWhileAnimating: true,
                        enableLoop: true,
                      ),
                    ),
                  ),
                )
              : Center(child: VideoPlayer(_controller)),
          if (_newFilterTitle)
            // displays filter title once filtered changed
            _displayStoryTitle(),
          if (_storyCaption != '')
            // desplays story caption if there is
            _displayStoryCaption(),
          if (_storyLocation != '')
            // desplays story location if there is
            _displayLocationText(),
          if (_isLoading)
            // desplays circular indicator if posting story
            Align(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            ),

          // displays row of buttons on top of the screen
          if (!_isLoading) _displayEditStoryButtons(_currentUser),

          // displays post buttons on bottom of the screen
          if (!_isLoading) _displayBottomButtons(_currentUser),
        ],
      ),
    );
  }

  void _setFilterTitle(title) {
    setState(() {
      _filterTitle = filters[title].name;
      _newFilterTitle = true;
    });
    Timer(Duration(milliseconds: 1000), () {
      if (_filterTitle == filters[title].name) {
        setState(() => _newFilterTitle = false);
      }
    });
  }

  void _showEditStory({@required Function onSave, @required Widget widget}) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  widget,
                  SizedBox(height: 10),
                  TextButton(
                      onPressed: () {
                        if (_formKey.currentState.validate() && !_isLoading) {
                          _formKey.currentState.save();
                          onSave();
                          Navigator.pop(context);
                        }
                      },
                      child: Text(
                        'Save',
                        style: TextStyle(color: Colors.white),
                      )),
                  SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
                ],
              ),
            ),
          );
        });
  }

  Align _displayLocationText() {
    return Align(
      alignment: Alignment.lerp(Alignment.center, Alignment.bottomCenter, 0.6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Ionicons.location_sharp,
            size: 20,
            color: Colors.white,
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            _storyLocation,
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Align _displayBottomButtons(User _currentUser) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          // ignore: deprecated_member_use
          RaisedButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            onPressed: () => _createStory(_currentUser.id),
            color: Theme.of(context).primaryColor.withOpacity(0.8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey,
                  radius: 15.0,
                  backgroundImage: _currentUser.profileImageUrl.isEmpty
                      ? AssetImage(placeHolderImageRef)
                      : CachedNetworkImageProvider(
                          _currentUser.profileImageUrl),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Text(
                  'Post Story',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          // ignore: deprecated_member_use
          RaisedButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            onPressed: () => _shareImageToMessages(),
            color: Theme.of(context).primaryColor.withOpacity(0.8),
            child: Text(
              'Share to..',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Align _displayStoryTitle() {
    return Align(
      alignment: Alignment.center,
      child: Text(
        _filterTitle,
        style: TextStyle(
            fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }

  Align _displayStoryCaption() {
    return Align(
      alignment: Alignment.lerp(Alignment.center, Alignment.bottomCenter, 0.4),
      child: Text(
        _storyCaption,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 30, color: Colors.white),
      ),
    );
  }

  Align _displayEditStoryButtons(User currentuser) {
    int _duration;
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 30.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircularIconButton(
              backColor: Colors.black26,
              splashColor: kBlueColorWithOpacity,
              icon: Icon(
                Ionicons.close_sharp,
                color: Colors.white,
                size: 22,
              ),
              onTap: () => Navigator.pop(context),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.7,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  _selectedFilterIndex != 0 ||
                          _storyCaption != '' ||
                          _storyLink != '' ||
                          _storyLocation != '' ||
                          _storyDuration != 15
                      // if current filter is not the first filter (no filter)
                      ? CircularIconButton(
                          padding: const EdgeInsets.only(right: 8),
                          backColor: _selectedFilterIndex != 0 ||
                                  _storyCaption != '' ||
                                  _storyLink != '' ||
                                  _storyLocation != '' ||
                                  _storyDuration != 15
                              ? kBlueColorWithOpacity
                              : Colors.black26,
                          splashColor: _selectedFilterIndex != 0 ||
                                  _storyCaption != '' ||
                                  _storyLink != '' ||
                                  _storyLocation != '' ||
                                  _storyDuration != 15
                              ? Colors.black26
                              : kBlueColorWithOpacity,
                          icon: Icon(
                            Ionicons.refresh_sharp,
                            color: Colors.white,
                            size: 22,
                          ),
                          onTap: () {
                            setState(() {
                              _storyCaption = '';
                              _storyLocation = '';
                              _storyLink = '';
                              _storyDuration = 15;
                            });
                            _captionController.clear();
                            _locationController.clear();
                            _linkController.clear();
                            _liquidController.jumpToPage(page: 0);
                          },
                        )
                      : SizedBox.shrink(),
                  widget.isphoto != false
                      ? CircularIconButton(
                          padding: const EdgeInsets.only(right: 8),
                          backColor: _storyDuration == 15
                              ? Colors.black26
                              : kBlueColorWithOpacity,
                          splashColor: _storyDuration == 15
                              ? Colors.black26
                              : kBlueColorWithOpacity,
                          icon: Icon(
                            Ionicons.timer_outline,
                            color: Colors.white,
                            size: 22,
                          ),
                          onTap: () => _showEditStory(
                              onSave: () {
                                setState(() {
                                  _storyDuration = _duration;
                                });
                              },
                              widget: DurationForm(
                                  currentUser: currentuser,
                                  screenSize: _screenSize,
                                  onChange: (double value) {
                                    _duration = value.toInt();
                                  },
                                  duration: _storyDuration)),
                        )
                      : SizedBox.shrink(),
                  CircularIconButton(
                    padding: const EdgeInsets.only(right: 8),
                    backColor: _storyLink != ''
                        ? kBlueColorWithOpacity
                        : Colors.black26,
                    splashColor: _storyLink == ''
                        ? kBlueColorWithOpacity
                        : Colors.black26,
                    icon: Icon(
                      Ionicons.link_sharp,
                      color: Colors.white,
                      size: 22,
                    ),
                    onTap: () => _showEditStory(
                      onSave: () async {
                        String url = await UrlValidatorService.isUrlValid(
                            context, _linkController.text.trim());
                        if (url != null) {
                          setState(() => _storyLink = url);
                        } else {
                          _linkController.clear();
                        }
                      },
                      widget: CustomTextForm(
                        maxLength: 300,
                        hintText: 'Link',
                        controller: _linkController,
                        screenSize: _screenSize,
                      ),
                    ),
                  ),
                  CircularIconButton(
                    padding: const EdgeInsets.only(right: 8),
                    backColor: _storyLocation != ''
                        ? kBlueColorWithOpacity
                        : Colors.black26,
                    splashColor: _storyLocation == ''
                        ? kBlueColorWithOpacity
                        : Colors.black26,
                    icon: Icon(
                      Ionicons.location_sharp,
                      color: Colors.white,
                      size: 22,
                    ),
                    onTap: () => _showEditStory(
                        onSave: () {
                          setState(() {
                            _storyLocation = _locationController.text.trim();
                          });
                        },
                        widget: LocationForm(
                          screenSize: _screenSize,
                          controller: _locationController,
                        )),
                  ),
                  CircularIconButton(
                    backColor: _storyCaption != ''
                        ? kBlueColorWithOpacity
                        : Colors.black26,
                    splashColor: _storyCaption == ''
                        ? kBlueColorWithOpacity
                        : Colors.black26,
                    icon: Icon(
                      Ionicons.text_sharp,
                      color: Colors.white,
                      size: 22,
                    ),
                    onTap: () => _showEditStory(
                      onSave: () {
                        setState(() {
                          _storyCaption = _captionController.text.trim();
                        });
                      },
                      widget: CustomTextForm(
                        maxLength: 40,
                        hintText: 'Caption',
                        controller: _captionController,
                        screenSize: _screenSize,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _createStory(String currentUserId) async {
    if (!_isLoading && widget.imageFile != null) {
      setState(() => _isLoading = true);
      if (widget.isphoto != false) {
        // String imageUrl =
        //     await StroageService.uploadStoryImage(widget.imageFile);
        final DateTime dateNow = DateTime.now();
        final DateTime timeStart = DateTime.now();
        final DateTime timeEnd = DateTime(
          dateNow.year,
          dateNow.month,
          dateNow.day + 1,
          dateNow.hour,
          dateNow.minute,
          dateNow.second,
          dateNow.microsecond,
        );

        // Story story = Story(
        //   timeStart: timeStart,
        //   timeEnd: timeEnd,
        //   authorId: currentUserId,
        //   imageUrl: imageUrl,
        //   caption: _storyCaption,
        //   isphoto: true,
        //   views: {},
        //   location: _storyLocation,
        //   filter: _filterTitle,
        //   duration: _storyDuration,
        //   linkUrl: _storyLink,
        // );
        //await StoriesService.createStory();
        setState(() => _isLoading == false);
        CustomNavigation.navigateToHomeScreen(context, currentUserId);
      } else {
        // String imageUrl =
        //     await StroageService.uploadStoryVideo(widget.imageFile);
        final DateTime dateNow = DateTime.now();
        final DateTime timeStart = DateTime.now();
        final DateTime timeEnd = DateTime(
          dateNow.year,
          dateNow.month,
          dateNow.day + 1,
          dateNow.hour,
          dateNow.minute,
          dateNow.second,
          dateNow.microsecond,
        );

        // Story story = Story(
        //   timeStart: timeStart,
        //   timeEnd: timeEnd,
        //   authorId: currentUserId,
        //   imageUrl: imageUrl,
        //   caption: _storyCaption,
        //   isphoto: false,
        //   views: {},
        //   location: _storyLocation,
        //   filter: _filterTitle,
        //   duration: videolength,
        //   linkUrl: _storyLink,
        // );
        // await StoriesService.createStory(story);
        setState(() => _isLoading == false);
        CustomNavigation.navigateToHomeScreen(context, currentUserId);
      }
    }
  }

  void _shareImageToMessages() async {
    File imageFile = widget.imageFile;
    if (imageFile == null) {
      ShowErrorDialog.showAlertDialog(
          errorMessage: 'Could not convert image.', context: context);
      return;
    }
    if (widget.isphoto != false) {
      showModalBottomSheet(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
          context: context,
          builder: (context) {
            return; // return DirectMessagesWidget(
            //   searchFrom: SearchFrom.createStoryScreen,
            //   imageFile: imageFile,
            // );
          });
    } else {
      ShowErrorDialog.showAlertDialog(
          errorMessage: 'Cannot Send Video In Chat', context: context);
      return;
    }
  }
}
