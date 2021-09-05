// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:instagrampub/main.dart';
// import 'package:instagrampub/models/User.dart';
// import 'package:instagrampub/models/models.dart';
// import 'package:instagrampub/screens/stories_screen/widgets/swipe_up.dart';
// import 'package:instagrampub/screens/upload%20page/upload_page.dart';
// import 'package:instagrampub/services/api/stories_service.dart';
// import 'package:instagrampub/utilities/constants.dart';
// import 'package:instagrampub/common_widgets/user_badges.dart';
// import 'package:timeago/timeago.dart' as timeago;

// class StoryInfo extends StatelessWidget {
//   final User user;
//   final Story story;
//   final double height;
//   final Function onSwipeUp;
//   final String currentUserId;
//   const StoryInfo({
//     @required this.user,
//     @required this.story,
//     @required this.height,
//     @required this.onSwipeUp,
//     @required this.currentUserId,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: height,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           _buildUserInfo(context),
//           if (story.caption != '') _buildStoryCaption(),
//           if (story.linkUrl != '') SwipeUp(onSwipeUp: onSwipeUp),

//         ],
//       ),
//     );
//   }

//   _buildStoryCaption() {
//     return Center(
//       child: Text(
//         story.caption,
//         textAlign: TextAlign.center,
//         style: TextStyle(fontSize: 30, color: Colors.white),
//       ),
//     );
//   }

//   _buildUserInfo(BuildContext context) {
//     return Container(
//       height: 70,
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: <Widget>[
//               Row(
//                 children: [
//                   CircleAvatar(
//                     radius: 30.0,
//                     backgroundColor: Colors.grey[200],
//                     backgroundImage: user.profileImageUrl.isEmpty
//                         ? AssetImage(placeHolderImageRef)
//                         : CachedNetworkImageProvider(user.profileImageUrl),
//                   ),
//                   const SizedBox(width: 10.0),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             user.name,
//                             style: TextStyle(fontSize: 16, color: Colors.white),
//                           ),
//                           UserBadges(user: user, size: 20),
//                         ],
//                       ),
//                       Row(
//                         children: [
//                           Text(
//                             '${timeago.format(story.timeStart.toDate(), locale: 'en_short')}',
//                             style: TextStyle(color: Colors.white),
//                           ),
//                           SizedBox(width: 10,),
//                           Text('${story.views.length}'),
//                           SizedBox(width: 5,),
//                           Icon(Icons.remove_red_eye),
//                         ],
//                       ),
//                       story.location != ''
//                           ? Row(
//                               children: [
//                                 Text(
//                                   story.location,
//                                   style: TextStyle(color: Colors.white),
//                                 ),
//                                 Icon(
//                                   Icons.location_pin,
//                                   size: 18,
//                                   color: Colors.white,
//                                 ),
//                               ],
//                             )
//                           : SizedBox.shrink(),
//                     ],
//                   ),
//                 ],
//               ),
//               IconButton(
//                 icon:
//                     const Icon(Icons.add_circle_outlined),
//                 onPressed: () {
//                   Navigator.restorablePush(context, gotoCamera);
//                 },
//               ),
//               story.authorId == currentUserId
//               ? IconButton(
//                 icon: Icon(Icons.more_vert),
//                 onPressed: () => showbottomsheet(context),
//               ) : SizedBox.shrink(),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   static Route<void> gotoCamera(BuildContext context, Object arguments) {
//     return MaterialPageRoute<void>(
//       builder: (BuildContext context) => UploadPage(CameraConsumer.story),
//     );
//   }

//   showbottomsheet(BuildContext context) {
//     return showModalBottomSheet(
//         context: context,
//         builder: (BuildContext context) => Container(
//             padding: EdgeInsets.all(10),
//             decoration: BoxDecoration(
//                 borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(20),
//                     topRight: Radius.circular(20))),
//             child: Column(
//               children: [
//                 TextButton(
//                     onPressed: () async {
//                       await StoriesService.deletestory(story);
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (BuildContext context) => MyApp(
//                                     IsfromotherPage: true,
//                                   )));
//                     },
//                     child: Text('Delete'))
//               ],
//             )));
//   }
// }
