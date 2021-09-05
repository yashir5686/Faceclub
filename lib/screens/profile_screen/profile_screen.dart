
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:instagrampub/common_widgets/post_view.dart';
import 'package:instagrampub/common_widgets/user_badges.dart';
import 'package:instagrampub/models/User.dart';
import 'package:instagrampub/models/post.dart';
import 'package:instagrampub/models/story_model.dart';
import 'package:instagrampub/models/user_data.dart';
import 'package:instagrampub/screens/direct_messages/nested_screens/chat_screen.dart';
import 'package:instagrampub/screens/profile_screen/nested_screens/edit_profile_screen.dart';
import 'package:instagrampub/screens/profile_screen/nested_screens/followers_screen.dart';
import 'package:instagrampub/screens/profile_screen/widgets/profile_screen_drawer.dart';
import 'package:instagrampub/services/api/auth_service.dart';
import 'package:instagrampub/services/api/sqldatabase.dart';
import 'package:instagrampub/services/api/stories_service.dart';
import 'package:instagrampub/utilities/constants.dart';
import 'package:instagrampub/utilities/show_error_dialog.dart';
import 'package:instagrampub/utilities/themes.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

class ProfileScreen extends StatefulWidget {
  final String userId;
  final String currentUserId;
  final Function onProfileEdited;
  final bool isCameFromBottomNavigation;
  final Function goToCameraScreen;

  ProfileScreen({
    this.userId,
    this.currentUserId,
    this.onProfileEdited,
    @required this.goToCameraScreen,
    @required this.isCameFromBottomNavigation,
  });

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isFollowing = false;
  int _followersCount = 0;
  int _followingCount = 0;
  List<Post> _posts = [];
  User _profileUser;
  //List<Story> _userStories = null;
  VideoPlayerController _controller;
  // ignore: non_constant_identifier_names
  String VideoUrl;
  int postcount;
  Map mapresponse;
  int _displayPosts = 0; // 0 - grid, 1 - column
  bool _isLoading = false;
  bool _following = false;

  @override
  initState() {
    super.initState();
    //_setupUserStories();
    _isLoading = true;
    _setupIsFollowing();
    _setupProfileUser();
    _setupFollowers();
    _setupPostCount();
    _setupFollowing();
    _setupPosts();
    _initializevideo();
    print(widget.userId);
    print(widget.currentUserId);
    _isLoading = false;
  }

  @override
  void dispose() {
    super.dispose();
    _initializevideo();
    _controller.dispose();
  }

  _initializevideo() {
    _controller = VideoPlayerController.network(VideoUrl)
      ..setLooping(true)
      ..initialize().then((_) {
        // _controller.setVolume(0);
        _controller.play();
      });
  }

  _setupIsFollowing() async {
    bool isFollowingUser = await SQLDatabase.isfollowing(widget.currentUserId, widget.userId);
    if (!mounted) return;
    setState(() {
      _isFollowing = isFollowingUser;
    });
  }

  _setupPostCount() async {
    String posts = await SQLDatabase.countposts(widget.userId);
    print(int.parse(posts));
    postcount = int.parse(posts);
  }

  _setupFollowers() async {
    String followers = await SQLDatabase.countFollowers(widget.userId);
    _followersCount = int.parse(followers);
  }

  _setupFollowing() async {
    String followings = await SQLDatabase.countFollowings(widget.userId);
    _followingCount = int.parse(followings);
  }

  _setupPosts() async {
    String postsdata = await SQLDatabase.getuserposts(widget.userId);
    List<Post> posts = postFromJson(postsdata);
    _posts = posts;
  }

  _setupProfileUser() async {
    String data = await SQLDatabase.getUserbyId(widget.userId);
    User currentuser = userFromJson(data);
    setState(() {
      _profileUser = currentuser;
    });
  }

  // _setupUserStories() async {
  //   List<Story> userStories =
  //       await StoriesService.getStoriesByUserId(widget.userId, true);
  //   if (!mounted) return;

  //   if (userStories != null) {
  //     setState(() {
  //       _userStories = userStories;
  //     });
  //   }
  // }

  _followOrUnfollow() {
    if (_isFollowing) {
      _unfollowUser();
    } else {
      _followUser();
    }
  }

  void _unfollowUser() async {
    setState(() {
      _following = true;
    });
    await SQLDatabase.Unfollowuser(
      currentUserId: widget.currentUserId,
      userId: widget.userId,
    );
    if (!mounted) return;
    setState(() {
      _isFollowing = false;
      _followersCount--;
      _following = false;
    });
  }

  void _followUser() async {
    setState(() {
      _following = true;
    });
    await SQLDatabase.followuser(
      currentUserId: widget.currentUserId,
      userId: widget.userId,
      receiverToken: _profileUser.token,
    );
    if (!mounted) return;
    setState(() {
      _isFollowing = true;
      _followersCount++;
      _following = false;
    });
  }

  Widget _displayButton(User user) {
    return user.id == widget.currentUserId
        ? Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 8, right: 10, left: 10),
          child: Container(
              //width: double.infinity,
              // ignore: deprecated_member_use
              child: FlatButton(
                  onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditProfileScreen(
                              user: user,
                              updateUser: (User updateUser) {
                                User updatedUser = User(
                                  id: updateUser.id,
                                  name: updateUser.name,
                                  displayname: updateUser.displayname,
                                  email: user.email,
                                  profileImageUrl: updateUser.profileImageUrl,
                                  bio: updateUser.bio,
                                  isVerified: updateUser.isVerified,
                                  role: updateUser.role,
                                  website: updateUser.website,
                                );

                                setState(() {
                                  Provider.of<UserData>(context, listen: false)
                                      .currentUser = updatedUser;
                                  _profileUser = updatedUser;
                                });
                                //AuthService.updateTokenWithUser(updatedUser);
                                widget.onProfileEdited();
                              },
                              onProfileEdited: widget.onProfileEdited,
                              goToCameraScreen: widget.goToCameraScreen,
                              ),
                        ),
                      ),
                  color: Colors.blue,
                  textColor: Colors.white,
                  child: Text(
                    'Edit Profile',
                    style: kFontSize18TextStyle,
                  )),
            ),
        )
        : Row(
            children: <Widget>[
              Expanded(
                // ignore: deprecated_member_use
                child: _following == true ? SpinKitThreeBounce(color: Colors.grey) :
                FlatButton(
                  onPressed: _followOrUnfollow,
                  color: _isFollowing ? Colors.grey[200] : Colors.blue,
                  textColor: _isFollowing ? Colors.black : Colors.white,
                  child: Text(
                    _isFollowing ? 'Unfollow' : 'Follow',
                    style: kFontSize18TextStyle,
                  ),
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Expanded(
                // ignore: deprecated_member_use
                child: FlatButton(
                  onPressed: null,
                  // () => Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (_) => ChatScreen(
                  //               receiverUser: _profileUser,
                  //             ))),
                  color: Colors.blue,
                  textColor: Colors.white,
                  child: Text(
                    'Message',
                    style: kFontSize18TextStyle,
                  ),
                ),
              ),
            ],
          );
  }

  Column _buildProfileInfo(User user) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 0),
          child: Row(
            children: <Widget>[
              // Container(
              //   width: 110,
              //   height: 110,
              //   child: _userStories == null
              //       ? BlankStoryCircle(
              //           user: user,
              //           goToCameraScreen: widget.goToCameraScreen,
              //           size: 90,
              //           showUserName: false,
              //         )
              //       : StoryCircle(
              //           userStories: _userStories,
              //           user: _profileUser,
              //           currentUserId: widget.currentUserId,
              //           showUserName: false,
              //           size: 90,
              //         ),
              // ),
              Expanded(
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Text(
                              NumberFormat.compact().format(postcount),
                              style: kFontSize18FontWeight600TextStyle,
                            ),
                            Text(
                              'posts',
                              style: kHintColorStyle(context),
                            )
                          ],
                        ),
                        GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => FollowersScreen(
                                currenUserId: widget.currentUserId,
                                user: user,
                                followersCount: _followersCount,
                                followingCount: _followingCount,
                                selectedTab: 0,
                                updateFollowersCount: (count) {
                                  setState(() => _followersCount = count);
                                },
                                updateFollowingCount: (count) {
                                  setState(() => _followingCount = count);
                                },
                              ),
                            ),
                          ),
                          child: Column(
                            children: <Widget>[
                              Text(
                                NumberFormat.compact().format(_followersCount),
                                style: kFontSize18FontWeight600TextStyle,
                              ),
                              Text(
                                'followers',
                                style: kHintColorStyle(context),
                              )
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => FollowersScreen(
                                currenUserId: widget.currentUserId,
                                user: user,
                                followersCount: _followersCount,
                                followingCount: _followingCount,
                                selectedTab: 1,
                                updateFollowersCount: (count) {
                                  setState(() => _followersCount = count);
                                },
                                updateFollowingCount: (count) {
                                  setState(() => _followingCount = count);
                                },
                              ),
                            ),
                          ),
                          child: Column(
                            children: <Widget>[
                              Text(
                                NumberFormat.compact().format(_followingCount),
                                style: kFontSize18FontWeight600TextStyle,
                              ),
                              Text(
                                'following',
                                style: kHintColorStyle(context),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              user.displayname != null
                  ? Text(
                      user.displayname,
                      style: kFontSize18FontWeight600TextStyle.copyWith(
                          fontWeight: FontWeight.bold),
                    )
                  : SizedBox.shrink(),
              if (user.website != '') SizedBox(height: 5.0),
              if (user.website != '')
                GestureDetector(
                  onTap: () => _goToUrl(user.website),
                  child: Container(
                    height: 18,
                    //width: double.infinity,
                    child: Text(
                      user.website
                          .replaceAll('https://', '')
                          .replaceAll('http://', '')
                          .replaceAll('www.', ''),
                      style: kBlueColorTextStyle,
                    ),
                  ),
                ),
              SizedBox(height: 5.0),
              Container(
                child: Text(
                  user.bio,
                  style: TextStyle(fontSize: 15.0),
                ),
              ),
              SizedBox(height: 5.0),
              _displayButton(user),
            ],
          ),
        )
      ],
    );
  }

  void _goToUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: true,
        forceWebView: true,
        enableJavaScript: true,
      );
    } else {
      ShowErrorDialog.showAlertDialog(
          errorMessage: 'Could not launch $url', context: context);
    }
  }

  Row _buildToggleButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.grid_on),
          iconSize: 30.0,
          color: _displayPosts == 0
              ? Theme.of(context).accentColor
              : Theme.of(context).hintColor,
          onPressed: () => setState(() {
            _displayPosts = 0;
          }),
        ),
        IconButton(
          icon: Icon(Icons.list),
          iconSize: 30.0,
          color: _displayPosts == 1
              ? Theme.of(context).accentColor
              : Theme.of(context).hintColor,
          onPressed: () => setState(() {
            _displayPosts = 1;
          }),
        )
      ],
    );
  }

  GridTile _buildTilePost(Post post) {
    return GridTile(
        child: GestureDetector(
          onTap: () => Navigator.push(
            context,
            //MaterialPageRoute(builder: (Buildcontext) => PostPage(post, _profileUser, widget.currentUserId))
            MaterialPageRoute<bool>(
              builder: (BuildContext context) {
                return Center(
                  child: Scaffold(
                      appBar: AppBar(
                        title: Text(
                          'Photo',
                        ),
                      ),
                      body: ListView(
                        children: <Widget>[
                          Container(
                            child: PostView(
                              postStatus: PostStatus.feedPost,
                              currentUserId: widget.currentUserId,
                              post: post,
                              author: _profileUser,
                            ),
                          ),
                        ],
                      )),
                );
              },
            ),
          ),
          child: Image(
            image: CachedNetworkImageProvider(post.imageUrl),
            fit: BoxFit.cover,
          ),
        ));
  }

  Widget _buildDisplayPosts() {
    if (_displayPosts == 0) {
      // Grid
      List<GridTile> tiles = [];
      _posts.forEach((post) => tiles.add(_buildTilePost(post)));
      return GridView.count(
        crossAxisCount: 3,
        childAspectRatio: 1.0,
        mainAxisSpacing: 2.0,
        crossAxisSpacing: 2.0,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: tiles,
      );
    } else {
      // Column
      List<PostView> postViews = [];
      _posts.forEach((post) {
        postViews.add(PostView(
          postStatus: PostStatus.feedPost,
          currentUserId: widget.currentUserId,
          post: post,
          author: _profileUser,
        ));
      });
      return Column(
        children: postViews,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.color,
          automaticallyImplyLeading:
              widget.isCameFromBottomNavigation ? false : true,
          title: _profileUser != null
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        child: Text(
                          _profileUser.name,
                          overflow: TextOverflow.clip,
                        ),
                      ),
                      UserBadges(user: _profileUser, size: 20),
                    ],
                  ),
                )
              : SizedBox.shrink(),
        ),
        endDrawer: _profileUser != null && widget.userId == widget.currentUserId
            ? ProfileScreenDrawer(
                user: _profileUser,
                currentuserid: widget.currentUserId,
              )
            : null,
        body: _isLoading ? Center(
          child: SpinKitPouringHourGlassRefined(color: Colors.blueAccent),
        ) :
        FutureBuilder(
            future: SQLDatabase.getUserbyId(widget.userId),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: SpinKitPouringHourGlassRefined(color: Colors.blueAccent),
                );
              }
              User user = userFromJson(snapshot.data);
              _profileUser = user;
              return ListView(
                physics: AlwaysScrollableScrollPhysics(),
                children: <Widget>[
                  _buildProfileInfo(user),
                  _buildToggleButtons(),
                  Divider(color: Theme.of(context).dividerColor),
                  _buildDisplayPosts(),
                ],
              );
            })
    );
  }
}
