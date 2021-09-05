// import 'package:cloud_firestore/cloud_firestore.dart';

// class Comment {
// final String id;
// final String content;
// final String authorId;
// final DateTime timestamp;

//   Comment({
//     this.id,
//     this.content,
//     this.authorId,
//     this.timestamp,
//   });

//   factory Comment.fromDoc(DocumentSnapshot doc) {
//     return Comment(
//       id: doc.documentID,
//       content: doc['content'],
//       authorId: doc['authorId'],
//       timestamp: doc['timestamp'],
//     );
//   }
// }

// To parse this JSON data, do
//
//     final Comment = CommentFromJson(jsonString);

import 'dart:convert';

List<Comment> CommentFromJson(String str) =>
    List<Comment>.from(json.decode(str).map((x) => Comment.fromJson(x)));

String CommentToJson(List<Comment> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

Comment SinglecommentFromJson(String str) => Comment.fromJson(json.decode(str));

class Comment {
  Comment({
    this.id,
    this.content,
    this.authorId,
    this.timestamp,
  });

  final String id;
  final String content;
  final String authorId;
  final DateTime timestamp;

  factory Comment.fromJson(Map json) => Comment(
        id: json["commentid"],
        authorId: json["authorid"],
        content: json["content"],
        timestamp: DateTime.parse(json["timestamp"]),
      );

  Map<String, dynamic> toJson() => {
        "commentid": id,
        "authorid": authorId,
        "content": content,
        "timestamp": timestamp.toIso8601String(),
      };
}
