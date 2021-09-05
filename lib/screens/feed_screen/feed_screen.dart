import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:instagrampub/models/User.dart';
import 'package:instagrampub/models/post.dart';
import 'package:instagrampub/services/api/sqldatabase.dart';
import 'package:instagrampub/utilities/constants.dart';
import 'package:instagrampub/common_widgets/post_view.dart';
import 'package:ionicons/ionicons.dart';
class FeedScreen extends StatefulWidget {
  static final String id = 'feed_screen';
  final String currentUserId;
  final Function goToDirectMessages;
  final Function goToCameraScreen;

  FeedScreen(
      {this.currentUserId, this.goToDirectMessages, this.goToCameraScreen});
  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  List<Post> _posts = [];
  bool _isLoadingFeed = false;
  bool _isLoadingStories = false;
  List<User> _followingUsersWithStories = [];
  bool showbadge = false;
  // String postId;
  // String userId;
  // String profileId;

  @override
  void initState() {
    super.initState();
    getUser();
    _setupFeed();
    //SQLDatabase.updateTokenwithUser(widget.currentUserId);
    //this._initDynamicLinks();
  }

  getUser() {
    setState(() {
      _isLoadingFeed = true;
    });

    try {
      SQLDatabase.getUserbyId(widget.currentUserId);
      setState(() {
        _isLoadingFeed = false;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  // void _initDynamicLinks() async {
  //   FirebaseDynamicLinks.instance.onLink(
  //       onSuccess: (PendingDynamicLinkData dynamicLink) async {
  //     final Uri deepLink = dynamicLink?.link;

  //     if (deepLink != null) {
  //       var isPost = deepLink.pathSegments.contains('post');
  //       var isprofile = deepLink.pathSegments.contains('profile');
  //       print('${deepLink}');
  //       if (isPost) {
  //         postId = deepLink.queryParameters['postId'];
  //         userId = deepLink.queryParameters['uid'];
  //         if (postId != null)
  //           Navigator.pushNamed(context, '/post',
  //               arguments: ScreenArguments(postId, widget.currentUserId));
  //       }
  //       if (isprofile) {
  //         profileId = deepLink.queryParameters['profileId'];
  //         if (profileId != null)
  //           Navigator.pushNamed(context, '/profile',
  //               arguments: ProfileArguments(profileId, widget.currentUserId));
  //       }
  //     }
  //   }, onError: (OnLinkErrorException e) async {
  //     showDialog(
  //         context: context,
  //         builder: (BuildContext context) {
  //           return AlertDialog(
  //             title: Text('Link Is Not Valid'),
  //           );
  //         });
  //   });

  //   final PendingDynamicLinkData data =
  //       await FirebaseDynamicLinks.instance.getInitialLink();
  //   final Uri deepLink = data?.link;

  //   if (deepLink != null) {
  //     Navigator.pushNamed(context, '/post');
  //   }
  // }

  _setupFeed() async {
    //_setupStories();

    setState(() => _isLoadingFeed = true);

    // String usersdata = await SQLDatabase.getuserfollowings(widget.currentUserId);
    // List<User> users = userListFromJson(usersdata);
    // print(usersdata);

    String postsdata = await SQLDatabase.getfeedposts(widget.currentUserId);
    List<Post> posts = postFromJson(postsdata);
    setState(() {
      _posts = posts;
      _isLoadingFeed = false;
    });
    print(posts);

    // users.forEach((user) async {
    //   String postsdata = await SQLDatabase.getuserposts(user.id);
    //   List<Post> posts = postFromJson(postsdata);
    //   print(posts.toString());
    //   _posts.addAll(posts);
    // });

    // List<Post> posts = await DatabaseService.getAllFeedPosts();
  }

  // void _setupStories() async {
  //   setState(() => _isLoadingStories = true);
  //
  //   // Get currentUser followingUsers
  //   // List<User> followingUsers =
  //   //     await DatabaseService.getUserFollowingUsers(widget.currentUserId);
  //
  //   if (!mounted) return;
  //   User currentUser =
  //       Provider.of<UserData>(context, listen: false).currentUser;
  //
  //   // List<Story> currentUserStories =
  //   //     await StoriesService.getStoriesByUserId(currentUser.id, true);
  //
  //   // Add current user to the first story circle
  //   // followingUsers.insert(0, currentUser);
  //
  //   // if (currentUserStories != null) {
  //   // }
  //
  //   /* A method to add Admin stories to each user */
  //   if (currentUser.id != kAdminUId) {
  //     bool isFollowingAdmin = false;
  //
  //     // for (User user in followingUsers) {
  //     //   if (user.id == kAdminUId) {
  //     //     isFollowingAdmin = true;
  //     //   }
  //     // }
  //     // if current user doesn't follow admin
  //     if (!isFollowingAdmin) {
  //       // get admin stories
  //       List<Story> adminStories =
  //           await StoriesService.getStoriesByUserId(kAdminUId, true);
  //       if (!mounted) return;
  //       // if there is admin stories
  //       if (adminStories != null && adminStories.isNotEmpty) {
  //         // get admin user
  //         User adminUser = await SQLDatabase.getUserbyId(kAdminUId);
  //         if (!mounted) return;
  //         // add admin to story circle list
  //         //followingUsers.insert(0, adminUser);
  //       }
  //     }
  //   }
  //   /* End of method to add Admin stories to each user */
  //
  //   if (mounted) {
  //     setState(() {
  //       _isLoadingStories = false;
  //       //_followingUsersWithStories = followingUsers;
  //     });
  //   }
  // }

  Widget _buildDisplayPosts(User author) {
    // Column
    List<PostView> postViews = [];
    _posts.forEach((post) {
      postViews.add(PostView(
        postStatus: PostStatus.feedPost,
        currentUserId: widget.currentUserId,
        post: post,
        author: author,
      ));
    });
    return Column(
      children: postViews,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.color,
        centerTitle: true,
        title: Text(
          'Faceclub',
          // style: TextStyle(
          //   fontFamily: 'Billabong',
          //   fontSize: 40,
          // )
        ),
        actions: [
          Badge(
            animationType: BadgeAnimationType.fade,
            shape: BadgeShape.circle,
            toAnimate: true,
            badgeColor: Colors.red,
            showBadge: showbadge,
            child: IconButton(
                icon: Icon(Ionicons.chatbubbles_sharp),
                onPressed: widget.goToDirectMessages),
          ),
        ],
      ),
      body: !_isLoadingFeed
          ? RefreshIndicator(
              // If posts finished loading
              onRefresh: () => _setupFeed(),
              child: SingleChildScrollView(
                physics: ScrollPhysics(),
                child: Column(
                  children: [
                    // _isLoadingStories
                    //     ? Container(
                    //         height: 88,
                    //         child: Center(
                    //           child: Text('No Stories Found'),
                    //         ),
                    //       )
                    //     : StoriesWidget(_followingUsersWithStories,
                    //         widget.goToCameraScreen),
                    SizedBox(height: 5),
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: _posts.length > 0 ? _posts.length : 1,
                      itemBuilder: (BuildContext context, int index) {
                        if (_posts.length == 0) {
                          //If there is no posts
                          return Container(
                            height: MediaQuery.of(context).size.height,
                            child: Center(
                              child: Text('No Posts Found,Follow some users'),
                            ),
                          );
                        }

                        Post post = _posts[index];

                        return FutureBuilder(
                          future: SQLDatabase.getUserbyId(post.authorId),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (!snapshot.hasData) {
                              return SizedBox.shrink();
                            }

                            User author = userFromJson(snapshot.data);

                            return PostView(
                              postStatus: PostStatus.feedPost,
                              currentUserId: widget.currentUserId,
                              author: author,
                              post: post,
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            )
          : Center(child: SpinKitPouringHourGlassRefined(color: Colors.blue)),
    );
  }
}
