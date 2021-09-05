// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:instagrampub/models/User.dart';
// import 'package:instagrampub/models/feedback_model.dart';
// import 'package:instagrampub/utilities/constants.dart';
// import 'package:instagrampub/utilities/custom_navigation.dart';
// import 'package:instagrampub/utilities/themes.dart';
// import 'package:instagrampub/common_widgets/user_badges.dart';
// import 'package:timeago/timeago.dart' as timeago;

// class FeedbackView extends StatefulWidget {
//   final String currentUserId;
//   //final IssueFeedback feedback;
//   final User author;

//   FeedbackView(
//       {this.currentUserId, this.feedback, this.author});

//   @override
//   _FeedbackViewState createState() => _FeedbackViewState();
// }

// class _FeedbackViewState extends State<FeedbackView> {

//   @override
//   void initState() {
//     super.initState();
//   }

//   _goToUserProfile(BuildContext context, IssueFeedback feedback) {
//     CustomNavigation.navigateToUserProfile(
//         context: context,
//         currentUserId: widget.currentUserId,
//         userId: feedback.userid,
//         isCameFromBottomNavigation: false);
//   }

//   // _goToHomeScreen(BuildContext context) {
//   //   Navigator.pushAndRemoveUntil(
//   //     context,
//   //     MaterialPageRoute(
//   //         builder: (_) => HomeScreen(
//   //               currentUserId: widget.currentUserId,
//   //             )),
//   //     (Route<dynamic> route) => false,
//   //   );
//   // }

//   @override
//   Widget build(BuildContext context) {
//       return Padding(
//           padding: const EdgeInsets.all(10.0),
//           child: Container(
//             decoration: BoxDecoration(
//               border: Border.all(color: Colors.white, width: 1),
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: <Widget>[
//                 Container(
//                   child: ListTile(
//                     leading: GestureDetector(
//                       onTap: () => _goToUserProfile(context, widget.feedback),
//                       child: CircleAvatar(
//                         backgroundColor: Colors.grey,
//                         backgroundImage: widget.author.profileImageUrl.isEmpty
//                             ? AssetImage(placeHolderImageRef)
//                             : CachedNetworkImageProvider(
//                                 widget.author.profileImageUrl,
//                               ),
//                       ),
//                     ),
//                     title: GestureDetector(
//                       onTap: () => _goToUserProfile(context, widget.feedback),
//                       child: Row(
//                         children: [
//                           Text(
//                             widget.author.name,
//                             style: kFontSize18FontWeight600TextStyle,
//                           ),
//                           UserBadges(user: widget.author, size: 15)
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                       Container(
//                         width: MediaQuery.of(context).size.width,
//                         child: Padding(
//                           padding: EdgeInsets.all(10),
//                           child: Text('${widget.feedback.message}'),
//                         )
//                         ),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: <Widget>[
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: <Widget>[
//                       SizedBox(height: 4.0),
//                       Row(
//                         children: <Widget>[
//                           Container(
//                             margin: const EdgeInsets.only(
//                               left: 12.0,
//                               right: 6.0,
//                             ),
//                             child: GestureDetector(
//                               onTap: () => _goToUserProfile(context, widget.feedback),
//                               child: Row(
//                                 children: [
//                                   Text(
//                                     widget.author.name,
//                                     style: TextStyle(
//                                         fontSize: 16.0, fontWeight: FontWeight.bold),
//                                   ),
//                                   UserBadges(
//                                       user: widget.author,
//                                       size: 15,
//                                       secondSizedBox: false)
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       Padding(
//                         padding:
//                             const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
//                         child: Text(
//                           timeago.format(widget.feedback.timestamp.toDate()),
//                           style: TextStyle(
//                             color: Colors.grey,
//                             fontSize: 12.0,
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 12.0),
//                     ],
//                   ),
//               ],
//             ))]),
//           ),
//     );
//   }
// }
