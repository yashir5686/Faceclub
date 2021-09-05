import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:instagrampub/services/api/sqldatabase.dart';
import 'package:instagrampub/utilities/custom_navigation.dart';

import 'package:instagrampub/utilities/repo_const.dart';
import 'package:instagrampub/utilities/themes.dart';

class AboutAppDialog extends StatefulWidget {
  final String currentUserId;
  AboutAppDialog(this.currentUserId);
  @override
  _AboutAppDialogState createState() => _AboutAppDialogState();
}

class _AboutAppDialogState extends State<AboutAppDialog> {
  bool _isFollowing = false;
  String _followText = 'Follow ME!';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _setupIsFollowing();
  }

  Future _setupIsFollowing() async {
    bool isFollowingUser = await SQLDatabase.isfollowing(
      widget.currentUserId,kAdminUId,
    );
    setState(() {
      _isFollowing = isFollowingUser;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Faceclub',
            style: TextStyle(
              fontSize: 45,
              fontFamily: 'Billabong', 
              ),
            ),
          Row(
            children: [
              Text(
                '      Developed With ♥ By:',
                style: kFontSize18FontWeight600TextStyle.copyWith(
                    color: Theme.of(context).accentColor.withOpacity(0.8)),
              ),
            ],
          ),
          SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(blurRadius: 2, color: Colors.black54, spreadRadius: 2)
              ],
            ),
            child: GestureDetector(
              onTap: () => CustomNavigation.navigateToUserProfile(
                  context: context,
                  currentUserId: widget.currentUserId,
                  isCameFromBottomNavigation: false,
                  userId: kAdminUId),
              child: CircleAvatar(
                radius: 50.0,
                backgroundColor: Colors.grey,
                backgroundImage: CachedNetworkImageProvider(
                    'assets/images/faceclub_logo.png'),
              ),
            ),
          ),
          SizedBox(height: 5),
          Text(
            'Faceclub',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          Center(
            child: Text(
              'I hope you Enjoye using faceclub :)',
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
      children: <Widget>[
        if (!_isLoading && !_isFollowing && widget.currentUserId != kAdminUId)
          Divider(),
        !_isFollowing && !_isLoading && widget.currentUserId != kAdminUId
            ? SimpleDialogOption(
                child: Center(
                  child: Text(
                    _followText,
                    style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).accentColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                onPressed: _followText == 'Thanks ♥'
                    ? null
                    : () async {
                        setState(() {
                          _followText = 'Thanks ♥';
                        });
                        await SQLDatabase.followuser(currentUserId: widget.currentUserId, userId: kAdminUId, receiverToken: '');
                      })
            : SizedBox.shrink(),
      ],
    );
  }
}
