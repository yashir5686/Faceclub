// import 'package:cloud_firestore/cloud_firestore.dart';

// class User {
//   String id;
//   String name;
//   String displayname;
//   String profileImageUrl;
//   String email;
//   String bio;
//   String token;
//   bool isBanned;
//   // final List<String> favoritePosts;
//   // final List<String> blockedUsers;
//   // final List<String> hideStoryFromUsers;
//   // final List<String> closeFriends;
//   // final bool allowStoryMessageReplies;
//   String role;
//   bool isVerified;
//   String website;
//   Timestamp timeCreated;

//   User({
//     this.id,
//     this.name,
//     this.displayname,
//     this.profileImageUrl,
//     this.email,
//     this.bio,
//     this.token,
//     this.isBanned,
//     this.isVerified,
//     this.website,
//     this.role,
//     this.timeCreated,
//   });

//   factory User.fromDoc(DocumentSnapshot doc) {
//     return User(
//       id: doc.documentID,
//       name: doc['name'],
//       displayname: doc['displayname'] ?? '',
//       profileImageUrl: doc['profileImageUrl'],
//       email: doc['email'],
//       bio: doc['bio'] ?? '',
//       token: doc['token'] ?? '',
//       isVerified: doc['isVerified'] ?? false,
//       isBanned: doc['isBanned'],
//       website: doc['website'] ?? '',
//       role: doc['role'] ?? 'user',
//       timeCreated: doc['timeCreated'],
//     );
//   }

//   User.map(dynamic obj) {
//     this.id = obj["userid"];
//     this.displayname = obj["displayname"] ?? '';
//     this.name = obj['name'] ?? '';
//     this.profileImageUrl = obj['profileImageUrl'];
//     this.email = obj['email'];
//     this.bio = obj['bio'] ?? '';
//     this.token = obj['token'] ?? '';
//     this.isVerified = obj['isVerified'] ?? false;
//     this.isBanned = obj['isBanned'] ?? false;
//     this.website = obj['website'] ?? '';
//     this.role = obj['role'] ?? 'user';
//     this.timeCreated = obj['timeCreated'];
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'userid': id,
//       'displayname': displayname,
//       'name': name,
//       'profileImageUrl': profileImageUrl,
//       'email': email,
//       'bio': bio,
//       'token': token,
//       'isVerified': isVerified,
//       'isBanned': isBanned,
//       'website': website,
//       'role': role,
//       'timeCreated': timeCreated,
//     };
//   }

//   User.fromMap(Map<String, dynamic> map) {
//     this.id = map["userid"];
//     this.displayname = map["displayname"] ?? '';
//     this.name = map['name'] ?? '';
//     this.profileImageUrl = map['profileImageUrl'];
//     this.email = map['email'];
//     this.bio = map['bio'] ?? '';
//     this.token = map['token'] ?? '';
//     this.isVerified = map['isVerified'] ?? false;
//     this.isBanned = map['isBanned'] ?? false;
//     this.website = map['website'] ?? '';
//     this.role = map['role'] ?? 'user';
//     this.timeCreated = map['timeCreated'];
//   }
// }
