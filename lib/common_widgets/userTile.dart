import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagrampub/common_widgets/user_badges.dart';
import 'package:instagrampub/models/User.dart';
import 'package:instagrampub/models/user_data.dart';
import 'package:instagrampub/screens/direct_messages/nested_screens/chat_screen.dart';
import 'package:instagrampub/screens/profile_screen/profile_screen.dart';
import 'package:instagrampub/utilities/constants.dart';
import 'package:instagrampub/utilities/custom_navigation.dart';
import 'package:instagrampub/utilities/themes.dart';
import 'package:provider/provider.dart';

class UserTile extends StatefulWidget {
  final String currentUserId;
  final User user;
  final SearchFrom searchFrom;
  final File imageFile;

  UserTile(
      {this.currentUserId, this.user, this.searchFrom, this.imageFile});

  @override
  _UserTileState createState() => _UserTileState();
}

class _UserTileState extends State<UserTile> {

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.grey,
        radius: 20.0,
        backgroundImage: widget.user.profileImageUrl.isEmpty
            ? AssetImage(placeHolderImageRef)
            : CachedNetworkImageProvider(widget.user.profileImageUrl),
      ),
      title: Row(
        children: [Text(widget.user.name), UserBadges(user: widget.user, size: 15)],
      ),
      trailing: widget.searchFrom == SearchFrom.createStoryScreen
      // ignore: deprecated_member_use
          ? FlatButton(
        child: Text(
          'Send',
          style: kFontSize18TextStyle.copyWith(color: Colors.white),
        ),
        color: Colors.blue,
        onPressed: () => {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (_) => ChatScreen(
          //       receiverUser: widget.user,
          //       imageFile: widget.imageFile,
          //     ),
          //   ),
          // ),
        },
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
            userId: widget.user.id,
            currentUserId: Provider.of<UserData>(context, listen: false)
                .currentUserId,
          ),
        ),
      )
          : widget.searchFrom == SearchFrom.messagesScreen
          ? null
      //     () => Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (_) => ChatScreen(
      //       receiverUser: widget.user,
      //       imageFile: widget.imageFile,
      //     ),
      //   ),
      // )
          : null,
    );
  }
}
