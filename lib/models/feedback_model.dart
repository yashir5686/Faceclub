// import 'package:cloud_firestore/cloud_firestore.dart';

// class IssueFeedback {
//   final String message;
//   final String issue;
//   final String userid;
//   final Timestamp timestamp;

//   IssueFeedback({
//     this.message,
//     this.issue,
//     this.userid,
//     this.timestamp,
//   });

//   factory IssueFeedback.fromDoc(DocumentSnapshot doc) {
//     return IssueFeedback(
//       message: doc['feedback'],
//       issue: doc['issue'] ?? '',
//       userid: doc['userid'],
//       timestamp: doc['timestamp'],
//     );
//   }
// }
