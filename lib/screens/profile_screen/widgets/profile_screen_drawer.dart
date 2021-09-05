import 'package:flutter/material.dart';
import 'package:instagrampub/models/User.dart';
import 'package:instagrampub/models/models.dart';
import 'package:instagrampub/models/user_data.dart';
import 'package:instagrampub/screens/profile_screen/nested_screens/adminsection.dart';
import 'package:instagrampub/screens/profile_screen/nested_screens/deleted_posts_screen.dart';
import 'package:instagrampub/screens/profile_screen/nested_screens/reportproblem.dart';
import 'package:instagrampub/screens/screens.dart';
import 'package:instagrampub/utilities/constants.dart';
import 'package:instagrampub/utilities/themes.dart';
import 'package:instagrampub/common_widgets/user_badges.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreenDrawer extends StatelessWidget {
  final User user;
  final String currentuserid;
  ProfileScreenDrawer({@required this.user, @required this.currentuserid});

  _buildDrawerOption(Widget icon, String title, Function onTap) {
    return ListTile(
      leading: icon,
      title: Text(
        title,
        style: TextStyle(
          fontSize: 20.0,
        ),
      ),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: 250,
        child: Drawer(
          child: Column(
            children: <Widget>[
              Container(
                height: 56,
                child: ListTile(
                    title: Row(
                  children: [
                    Text(user.name, style: kFontSize18TextStyle),
                    UserBadges(user: user, size: 20),
                  ],
                )),
              ),
              Divider(height: 3),
              _buildDrawerOption(
                Icon(Icons.history),
                'Archive',
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DeletedPostsScreen(
                        currentUserId:
                            Provider.of<UserData>(context, listen: false)
                                .currentUserId,
                        postStatus: PostStatus.archivedPost),
                  ),
                ),
              ),
              _buildDrawerOption(
                Icon(Ionicons.trash_outline),
                'Deleted Posts',
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DeletedPostsScreen(
                      currentUserId:
                          Provider.of<UserData>(context, listen: false)
                              .currentUserId,
                      postStatus: PostStatus.deletedPost,
                    ),
                  ),
                ),
              ),
              // _buildDrawerOption(
              //     Icon(Icons.history_toggle_off), 'Your Activity', null),
              if (user.role == 'admin')
                _buildDrawerOption(
                    Icon(Ionicons.key_outline), 'Admins Section',
                      () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (BuildContext context) => AdminSection(currentuserid))
                    // );
                    }
                    ),
              // _buildDrawerOption(
              //     Icon(Ionicons.bookmark_outline), 'Saved', null),
              _buildDrawerOption(
                Icon(Icons.report),
                'Send Feedback',
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ReportProblem(currentuserid),
                  ),
                ),
              ),
              _buildDrawerOption(
                Icon(Icons.support),
                'Support Us',
                () => launch('https://faceclubofficial.blogspot.com/p/donate-page.html')
              ),
              Expanded(
                child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: _buildDrawerOption(
                    Icon(Ionicons.settings_outline),
                    'Settings',
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SettingsScreen(),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
