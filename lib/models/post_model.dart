// import 'package:cloud_firestore/cloud_firestore.dart';

// class PostModel {
//   final String id;
//   final String imageUrl;
//   final bool isphoto;
//   final String caption;
//   final int likeCount;
//   final String authorId;
//   final String location;
//   // ignore: non_constant_identifier_names
//   final String Category;
//   final Timestamp timestamp;
//   final bool commentsAllowed;

//   PostModel({
//     this.id,
//     this.imageUrl,
//     this.isphoto,
//     this.caption,
//     this.likeCount,
//     this.authorId,
//     this.location,
//     // ignore: non_constant_identifier_names
//     this.Category,
//     this.timestamp,
//     this.commentsAllowed,
//   });

//   factory PostModel.fromDoc(DocumentSnapshot doc) {
//     return PostModel(
//       id: doc.id,
//       imageUrl: doc['imageUrl'],
//       isphoto: doc['isphoto'] ?? true,
//       caption: doc['caption'],
//       likeCount: doc['likeCount'],
//       authorId: doc['authorId'],
//       location: doc['location'] ?? "",
//       Category: doc['Category'] ?? "",
//       timestamp: doc['timestamp'],
//       commentsAllowed: doc['commentsAllowed'] ?? true,
//     );
//   }
// }
