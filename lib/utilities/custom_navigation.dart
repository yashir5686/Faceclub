import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagrampub/screens/screens.dart';
// ignore: unused_import
import 'package:instagrampub/utilities/show_error_dialog.dart';

class CustomNavigation {
  static void navigateToUserProfile({
    BuildContext context,
    bool isCameFromBottomNavigation,
    String currentUserId,
    String userId,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProfileScreen(
          isCameFromBottomNavigation: isCameFromBottomNavigation,
          currentUserId: currentUserId,
          userId: userId,
          goToCameraScreen: () =>
              navigateToHomeScreen(context, currentUserId, initialPage: 0),
        ),
      ),
    );
  }

  // static void navigateToShowErrorDialog(
  //     BuildContext context, String errorMessage) {
  //   Navigator.push(context,
  //       MaterialPageRoute(builder: (_) => ShowErrorDialog(errorMessage)));
  // }

  static void navigateToHomeScreen(BuildContext context, String currentUserId,
      {int initialPage = 1}) async {
    if (initialPage == 0) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => HomeScreen(
            currentUserId: currentUserId,
            initialPage: initialPage,
          ),
        ),
        (Route<dynamic> route) => false,
      );
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => HomeScreen(
            currentUserId: currentUserId,
            initialPage: initialPage,
          ),
        ),
        (Route<dynamic> route) => false,
      );
    }
  }
}
