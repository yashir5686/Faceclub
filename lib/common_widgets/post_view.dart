import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:instagrampub/common_widgets/heart_anime.dart';
import 'package:instagrampub/common_widgets/user_badges.dart';
import 'package:instagrampub/models/User.dart';
import 'package:instagrampub/models/post.dart';
import 'package:instagrampub/multi%20manager/flick_multi_manager.dart';
import 'package:instagrampub/multi%20manager/portrait_controls.dart';
import 'package:instagrampub/screens/camera_screen/nested_screens/create_post_screen.dart';
import 'package:instagrampub/screens/comments_screen/comments_screen.dart';
import 'package:instagrampub/screens/home_screen/home_screen.dart';
import 'package:instagrampub/services/api/sqldatabase.dart';
import 'package:instagrampub/utilities/constants.dart';
import 'package:instagrampub/utilities/custom_navigation.dart';
import 'package:instagrampub/utilities/themes.dart';
import 'package:instagrampub/utilities/zoomOverlay.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class PostView extends StatefulWidget {
  final String currentUserId;
  final Post post;
  final User author;
  final PostStatus postStatus;

  PostView(
      {this.currentUserId, this.post, this.author, @required this.postStatus});

  @override
  _PostViewState createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  int _likeCount = 0;
  bool _isLiked = false;
  bool _heartAnim = false;
  Post _post;
  //VideoPlayerController _controller;
  FlickMultiManager flickMultiManager;
  FlickManager flickManager;
  bool _isLiking = false;

  @override
  void initState() {
    super.initState();
    _post = widget.post;
    _initPostLiked();
    _likeCount = _post.likeCount;
    //_initializevideo();
    flickMultiManager = FlickMultiManager();
    flickManager = FlickManager(
      videoPlayerController: VideoPlayerController.network(_post.imageUrl)
        ..setLooping(true),
      autoPlay: false,
    );
    flickMultiManager.init(flickManager);
  }

  @override
  void deactivate() {
    //_controller.setVolume(0.0);
    super.deactivate();
    flickMultiManager.remove(flickManager);
  }

  @override
  didUpdateWidget(PostView oldWidget) async {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.post.likeCount != _post.likeCount) {
      _likeCount = _post.likeCount;
    }
  }

  _goToUserProfile(BuildContext context, Post post) {
    CustomNavigation.navigateToUserProfile(
        context: context,
        currentUserId: widget.currentUserId,
        userId: post.authorId,
        isCameFromBottomNavigation: false);
  }

  _initPostLiked() async {
    // bool isLiked = await DatabaseService.didLikePost(
    //     currentUserId: widget.currentUserId, post: _post);
    bool isLiked = await SQLDatabase.isliking(widget.currentUserId, _post.id);
    if (mounted) {
      setState(() {
        _isLiked = isLiked;
      });
    }
  }

  _likePost() async {
    if (_isLiked) {
      setState(() {
        _isLiking = true;
      });
      // Unlike Post
      // DatabaseService.unlikePost(
      //     currentUserId: widget.currentUserId, post: _post);
      await SQLDatabase.unlikepost(_post, widget.currentUserId);
      setState(() {
        _isLiked = false;
        _likeCount--;
        _isLiking = false;
      });
    } else {
      setState(() {
        _isLiking = true;
      });
      // Like Post
      // DatabaseService.likePost(
      //     currentUserId: widget.currentUserId,
      //     post: _post,
      //     receiverToken: widget.author.token);
      await SQLDatabase.likepost(_post, widget.currentUserId, widget.author.token);
      setState(() {
        _heartAnim = true;
        _isLiked = true;
        _likeCount++;
        _isLiking = false;
      });
      Timer(Duration(milliseconds: 350), () {
        setState(() {
          _heartAnim = false;
        });
      });
    }
  }

  _goToHomeScreen(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
          builder: (_) => HomeScreen(
                currentUserId: widget.currentUserId,
              )),
      (Route<dynamic> route) => false,
    );
  }

  _showMenuDialog() {
    return Platform.isIOS ? _iosBottomSheet() : _androidDialog();
  }

  // _saveAndShareFile() async {
  //   final RenderBox box = context.findRenderObject();

  //   if (_post.isphoto == true) {
  //     var response = await get(widget.post.imageUrl);
  //     final documentDirectory = (await getExternalStorageDirectory()).path;
  //     File imgFile = new File('$documentDirectory/${widget.post.id}.png');
  //     imgFile.writeAsBytesSync(response.bodyBytes);

  //     Share.shareFiles([imgFile.path],
  //         subject: 'Have a look at ${widget.author.name} post!',
  //         text: '${widget.author.name} : ${widget.post.caption}',
  //         sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  //   } else {
  //     var response = await get(widget.post.imageUrl);
  //     final documentDirectory = (await getExternalStorageDirectory()).path;
  //     File imgFile = new File('$documentDirectory/${widget.post.id}.mp4');
  //     imgFile.writeAsBytesSync(response.bodyBytes);

  //     Share.shareFiles([imgFile.path],
  //         subject: 'Have a look at ${widget.author.name} post!',
  //         text: '${widget.author.name} : ${widget.post.caption}',
  //         sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  //   }
  // }

  _iosBottomSheet() {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return CupertinoActionSheet(
            title: Text('Add Photo'),
            actions: <Widget>[
              CupertinoActionSheetAction(
                onPressed: () {},
                child: Text('Take Photo'),
              ),
              CupertinoActionSheetAction(
                onPressed: () {},
                child: Text('Choose From Gallery'),
              )
            ],
            cancelButton: CupertinoActionSheetAction(
              child: Text(
                'Cancel',
                style: kFontColorRedTextStyle,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          );
        });
  }

  _androidDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            // title: Text('Add Photo'),
            children: <Widget>[
              // SimpleDialogOption(
              //   child: Text('Share Post'),
              //   onPressed: () {
              //     _saveAndShareFile();
              //     Navigator.pop(context);
              //   },
              // ),
              _post.authorId == widget.currentUserId &&
                      widget.postStatus != PostStatus.archivedPost
                  ? SimpleDialogOption(
                      child: Text('Archive Post'),
                      onPressed: () {
                        // DatabaseService.archivePost(
                        //     widget.post, widget.postStatus);
                        _goToHomeScreen(context);
                      },
                    )
                  : SizedBox.shrink(),
              _post.authorId == widget.currentUserId &&
                      widget.postStatus != PostStatus.deletedPost
                  ? SimpleDialogOption(
                      child: Text('Delete Post'),
                      onPressed: () {
                        // DatabaseService.deletePost(_post, widget.postStatus);
                        _goToHomeScreen(context);
                      },
                    )
                  : SizedBox.shrink(),
              _post.authorId == widget.currentUserId &&
                      widget.postStatus == PostStatus.deletedPost
                  ? SimpleDialogOption(
                      child: Text('Permanent Delete Post'),
                      onPressed: () {
                        // DatabaseService.permanentdeletepost(_post);
                        _goToHomeScreen(context);
                      },
                    )
                  : SizedBox.shrink(),
              _post.authorId == widget.currentUserId &&
                      widget.postStatus != PostStatus.feedPost
                  ? SimpleDialogOption(
                      child: Text('Show on profile'),
                      onPressed: () {
                        // DatabaseService.recreatePost(_post, widget.postStatus);
                        _goToHomeScreen(context);
                      },
                    )
                  : SizedBox.shrink(),

              _post.authorId == widget.currentUserId
                  ? SimpleDialogOption(
                      child: Text('Edit Post'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CreatePostScreen(
                              post: _post,
                              postStatus: widget.postStatus,
                            ),
                          ),
                        );
                      },
                    )
                  : SizedBox.shrink(),
              _post.authorId == widget.currentUserId &&
                      widget.postStatus == PostStatus.feedPost
                  ? SimpleDialogOption(
                      child: Text(_post.commentsAllowed
                          ? 'Turn off commenting'
                          : 'Allow comments'),
                      onPressed: () {
                        // DatabaseService.allowDisAllowPostComments(
                        //     _post, !_post.commentsAllowed);
                        Navigator.pop(context);
                        setState(() {
                          _post = new Post(
                              authorId: widget.post.authorId,
                              caption: widget.post.caption,
                              commentsAllowed: !_post.commentsAllowed,
                              id: _post.id,
                              imageUrl: _post.imageUrl,
                              location: _post.location,
                              timestamp: _post.timestamp);
                        });
                      },
                    )
                  : SizedBox.shrink(),
              // SimpleDialogOption(
              //   child: Text('Download Image'),
              //   onPressed: () async {
              //     await ImageDownloader.downloadImage(
              //       _post.imageUrl,
              //       outputMimeType: "image/jpg",
              //     );
              //     Navigator.pop(context);
              //   },
              // ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          child: ListTile(
            leading: GestureDetector(
              onTap: () => _goToUserProfile(context, _post),
              child: CircleAvatar(
                backgroundColor: Colors.grey,
                backgroundImage: widget.author.profileImageUrl.isEmpty
                    ? AssetImage(placeHolderImageRef)
                    : CachedNetworkImageProvider(
                        widget.author.profileImageUrl,
                      ),
              ),
            ),
            title: GestureDetector(
              onTap: () => _goToUserProfile(context, _post),
              child: Row(
                children: [
                  Text(
                    widget.author.name,
                    style: kFontSize18FontWeight600TextStyle,
                  ),
                  UserBadges(user: widget.author, size: 15)
                ],
              ),
            ),
            subtitle: _post.location.isNotEmpty ? Text(_post.location) : null,
            trailing: IconButton(
                icon: Icon(Icons.more_vert), onPressed: _showMenuDialog),
          ),
        ),
        GestureDetector(
          onDoubleTap:
              widget.postStatus == PostStatus.feedPost ? _likePost : () {},
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height * 0.45,
                width: MediaQuery.of(context).size.width,
                child: _post.isphoto != false
                    ? ZoomOverlay(
                        twoTouchOnly: true,
                        child: //Image.network(_post.imageUrl),
                            CachedNetworkImage(
                                fadeInDuration: Duration(milliseconds: 500),
                                imageUrl: _post.imageUrl),
                      )
                    : VisibilityDetector(
                        key: ObjectKey(flickManager),
                        onVisibilityChanged: (visiblityInfo) {
                          if (visiblityInfo.visibleFraction == 1) {
                            flickMultiManager.play(flickManager);
                          }
                          if (visiblityInfo.visibleFraction < 0.1 &&
                              this.mounted) {
                            flickMultiManager.pause();
                          }
                          if (visiblityInfo.visibleFraction == 0) {
                            flickMultiManager.pause();
                          }
                        },
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.45,
                          width: MediaQuery.of(context).size.width,
                          child: FlickVideoPlayer(
                            flickManager: flickManager,
                            flickVideoWithControls: FlickVideoWithControls(
                              playerLoadingFallback: Center(
                                  child: CircularProgressIndicator(
                                color: ThemeData().accentColor,
                                backgroundColor: ThemeData().backgroundColor,
                              )),
                              videoFit: BoxFit.contain,
                              controls: FeedPlayerPortraitControls(
                                flickMultiManager: flickMultiManager,
                                flickManager: flickManager,
                              ),
                            ),
                            flickVideoWithControlsFullscreen:
                                FlickVideoWithControls(
                              playerLoadingFallback:
                                  CircularProgressIndicator(),
                              controls: FlickLandscapeControls(),
                              iconThemeData: IconThemeData(
                                size: 40,
                                color: Colors.white,
                              ),
                              textStyle:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                // Stack(children: [
                //     Center(
                //       child: AspectRatio(
                //         aspectRatio: _controller.value.aspectRatio,
                //         child: VideoPlayer(_controller),
                //       ),
                //     ),
                //     Align(
                //       alignment: Alignment.bottomRight,
                //       child: IconButton(
                //           onPressed: () {
                //             if (_controller.value.volume == 1) {
                //               _controller.setVolume(0);
                //             } else {
                //               _controller.setVolume(1);
                //             }
                //           },
                //           icon: _controller.value.volume == 1
                //               ? Icon(Icons.volume_off_rounded)
                //               : Icon(Icons.volume_up_rounded)),
                //     ),
                //     Align(
                //         alignment: Alignment.center,
                //         child: IconButton(
                //           onPressed: () {
                //             // if (_controller.value.isPlaying) {
                //             //   _controller.pause();
                //             // } else {
                //             //   _initializevideo();
                //             //   _controller.play();
                //             // }
                //           },
                //           icon: Icon(
                //             _controller.value.isPlaying
                //                 ? Icons.pause
                //                 : Icons.play_arrow,
                //             size: 60,
                //           ),
                //         ))
                //   ]
                //   )
              ),
              _heartAnim ? HeartAnime(100.0) : SizedBox.shrink(),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: [
                      IconButton(
                        icon: _isLiking
                            ? SpinKitRipple(color: Colors.red)
                            : _isLiked
                                ? Icon(
                                    Ionicons.heart_sharp,
                                    size: 36,
                                    color: Colors.red,
                                  )
                                : Icon(Ionicons.heart_outline, size: 36),
                        iconSize: 30.0,
                        onPressed: widget.postStatus == PostStatus.feedPost
                            ? _likePost
                            : () {},
                      ),
                      IconButton(
                        icon: Icon(Ionicons.chatbubble_ellipses_outline),
                        iconSize: 28.0,
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CommentsScreen(
                              postStatus: widget.postStatus,
                              post: _post,
                              likeCount: _likeCount,
                              author: widget.author,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // IconButton(
                  //   icon: _isLiked
                  //       ? FaIcon(
                  //           FontAwesomeIcons.solidHeart,
                  //           color: Colors.red,
                  //         )
                  //       : FaIcon(FontAwesomeIcons.heart),
                  //   iconSize: 30.0,
                  //   onPressed: _likePost,
                  // ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(
                  '${NumberFormat.compact().format(_likeCount)} Likes',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 4.0),
              Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                  child: Text(
                    _post.caption,
                    style: TextStyle(fontSize: 16.0),
                  )
                  // RichText(
                  //     text: TextSpan(
                  //   text: widget.author.name,
                  //   style: TextStyle(fontWeight: FontWeight.bold),
                  //   children: <TextSpan>[
                  //     TextSpan(
                  //       text: '${_post.caption}'
                  //     ),
                  //   ],
                  // )),
                  ),
              // Row(
              //   children: <Widget>[
              //     Container(
              //       margin: const EdgeInsets.only(
              //         left: 12.0,
              //         right: 6.0,
              //       ),
              //       child: GestureDetector(
              //         onTap: () => _goToUserProfile(context, _post),
              //         child: Row(
              //           children: [
              //             Text(
              //               widget.author.name,
              //               style: TextStyle(
              //                   fontSize: 16.0, fontWeight: FontWeight.bold),
              //             ),
              //             UserBadges(
              //                 user: widget.author,
              //                 size: 15,
              //                 secondSizedBox: false)
              //           ],
              //         ),
              //       ),
              //     ),
              //     Expanded(
              //         child: Text(
              //       _post.caption,
              //       style: TextStyle(fontSize: 16.0),
              //       overflow: TextOverflow.ellipsis,
              //     )),
              //   ],
              // ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                child: Text(
                  timeago.format(_post.timestamp),
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12.0,
                  ),
                ),
              ),
              SizedBox(height: 12.0),
            ],
          ),
        )
      ],
    );
  }
}
