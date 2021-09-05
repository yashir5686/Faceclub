import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:instagrampub/common_widgets/post_view.dart';
import 'package:instagrampub/common_widgets/userTile.dart';
import 'package:instagrampub/models/User.dart';
import 'package:instagrampub/models/post.dart';
import 'package:instagrampub/services/api/sqldatabase.dart';
import 'package:instagrampub/utilities/custom_navigation.dart';
import 'package:instagrampub/utilities/themes.dart';
import 'package:instagrampub/common_widgets/user_badges.dart';
import 'package:provider/provider.dart';

import 'package:instagrampub/models/models.dart';
import 'package:instagrampub/screens/screens.dart';
import 'package:instagrampub/utilities/constants.dart';

class SearchScreen extends StatefulWidget {
  final SearchFrom searchFrom;
  final File imageFile;
  final String currentUserId;
  SearchScreen({@required this.searchFrom, this.imageFile, this.currentUserId});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchController = TextEditingController();
  //Future<QuerySnapshot> _users;
  String _searchText = '';
  List<User> _userslist = [];
  bool isLoadingUsers = false;
  List<GridTile> tiles = [];

  @override
  void initState() {
    super.initState();
    //_searchText = '';
    //isLoadingUsers = false;
    if (_searchText.isNotEmpty) {
      _setupUsers();
    }
  }

  _setupUsers() async {
    setState(() {
      isLoadingUsers = true;
    });
    if (_searchText != null) {
      String userssdata = await SQLDatabase.searchuser(_searchText);
      List<User> users = userListFromJson(userssdata);
      setState(() {
        _userslist = users;
        isLoadingUsers = false;
      });
    }
  }

  Widget _buildSearchedUsersTiles() {
    // Column
    List<UserTile> usertiles = [];
    _userslist.forEach((eachuser) {
      usertiles.add(eachuser.id == widget.currentUserId
          ? SizedBox.shrink()
          : UserTile(
              currentUserId: widget.currentUserId,
              user: eachuser,
              searchFrom: widget.searchFrom,
              imageFile: widget.imageFile,
            ));
    });
    return Column(
      children: usertiles,
    );
  }

  ListTile _buildUserTile(User user) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.grey,
        radius: 20.0,
        backgroundImage: user.profileImageUrl.isEmpty
            ? AssetImage(placeHolderImageRef)
            : CachedNetworkImageProvider(user.profileImageUrl),
      ),
      title: Row(
        children: [Text(user.name), UserBadges(user: user, size: 15)],
      ),
      trailing: widget.searchFrom == SearchFrom.createStoryScreen
          ? FlatButton(
              child: Text(
                'Send',
                style: kFontSize18TextStyle.copyWith(color: Colors.white),
              ),
              color: Colors.blue,
              onPressed: null,
              // () => {
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //       builder: (_) => ChatScreen(
              //         receiverUser: user,
              //         imageFile: widget.imageFile,
              //       ),
              //     ),
              //   ),
              // },
            )
          : SizedBox.shrink(),
      onTap: widget.searchFrom == SearchFrom.homeScreen
          ? () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProfileScreen(
                    goToCameraScreen: () =>
                        CustomNavigation.navigateToHomeScreen(
                            context,
                            Provider.of<UserData>(context, listen: false)
                                .currentUserId,
                            initialPage: 0),
                    isCameFromBottomNavigation: false,
                    userId: user.id,
                    currentUserId: Provider.of<UserData>(context, listen: false)
                        .currentUserId,
                  ),
                ),
              )
          : widget.searchFrom == SearchFrom.messagesScreen
              ? null
              // () => Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //         builder: (_) => ChatScreen(
              //           receiverUser: user,
              //           imageFile: widget.imageFile,
              //         ),
              //       ),
              //     )
              : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    String _currentUserId = Provider.of<UserData>(context).currentUserId;
    void _clearSearch() {
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _searchController.clear());
      setState(() {
        //_users = null;
        _searchText = '';
      });
    }

    return Scaffold(
        appBar: AppBar(
          title: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
              border: InputBorder.none,
              hintText: 'Search for a user...',
              prefixIcon: Icon(
                Icons.search,
                color: Theme.of(context).accentColor.withOpacity(0.6),
                size: 30.0,
              ),
              suffixIcon: _searchText.trim().isEmpty
                  ? null
                  : IconButton(
                      color: Theme.of(context).accentColor.withOpacity(0.6),
                      icon: Icon(Icons.clear),
                      onPressed: _clearSearch,
                    ),
              // filled: true,
            ),
            onChanged: (value) {
              setState(() {
                _searchText = value;
              });
              //_setupUsers();
            },
            onSubmitted: (input) {
              if (input.trim().isNotEmpty) {
                _setupUsers();
              }
            },
          ),
        ),
        body: isLoadingUsers == true
            ? Center(
                child: CircularProgressIndicator(), //Text('Search for a user'),
              )
            : _searchText.isNotEmpty
                ? Column(
                    children: [_buildSearchedUsersTiles()],
                  )
                : SearchFeed(widget.currentUserId)
        // FutureBuilder(
        //   future: _setupUsers(),
        //   builder: (context, snapshot) {
        //     if (!snapshot.hasData) {
        //       return Center(
        //         child: CircularProgressIndicator(),
        //       );
        //     }
        //     if (snapshot.data.documents.length == 0) {
        //       return Center(
        //         child: Text('No Users found! Please try again.'),
        //       );
        //     }
        //     return ListView.builder(
        //         itemCount: snapshot.data.documents.length,
        //         itemBuilder: (BuildContext context, int index) {
        //           User user = User.fromJson(snapshot.data.documents[index]);
        //           // Prevent current user to send messages to himself
        //           return (widget.searchFrom != SearchFrom.homeScreen &&
        //               user.id == _currentUserId)
        //               ? SizedBox.shrink()
        //               : _buildSearchedUsersTiles(user);
        //         });
        //   },
        // ),
        );
  }
}

class SearchFeed extends StatefulWidget {
  final String currentuserid;
  const SearchFeed(this.currentuserid);

  @override
  _SearchFeedState createState() => _SearchFeedState();
}

class _SearchFeedState extends State<SearchFeed> {
  bool _isLoadingFeed = false;
  List<Post> _posts = [];
  List tiles = [];

  @override
  void initState() {
    super.initState();
    _setupFeed();
  }

  _setupFeed() async {
    setState(() => _isLoadingFeed = true);

    String postsdata = await SQLDatabase.getexploreposts(widget.currentuserid);
    List<Post> posts = postFromJson(postsdata);
    setState(() {
      _posts = posts;
      _isLoadingFeed = false;
    });
    print(posts);
  }

  GridTile _buildTilePost(Post post, User authorUser) {
    return GridTile(
        child: GestureDetector(
      onTap: () => Navigator.push(
        context,
        //MaterialPageRoute(builder: (Buildcontext) => PostPage(post, authorUser, widget.currentuserid))
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
                          currentUserId: widget.currentuserid,
                          post: post,
                          author: authorUser,
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

  Widget buildRandomPosts() {
    return Container(
      child: Column(
        children: [
          ListView.builder(itemBuilder: (context, index) {
            if (_posts.length == 0) {
              //If there is no posts
              return Container(
                height: MediaQuery.of(context).size.height,
                child: Center(
                  child: Text('No Posts Found!!'),
                ),
              );
            }
            Post post = _posts[index];
            return FutureBuilder(
              future: SQLDatabase.getUserbyId(post.authorId),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return SizedBox.shrink();
                }

                User author = userFromJson(snapshot.data);

                return PostView(
                  postStatus: PostStatus.feedPost,
                  currentUserId: widget.currentuserid,
                  post: post,
                  author: author,
                );
              },
            );
          }),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: !_isLoadingFeed
          ? RefreshIndicator(
              // If posts finished loading
              onRefresh: () => _setupFeed(),
              child: GridView.builder(
                  itemCount: _posts.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1.0,
                    mainAxisSpacing: 2.0,
                    crossAxisSpacing: 2.0,
                  ),
                  itemBuilder: (context, index) {
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
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (!snapshot.hasData) {
                          return SizedBox.shrink();
                        }

                        User author = userFromJson(snapshot.data);

                        return _buildTilePost(post, author);
                      },
                    );
                  }))
          : Center(child: SpinKitPouringHourGlassRefined(color: Colors.blue)),
    );
  }
}
