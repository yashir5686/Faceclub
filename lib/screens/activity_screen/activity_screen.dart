import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:instagrampub/common_widgets/user_badges.dart';
import 'package:instagrampub/models/User.dart';
import 'package:instagrampub/models/activity_model.dart';
import 'package:instagrampub/services/api/database_service.dart';
import 'package:instagrampub/services/api/sqldatabase.dart';
import 'package:instagrampub/utilities/constants.dart';
import 'package:instagrampub/utilities/custom_navigation.dart';
import 'package:instagrampub/utilities/themes.dart';
import 'package:timeago/timeago.dart' as timeago;

class ActivityScreen extends StatefulWidget {
  final User currentUser;

  ActivityScreen({this.currentUser});

  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  List<Activity> _activities = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _setupActivities();
  }

  _setupActivities() async {
    setState(() => _isLoading = true);
    // List<Activity> activities =
    //     await DatabaseService.getActivities(widget.currentUser.id);
    String activitiesdata =
        await SQLDatabase.getActivities(widget.currentUser.id);
    List<Activity> activities = ActivityFromJson(activitiesdata);
    print(activitiesdata);

    if (mounted) {
      setState(() {
        _activities = activities;
        _isLoading = false;
      });
    }
  }

  _buildActivity(Activity activity) {
    return FutureBuilder(
      future: SQLDatabase.getUserbyId(activity.fromUserId),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return SizedBox.shrink();
        }
        User user = snapshot.data;
        return ListTile(
          leading: CircleAvatar(
            radius: 25.0,
            backgroundColor: Colors.grey,
            backgroundImage: user.profileImageUrl.isEmpty
                ? AssetImage(placeHolderImageRef)
                : CachedNetworkImageProvider(user.profileImageUrl),
          ),
          title: activity.type == 'FOLLOW'
              ? Row(
                  children: <Widget>[
                    Text('${user.name}', style: kFontWeightBoldTextStyle),
                    UserBadges(user: user, size: 15, secondSizedBox: false),
                    SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        'started following you',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                )
              : activity.type == 'COMMENT'
                  ? Row(
                      children: <Widget>[
                        Text('${user.name}', style: kFontWeightBoldTextStyle),
                        UserBadges(user: user, size: 15, secondSizedBox: false),
                        SizedBox(width: 5),
                        Expanded(
                            child: Text(
                          'commented: "${activity.comment}',
                          overflow: TextOverflow.ellipsis,
                        )),
                      ],
                    )
                  : Row(
                      children: <Widget>[
                        Text('${user.name}', style: kFontWeightBoldTextStyle),
                        UserBadges(user: user, size: 15, secondSizedBox: false),
                        SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            'liked your post',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
          subtitle: Text(
            timeago.format(activity.timestamp),
          ),
          trailing: activity.postImageUrl == null
              ? SizedBox.shrink()
              : CachedNetworkImage(
                  imageUrl: activity.postImageUrl,
                  fadeInDuration: Duration(milliseconds: 500),
                  height: 40.0,
                  width: 40.0,
                  fit: BoxFit.cover,
                ),
          onTap: activity.type == 'FOLLOW'
              ? () => CustomNavigation.navigateToUserProfile(
                  context: context,
                  currentUserId: widget.currentUser.id,
                  isCameFromBottomNavigation: false,
                  userId: activity.fromUserId)
              : () async {
                  // Post post = await DatabaseService.getUserPost(
                  //   widget.currentUser.id,
                  //   activity.postId,
                  // );
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (BuildContext context) {
                  //     return Center(
                  //       child: Scaffold(
                  //         appBar: AppBar(
                  //           title: Text('Post'),
                  //         ),
                  //         body: ListView(children: <Widget>[
                  //           Container(
                  //             child:
                  //             PostView(
                  //               postStatus: PostStatus.feedPost,
                  //               post: post,
                  //               currentUserId: widget.currentUser.id,
                  //               author: widget.currentUser,
                  //             ),
                  //           ),
                  //         ]),
                  //       ),
                  //     );
                  //   }),
                  // );
                },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.color,
        title: Text(
          'Activity',
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => _setupActivities(),
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: _activities.length,
                itemBuilder: (BuildContext context, int index) {
                  Activity activity = _activities[index];
                  if (activity.type == "MESSAGE EVENT" ||
                      activity.type == 'LIKE MESSAGE EVENT') {
                    return SizedBox.shrink();
                  }
                  return _buildActivity(activity);
                },
              ),
      ),
    );
  }
}
