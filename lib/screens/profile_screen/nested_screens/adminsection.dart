// import 'package:flutter/material.dart';
// import 'package:instagrampub/models/User.dart';
// import 'package:instagrampub/models/feedback_model.dart';
// import 'package:instagrampub/screens/profile_screen/widgets/feedbackview.dart';
// import 'package:instagrampub/services/api/sqldatabase.dart';
// import 'package:instagrampub/services/services.dart';

// class AdminSection extends StatefulWidget {
//   final String currentuserid;

//   AdminSection(this.currentuserid);

//   @override
//   _AdminSectionState createState() => _AdminSectionState();
// }

// class _AdminSectionState extends State<AdminSection> {
//   //List<IssueFeedback> _feedbacks = [];
//   bool _isLoadingFeedbacks = false;

//   @override
//   void initState() {
//     super.initState();
//     _setupFeedbacks();
//   }

//   _setupFeedbacks() async {
//     setState(() => _isLoadingFeedbacks = true);

//     //List<IssueFeedback> feedbacks = await DatabaseService.getFeedbacks();

//     // List<Post> posts = await DatabaseService.getAllFeedPosts();
//     setState(() {
//       //_feedbacks = feedbacks;
//       _isLoadingFeedbacks = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).appBarTheme.color,
//         centerTitle: true,
//         title: Text(
//           'Feedbacks',
//         ),
//       ),
//       body: !_isLoadingFeedbacks
//           ? RefreshIndicator(
//               // If posts finished loading
//               onRefresh: () => _setupFeedbacks(),
//               child: SingleChildScrollView(
//                 physics: ScrollPhysics(),
//                 child: Column(
//                   children: [
//                     SizedBox(height: 5),
//                     ListView.builder(
//                       physics: NeverScrollableScrollPhysics(),
//                       shrinkWrap: true,
//                       itemCount: _feedbacks.length > 0 ? _feedbacks.length : 1,
//                       itemBuilder: (BuildContext context, int index) {
//                         if (_feedbacks.length == 0) {
//                           //If there is no posts
//                           return Container(
//                             height: MediaQuery.of(context).size.height,
//                             child: Center(
//                               child: Text('No Feedbacks Found'),
//                             ),
//                           );
//                         } else {
//                           //IssueFeedback feedback = _feedbacks[index];

//                           return null;
//                           // FutureBuilder(
//                           //   future: SQLDatabase.getUserbyId(feedback.userid),
//                           //   builder:
//                           //       (BuildContext context, AsyncSnapshot snapshot) {
//                           //     if (!snapshot.hasData) {
//                           //       return SizedBox.shrink();
//                           //     }

//                           //     User author = snapshot.data;

//                           //     return FeedbackView(
//                           //       currentUserId: widget.currentuserid,
//                           //       author: author,
//                           //       feedback: feedback,
//                           //     );
//                           //   },
//                           // );
//                         }
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             )
//           : Center(
//               // If posts is loading
//               child: CircularProgressIndicator(),
//             ),
//     );
//   }
// }
