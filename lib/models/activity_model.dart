// import 'package:cloud_firestore/cloud_firestore.dart';

// class Activity {
  // final String id;
  // final String fromUserId;
  // final String ActivityId;
  // final bool isphoto;
  // final String ActivityImageUrl;
  // final String comment;
  // final bool isFollowEvent;
  // final bool isLikeEvent;
  // final bool isMessageEvent;
  // final bool isCommentEvent;
  // final bool isLikeMessageEvent;

  // final String recieverToken;
  // final Timestamp timestamp;

//   Activity({
    // this.id,
    // this.fromUserId,
    // this.ActivityId,
    // this.isphoto,
    // this.ActivityImageUrl,
    // this.comment,
    // this.timestamp,
    // this.isFollowEvent,
    // this.isLikeEvent,
    // this.isMessageEvent,
    // this.isCommentEvent,
    // this.isLikeMessageEvent,
    // this.recieverToken,
//   });

//   factory Activity.fromDoc(DocumentSnapshot doc) {
//     return Activity(
      // id: doc.documentID,
      // fromUserId: doc['fromUserId'],
      // ActivityId: doc['ActivityId'],
      // isphoto: doc['isphoto'] ?? true,
      // ActivityImageUrl: doc['ActivityImageUrl'],
      // comment: doc['comment'],
      // timestamp: doc['timestamp'],
      // isFollowEvent: doc['isFollowEvent'] ?? false,
      // isCommentEvent: doc['isCommentEvent'] ?? false,
      // isLikeEvent: doc['isLikeEvent'] ?? false,
      // isMessageEvent: doc['isMessageEvent'] ?? false,
      // isLikeMessageEvent: doc['isMessageEvent'] ?? false,
      // recieverToken: doc['receiverToken'] ?? '',
//     );
//   }
// }

// To parse this JSON data, do
//
//     final Activity = ActivityFromJson(jsonString);

import 'dart:convert';

List<Activity> ActivityFromJson(String str) =>
    List<Activity>.from(json.decode(str).map((x) => Activity.fromJson(x)));

String ActivityToJson(List<Activity> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Activity {
  Activity({
    this.id,
    this.fromUserId,
    this.postId,
    this.postImageUrl,
    this.comment,
    this.timestamp,
    this.type,
    this.recieverToken,
  });

  final String id;
  final String fromUserId;
  final String postId;
  final String postImageUrl;
  final String comment;
  final String type;
  final String recieverToken;
  final DateTime timestamp;

  factory Activity.fromJson(Map json) => Activity(
      id: json["activityid"],
      fromUserId: json["fromUserId"],
      postId: json["postId"],
      postImageUrl: json["postImageUrl"],
      comment: json["comment"],
      timestamp: DateTime.parse(json["timestamp"]),
      type : json["type"],
      recieverToken: json["receiverToken"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "activityid": id,
        "fromUserId": fromUserId,
        "postId": postId,
        "postImageUrl": postImageUrl,
        "comment": comment,
        "timestamp": timestamp.toIso8601String(),
        "type": type,
        "receiverToken": recieverToken,
      };
}

