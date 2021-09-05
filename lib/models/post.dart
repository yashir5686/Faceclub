// To parse this JSON data, do
//
//     final post = postFromJson(jsonString);

import 'dart:convert';

List<Post> postFromJson(String str) =>
    List<Post>.from(json.decode(str).map((x) => Post.fromJson(x)));

String postToJson(List<Post> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Post {
  Post({
    this.id,
    this.authorId,
    this.caption,
    //this.category,
    this.imageUrl,
    this.likeCount,
    this.isphoto,
    this.location,
    this.timestamp,
    this.commentsAllowed,
  });

  String id;
  String authorId;
  String caption;
  //String category;
  String imageUrl;
  int likeCount;
  bool isphoto;
  String location;
  DateTime timestamp;
  bool commentsAllowed;

  factory Post.fromJson(Map json) => Post(
        id: json["postid"],
        authorId: json["userid"],
        caption: json["caption"],
        //category: json["category"],
        imageUrl: json["imageUrl"],
        likeCount: int.parse(json["likeCount"]),
        isphoto: json["isphoto"] == 0 ? false : true,
        location: json["location"],
        timestamp: DateTime.parse(json["timestamp"]),
        commentsAllowed: json["commentsAllowed"] == 0 ? false : true,
      );

  Map<String, dynamic> toJson() => {
        "postid": id,
        "userid": authorId,
        "caption": caption,
        //"category": category,
        "imageUrl": imageUrl,
        "likeCount": likeCount,
        "isphoto": isphoto,
        "location": location,
        "timestamp": timestamp.toIso8601String(),
        "commentsAllowed": commentsAllowed,
      };
}
