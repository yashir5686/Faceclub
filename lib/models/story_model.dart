// import 'package:cloud_firestore/cloud_firestore.dart';

// class Story {
//   final String id;
//   final Timestamp timeEnd;
//   final Timestamp timeStart;
//   final String authorId;
//   final String imageUrl;
//   final bool isphoto;
//   final String caption;
//   final Map<dynamic, dynamic> views;
//   final String location;
//   final String filter;
//   final String linkUrl;
//   final int duration;

//   Story({
//     this.id,
//     this.timeStart,
//     this.timeEnd,
//     this.authorId,
//     this.imageUrl,
//     this.isphoto,
//     this.caption,
//     this.views,
//     this.location,
//     this.filter,
//     this.linkUrl,
//     this.duration,
//   });

//   factory Story.fromDoc(DocumentSnapshot doc) {
//     return Story(
//       id: doc.id,
//       timeStart: doc['timeStart'],
//       timeEnd: doc['timeEnd'],
//       authorId: doc['authorId'],
//       imageUrl: doc['imageUrl'],
//       isphoto: doc['isphoto'],
//       caption: doc['caption'],
//       views: doc['views'],
//       location: doc['location'],
//       filter: doc['filter'],
//       linkUrl: doc['linkUrl'] ?? '',
//       duration: doc['duration'] ?? 10,
//     );
//   }
// }
