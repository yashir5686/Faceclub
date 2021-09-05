
import 'package:flutter/material.dart';
import 'package:instagrampub/common_widgets/post_view.dart';
import 'package:instagrampub/models/User.dart';
import 'package:instagrampub/models/post.dart';
import 'package:instagrampub/services/api/sqldatabase.dart';
import 'package:instagrampub/utilities/constants.dart';

class PostPage extends StatefulWidget {
  final Post Mainpost;
  final User Mainauthor;
  final String currentUserId;
  PostPage(this.Mainpost, this.Mainauthor, this.currentUserId);

  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  List<Post> _posts = [];
  bool _isLoadingFeed = false;

  @override
  void initState() {
    super.initState();
    _setupFeed();
  }

  _setupFeed() async {
    setState(() => _isLoadingFeed = true);

    String postsdata = await SQLDatabase.getexploreposts(widget.currentUserId);
    List<Post> posts = postFromJson(postsdata);
    setState(() {
      _posts = posts;
      _isLoadingFeed = false;
    });
  }

  Widget buildMainpost() {
    return Container(
      child: PostView(
        postStatus: PostStatus.feedPost,
        currentUserId: widget.currentUserId,
        post: widget.Mainpost,
        author: widget.Mainauthor,
      ),
    );
  }

  Widget buildexploreposts(User author) {
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
      body: !_isLoadingFeed
          ? Column(
              children: [
                SizedBox(height: 5),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _posts.length > 0 ? _posts.length : 1,
                  itemBuilder: (BuildContext context, int index) {
                    if (_posts.length == 0) {
                      //If there is no posts
                      return buildMainpost();
                    }

                    Post post = _posts[index];

                    return FutureBuilder(
                      future: SQLDatabase.getUserbyId(post.authorId),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (!snapshot.hasData) {
                          return SizedBox.shrink();
                        }

                        User author = userFromJson(snapshot.data);

                        return Column(
                          children: [
                            buildMainpost(),
                            buildexploreposts(author)
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            )
          : Center(
              // If posts is loading
              child: CircularProgressIndicator(),
            ),
    );
  }
}
