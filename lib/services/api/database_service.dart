// import 'dart:convert';
// import 'package:http/http.dart' as http;

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:instagrampub/models/User.dart';
// import 'package:instagrampub/models/activity_model.dart';
// import 'package:instagrampub/models/feedback_model.dart';
// import 'package:instagrampub/models/post_model.dart';
// import 'package:instagrampub/services/api/storage_service.dart';
// import 'package:instagrampub/utilities/constants.dart';

// class DatabaseService {
//   static void updateUser(User user) async {
//     usersRef.doc(user.id).update({
//       'name': user.name,
//       'profileImageUrl': user.profileImageUrl,
//       'bio': user.bio,
//       'website': user.website,
//       'displayname': user.displayname,
//     });
//     final UserdocRef = usersRef.doc(user.id);
//     final UserSnapshot = await UserdocRef.get();
//     final UserdocData = UserSnapshot.data();

//     if (UserdocData['isBanned' == true]) {
//       disableuser(user.id, true);
//     }
//   }

//   static void disableuser(userId, isBanned) {
//     usersRef.doc(userId).update({'isBanned': isBanned});
//   }

//   static void changeUsername(String name, String oldname) async {
//     final _firestore = FirebaseFirestore.instance;

//     _firestore.collection('usernames').doc(oldname).delete();

//     _firestore.collection('usernames').doc(name).set({
//       'username': name,
//     });
//   }

//   static Future<bool> checkUsername(String name) async {
//     final _firestore = FirebaseFirestore.instance;

//     DocumentSnapshot usernames =
//         await _firestore.collection('usernames').doc(name).get();

//     if (usernames.exists) {
//       return true;
//     } else {
//       return false;
//     }
//   }

//   static Future<bool> checkname(String name) => checkUsername(name);

//   static Future<QuerySnapshot> searchUsers(String name) {
//     Future<QuerySnapshot> users =
//         usersRef.where('name', isGreaterThanOrEqualTo: name).get();
//     return users;
//   }

//   static void createPost(PostModel post) async {
//     try {
//       postsRef.doc(post.authorId).collection('userPosts').add({
//         'imageUrl': post.imageUrl,
//         'caption': post.caption,
//         'isphoto': post.isphoto,
//         'category': post.Category,
//         'likeCount': post.likeCount,
//         'authorId': post.authorId,
//         'location': post.location,
//         'timestamp': post.timestamp
//       });

//       final userFollowersRef = await followersRef
//           .doc(post.authorId)
//           .collection("userFollowers")
//           .get();
//       userFollowersRef.docs.forEach((document) => {
//             feedsRef
//                 .doc(document.id)
//                 .collection("userFeed")
//                 .doc(post.id)
//                 .set({
//               'imageUrl': post.imageUrl,
//               'caption': post.caption,
//               'isphoto': post.isphoto,
//               'category': post.Category,
//               'likeCount': post.likeCount,
//               'authorId': post.authorId,
//               'location': post.location,
//               'timestamp': post.timestamp
//             })
//           });
//     } catch (e) {
//       print(e);
//     }
//   }

//   static void sendfeedback(IssueFeedback feedback) {
//     final _firestore = FirebaseFirestore.instance;

//     try {
//       _firestore.collection('feedbacks').add({
//         'issue': feedback.issue,
//         'feedback': feedback.message,
//         'userid': feedback.userid,
//         'timestamp': feedback.timestamp,
//       });
//     } catch (e) {
//       print(e);
//     }
//   }

//   static void createVideoPost(PostModel post) async {
//     try {
//       postsRef.doc(post.authorId).collection('userPosts').add({
//         'imageUrl': post.imageUrl,
//         'caption': post.caption,
//         'isphoto': post.isphoto,
//         'likeCount': post.likeCount,
//         'authorId': post.authorId,
//         'location': post.location,
//         'timestamp': post.timestamp
//       });

//       final userFollowersRef = await followersRef
//           .doc(post.authorId)
//           .collection("userFollowers")
//           .get();
//       userFollowersRef.docs.forEach((document) => {
//             feedsRef
//                 .doc(document.id)
//                 .collection("userFeed")
//                 .doc(post.id)
//                 .set({
//               'imageUrl': post.imageUrl,
//               'caption': post.caption,
//               'isphoto': post.isphoto,
//               'category': post.Category,
//               'likeCount': post.likeCount,
//               'authorId': post.authorId,
//               'location': post.location,
//               'timestamp': post.timestamp
//             })
//           });
//     } catch (e) {
//       print(e);
//     }
//   }

//   static void editPost(
//     PostModel post,
//     PostStatus postStatus,
//   ) async {
//     String collection;
//     if (postStatus == PostStatus.archivedPost) {
//       collection = 'archivedPosts';
//     } else if (postStatus == PostStatus.feedPost) {
//       collection = 'userPosts';
//     } else {
//       collection = 'deletedPosts';
//     }
//     postsRef
//         .doc(post.authorId)
//         .collection(collection)
//         .doc(post.id)
//         .update({
//       'caption': post.caption,
//       'category': post.Category,
//       'location': post.location,
//     });

//     final userFollowersRef = await followersRef
//         .doc(post.authorId)
//         .collection("userFollowers")
//         .get();

//     userFollowersRef.docs.forEach((document) => {
//           // Updating post to current user followers feed
//           feedsRef
//               .doc(document.id)
//               .collection("userFeed")
//               .doc(post.id)
//               .update({
//             'caption': post.caption,
//             'category': post.Category,
//             'location': post.location,
//           }),
//         });
//   }

//   static void allowDisAllowPostComments(PostModel post, bool commentsAllowed) {
//     try {
//       postsRef
//           .doc(post.authorId)
//           .collection('userPosts')
//           .doc(post.id)
//           .update({
//         'commentsAllowed': commentsAllowed,
//       });
//     } catch (e) {
//       print(e);
//     }
//   }

//   static void deletePost(PostModel post, PostStatus postStatus) async {
//     postsRef
//         .doc(post.authorId)
//         .collection('deletedPosts')
//         .doc(post.id)
//         .set({
//       'imageUrl': post.imageUrl,
//       'caption': post.caption,
//       'isphoto': post.isphoto,
//       'likeCount': post.likeCount,
//       'authorId': post.authorId,
//       'location': post.location,
//       'timestamp': post.timestamp
//     });
//     String collection;
//     postStatus == PostStatus.feedPost
//         ? collection = 'userPosts'
//         : collection = 'archivedPosts';
//     postsRef
//         .doc(post.authorId)
//         .collection(collection)
//         .doc(post.id)
//         .delete();

//     final authorFollowersRef = await followersRef
//         .doc(post.authorId)
//         .collection("userFollowers")
//         .get();

//     authorFollowersRef.docs.forEach((userDoc) => {
//           feedsRef
//               .doc(userDoc.id)
//               .collection("userFeed")
//               .doc(post.id)
//               .delete(),
//         });
//     /* End of Deleting post from followers feeds */
//     /* Deleting post from author feed */
//     final authorFeedRef =
//         feedsRef.doc(post.authorId).collection("userFeed");

//     authorFeedRef.doc(post.id).delete();
//     /* End of Deleting post from author feed */
//   }

//   static void permanentdeletepost(PostModel post) async {
//     postsRef
//         .doc(post.authorId)
//         .collection('deletedPosts')
//         .doc(post.id)
//         .delete();
//     StroageService.deletepostImage(post.imageUrl);
//   }

//   static void archivePost(PostModel post, PostStatus postStatus) async {
//     postsRef
//         .doc(post.authorId)
//         .collection('archivedPosts')
//         .doc(post.id)
//         .set({
//       'imageUrl': post.imageUrl,
//       'caption': post.caption,
//       'isphoto': post.isphoto,
//       'likeCount': post.likeCount,
//       'authorId': post.authorId,
//       'location': post.location,
//       'timestamp': post.timestamp
//     });
//     String collection;
//     postStatus == PostStatus.feedPost
//         ? collection = 'userPosts'
//         : collection = 'deletedPosts';

//     postsRef
//         .doc(post.authorId)
//         .collection(collection)
//         .doc(post.id)
//         .delete();

//     final authorFollowersRef = await followersRef
//         .doc(post.authorId)
//         .collection("userFollowers")
//         .get();

//     deletedoc(userDoc) async {
//       final postRef = feedsRef.doc(userDoc.id).collection("userFeed");
//       // Delete post for each follower feed
//       await postRef.doc(post.id).delete();
//     }

//     authorFollowersRef.docs.forEach((userDoc) => {deletedoc(userDoc)});
//     /* End of Deleting post from followers feeds */
//     /* Deleting post from author feed */
//     final authorFeedRef =
//         feedsRef.doc(post.authorId).collection("userFeed");

//     authorFeedRef.doc(post.id).delete();
//     /* End of Deleting post from author feed */
//   }

//   static void recreatePost(PostModel post, PostStatus postStatus) {
//     try {
//       postsRef
//           .doc(post.authorId)
//           .collection('userPosts')
//           .doc(post.id)
//           .set({
//         'imageUrl': post.imageUrl,
//         'caption': post.caption,
//         'isphoto': post.isphoto,
//         'likeCount': post.likeCount,
//         'authorId': post.authorId,
//         'location': post.location,
//         'timestamp': post.timestamp
//       });

//       String collection;
//       postStatus == PostStatus.archivedPost
//           ? collection = 'archivedPosts'
//           : collection = 'deletedPosts';

//       postsRef
//           .doc(post.authorId)
//           .collection(collection)
//           .doc(post.id)
//           .delete();
//     } catch (e) {
//       print(e);
//     }
//   }

//   static void followUser(
//       {String currentUserId, String userId, String receiverToken}) async {
//     // Add user to current user's following collection
//     followingRef
//         .doc(currentUserId)
//         .collection(userFollowing)
//         .doc(userId)
//         .set({'timestamp': Timestamp.fromDate(DateTime.now())});

//     // Add current user to user's followers collection
//     followersRef
//         .doc(userId)
//         .collection(usersFollowers)
//         .doc(currentUserId)
//         .set({'timestamp': Timestamp.fromDate(DateTime.now())});

//     //followed user posts
//     QuerySnapshot followedUserPostsRef =
//         await postsRef.doc(userId).collection('userPosts').get();

//     //current user feed
//     final userFeedRef = feedsRef.doc(currentUserId).collection('userFeed');

//     followedUserPostsRef.docs.forEach((document) => {
//           if (document.exists)
//             {
//               // Add followed user posts to current user feed
//               userFeedRef.doc(document.id).set(document.data())
//             }
//         });

//     PostModel post = PostModel(
//       authorId: userId,
//     );

//     addActivityItem(
//       comment: null,
//       currentUserId: currentUserId,
//       isFollowEvent: true,
//       post: post,
//       isCommentEvent: false,
//       isLikeEvent: false,
//       isLikeMessageEvent: false,
//       isMessageEvent: false,
//       recieverToken: receiverToken,
//     );
//   }

//   static void unfollowUser({String currentUserId, String userId}) async {
//     // Remove user from current user's following collection
//     followingRef
//         .doc(currentUserId)
//         .collection(userFollowing)
//         .doc(userId)
//         .get()
//         .then((doc) {
//       if (doc.exists) {
//         doc.reference.delete();
//       }
//     });

//     // Remove current user from user's followers collection
//     followersRef
//         .doc(userId)
//         .collection(usersFollowers)
//         .doc(currentUserId)
//         .get()
//         .then((doc) {
//       if (doc.exists) {
//         doc.reference.delete();
//       }
//     });

//     final userFeedRef = await feedsRef
//         .doc(currentUserId)
//         .collection('userFeed')
//         .where("authorId", isEqualTo: userId)
//         .get();

//     userFeedRef.docs.forEach((doc) => {
//           if (doc.exists)
//             {
//               // Delete each unfollowed user post from current user feed
//               doc.reference.delete()
//             }
//         });

//     PostModel post = PostModel(
//       authorId: userId,
//     );

//     deleteActivityItem(
//       comment: null,
//       currentUserId: currentUserId,
//       isFollowEvent: true,
//       post: post,
//       isCommentEvent: false,
//       isLikeEvent: false,
//       isLikeMessageEvent: false,
//       isMessageEvent: false,
//     );
//   }

//   static Future<bool> isFollowingUser(
//       {String currentUserId, String userId}) async {
//     DocumentSnapshot followingDoc = await followersRef
//         .doc(userId)
//         .collection(usersFollowers)
//         .doc(currentUserId)
//         .get();

//     return followingDoc.exists;
//   }

//   static Future<int> numFollowing(String userId) async {
//     QuerySnapshot followingSnapshot = await followingRef
//         .doc(userId)
//         .collection(userFollowing)
//         .get();
//     return followingSnapshot.docs.length;
//   }

//   static Future<int> numFollowers(String userId) async {
//     QuerySnapshot followersSnapshot = await followersRef
//         .doc(userId)
//         .collection(usersFollowers)
//         .get();

//     return followersSnapshot.docs.length;
//   }

//   static Future<List<String>> getUserFollowingIds(String userId) async {
//     QuerySnapshot followingSnapshot = await followingRef
//         .doc(userId)
//         .collection(userFollowing)
//         .get();

//     List<String> following =
//         followingSnapshot.docs.map((doc) => doc.id).toList();
//     return following;
//   }

//   // static Future<List<User>> getUserFollowingUsers(String userId) async {
//   //   List<String> followingUserIds = await getUserFollowingIds(userId);
//   //   List<User> followingUsers = [];

//   //   for (var userId in followingUserIds) {
//   //     DocumentSnapshot userSnapshot = await usersRef.doc(userId).get();
//   //     //User user = User.fromDoc(userSnapshot);
//   //     followingUsers.add(user);
//   //   }

//   //   return followingUsers;
//   // }

//   static Future<List<String>> getUserFollowersIds(String userId) async {
//     QuerySnapshot followersSnapshot = await followersRef
//         .doc(userId)
//         .collection(usersFollowers)
//         .get();

//     List<String> followers =
//         followersSnapshot.docs.map((doc) => doc.id).toList();
//     return followers;
//   }

//   static Future<List<PostModel>> getFeedPosts(String userId) async {
//     QuerySnapshot feedSnapshot = await feedsRef
//         .doc(userId)
//         .collection('userFeed')
//         .orderBy('timestamp', descending: true)
//         .get();
//     List<PostModel> posts =
//         feedSnapshot.docs.map((doc) => PostModel.fromDoc(doc)).toList();
//     return posts;
//   }

//   static Future<List<IssueFeedback>> getFeedbacks() async {
//     final _firestore = FirebaseFirestore.instance;

//     QuerySnapshot feedbacksSnapshot =
//         await _firestore.collection('feedbacks').get();
//     List<IssueFeedback> feedbacks = feedbacksSnapshot.docs
//         .map((doc) => IssueFeedback.fromDoc(doc))
//         .toList();
//     return feedbacks;
//   }

//   static Future<List<PostModel>> getAllFeedPosts() async {
//     List<PostModel> allPosts = [];

//     QuerySnapshot usersSnapshot = await usersRef.get();

//     for (var userDoc in usersSnapshot.docs) {
//       QuerySnapshot feedSnapshot = await postsRef
//           .doc(userDoc.id)
//           .collection('userPosts')
//           .orderBy('timestamp', descending: true)
//           .get();

//       for (var postDoc in feedSnapshot.docs) {
//         PostModel post = PostModel.fromDoc(postDoc);
//         allPosts.add(post);
//       }
//     }
//     return allPosts;
//   }

//   static Future<List<PostModel>> getCategoryFeedPosts(
//       // ignore: non_constant_identifier_names
//       String Selectedcategory) async {
//     List<PostModel> allPosts = [];

//     QuerySnapshot usersSnapshot = await usersRef.get();

//     if (Selectedcategory == '🔥 Popular') {
//       for (var userDoc in usersSnapshot.docs) {
//         QuerySnapshot feedSnapshot = await postsRef
//             .doc(userDoc.id)
//             .collection('userPosts')
//             .orderBy('likeCount', descending: true)
//             .get();

//         for (var postDoc in feedSnapshot.docs) {
//           PostModel post = PostModel.fromDoc(postDoc);
//           allPosts.add(post);
//         }
//       }
//       return allPosts;
//     } else {
//       for (var userDoc in usersSnapshot.docs) {
//         QuerySnapshot feedSnapshot = await postsRef
//             .doc(userDoc.id)
//             .collection('userPosts')
//             .where('category', isEqualTo: Selectedcategory)
//             //.orderBy('timestamp', descending: true)
//             .get();

//         for (var postDoc in feedSnapshot.docs) {
//           PostModel post = PostModel.fromDoc(postDoc);
//           allPosts.add(post);
//         }
//       }
//       return allPosts;
//     }
//   }

//   static Future<List<PostModel>> getPostbyId(String postId) async {
//     List<PostModel> allPosts = [];

//     QuerySnapshot usersSnapshot = await usersRef.get();
//     for (var userDoc in usersSnapshot.docs) {
//       DocumentSnapshot feedSnapshot = await postsRef
//           .doc(userDoc.id)
//           .collection('userPosts')
//           .doc(postId)
//           .get();
//       PostModel post = PostModel.fromDoc(feedSnapshot);
//       allPosts.add(post);
//     }
//     return allPosts;
//   }

//   static Future<List<PostModel>> getDeletedPosts(
//       String userId, PostStatus postStatus) async {
//     String collection;
//     postStatus == PostStatus.archivedPost
//         ? collection = 'archivedPosts'
//         : collection = 'deletedPosts';

//     QuerySnapshot feedSnapshot = await postsRef
//         .doc(userId)
//         .collection(collection)
//         .orderBy('timestamp', descending: true)
//         .get();
//     List<PostModel> posts =
//         feedSnapshot.docs.map((doc) => PostModel.fromDoc(doc)).toList();
//     return posts;
//   }

//   static Future<List<PostModel>> getUserPosts(String userId) async {
//     QuerySnapshot userPostsSnapshot = await postsRef
//         .doc(userId)
//         .collection('userPosts')
//         .orderBy('timestamp', descending: true)
//         .get();
//     List<PostModel> posts = userPostsSnapshot.docs
//         .map((doc) => PostModel.fromDoc(doc))
//         .toList();
//     return posts;
//   }

//   static Future<User> getUserWithId(String userId) async {
//     DocumentSnapshot userDocSnapshot = await usersRef.doc(userId).get();
//     if (userDocSnapshot.exists) {
//       //return User.fromDoc(userDocSnapshot);
//     }
//     return User();
//   }

//   static void likePost(
//       {String currentUserId, PostModel post, String receiverToken}) {
//     DocumentReference postRef = postsRef
//         .doc(post.authorId)
//         .collection('userPosts')
//         .doc(post.id);

//     postRef.get().then((doc) {
//       final data = doc.data();
//       int likeCount = data["likeCount"];
//       postRef.update({'likeCount': likeCount + 1});
//       likesRef
//           .doc(post.id)
//           .collection('postLikes')
//           .doc(currentUserId)
//           .set({});
//     });

//     addActivityItem(
//       currentUserId: currentUserId,
//       post: post,
//       comment: post.caption ?? null,
//       isphoto: post.isphoto,
//       isFollowEvent: false,
//       isLikeMessageEvent: false,
//       isLikeEvent: true,
//       isCommentEvent: false,
//       isMessageEvent: false,
//       recieverToken: receiverToken,
//     );
//   }

//   static Future<int> likecount(String postId) async {
//     QuerySnapshot likeSnapshot =
//         await likesRef.doc(postId).collection('postLikes').get();
//     return likeSnapshot.docs.length;
//   }

//   static void unlikePost({String currentUserId, PostModel post}) {
//     likesRef
//         .doc(post.id)
//         .collection('postLikes')
//         .doc(currentUserId)
//         .get()
//         .then((doc) {
//       if (doc.exists) {
//         doc.reference.delete();
//       }
//     });

//     deleteActivityItem(
//       comment: null,
//       currentUserId: currentUserId,
//       isFollowEvent: false,
//       post: post,
//       isphoto: post.isphoto,
//       isCommentEvent: false,
//       isLikeMessageEvent: false,
//       isLikeEvent: true,
//       isMessageEvent: false,
//     );
//   }

//   static Future<bool> didLikePost(
//       {String currentUserId, PostModel post}) async {
//     DocumentSnapshot userDoc = await likesRef
//         .doc(post.id)
//         .collection('postLikes')
//         .doc(currentUserId)
//         .get();
//     return userDoc.exists;
//   }

//   static void commentOnPost(
//       {String currentUserId,
//       PostModel post,
//       String comment,
//       String recieverToken}) {
//     commentsRef.doc(post.id).collection('postComments').add({
//       'content': comment,
//       'authorId': currentUserId,
//       'timestamp': Timestamp.fromDate(DateTime.now())
//     });
//     addActivityItem(
//       currentUserId: currentUserId,
//       post: post,
//       comment: comment,
//       isphoto: post.isphoto,
//       isFollowEvent: false,
//       isLikeMessageEvent: false,
//       isCommentEvent: true,
//       isLikeEvent: false,
//       isMessageEvent: false,
//       recieverToken: recieverToken,
//     );
//   }

//   static void addActivityItem({
//     String currentUserId,
//     PostModel post,
//     String comment,
//     bool isphoto,
//     bool isFollowEvent,
//     bool isCommentEvent,
//     bool isLikeEvent,
//     bool isMessageEvent,
//     bool isLikeMessageEvent,
//     String recieverToken,
//   }) async {
//     final senderUserRef = usersRef.doc(currentUserId);
//     final senderUserSnapshot = await senderUserRef.get();
//     if (!senderUserSnapshot.exists) {
//       return;
//     }

//     final senderUserData = senderUserSnapshot.data();
//     var event;
//     final senderName = senderUserData['name'];
//     var body;

//     // Check for the message event
//     if (isFollowEvent == true) {
//       event = "isFollowEvent";
//       body = "Started follow you!";
//     } else if (isLikeEvent == true) {
//       event = "isLikeEvent";
//       if (comment != null) {
//         body = 'Liked your post: "${comment}"';
//       } else {
//         body = 'Liked your post';
//       }
//     } else if (isCommentEvent == true) {
//       event = "isCommentEvent";
//       body = 'Commented on your post: "${comment}"';
//     } else if (isMessageEvent == true) {
//       event = "isMessageEvent";
//       if (comment != null) {
//         body = 'Sent a message: "${comment}"';
//       } else {
//         body = 'Sent a file message';
//       }
//     } else if (isLikeMessageEvent == true) {
//       event = "isLikeMessageEvent";
//       if (comment != null) {
//         body = 'Liked your message: "${comment}"';
//       } else {
//         body = 'Liked your message file';
//       }
//     }

//     // If there is a receiver token && the message event matches the events above
//     if (recieverToken != null && recieverToken.length > 1 && event != null) {
//       String constructFCMPayload(String token) {
//         return jsonEncode({
//           'token': token,
//           'data': {
//             'title': senderName,
//             'body': body,
//             'image': senderUserData['profileImageUrl'],
//             'click_action': "FLUTTER_NOTIFICATION_CLICK",
//           },
//           'notification': {
//             'title': senderName,
//             'body': body,
//             'image': senderUserData['profileImageUrl'],
//             'click_action': "FLUTTER_NOTIFICATION_CLICK",
//           },
//           // 'options': {
//           //   'priority': "high",
//           //   'timeToLive': 60 * 60 * 24,
//           // }
//         });
//       }

//       // Send push notifications
//       await http.post(
//         Uri.parse('https://api.rnfirebase.io/messaging/send'),
//         headers: <String, String>{
//           'Content-Type': 'application/json; charset=UTF-8',
//         },
//         body: constructFCMPayload(recieverToken),
//       );

//       if (currentUserId != post.authorId) {
//         activitiesRef.doc(post.authorId).collection('userActivities').add({
//           'fromUserId': currentUserId,
//           'postId': post.id,
//           'postImageUrl': post.imageUrl,
//           'comment': comment,
//           'isphoto': post.isphoto,
//           'timestamp': Timestamp.fromDate(DateTime.now()),
//           'isFollowEvent': isFollowEvent,
//           'isCommentEvent': isCommentEvent,
//           'isLikeEvent': isLikeEvent,
//           'isMessageEvent': isMessageEvent,
//           'isLikeMessageEvent': isLikeMessageEvent,
//           'recieverToken': recieverToken,
//         });
//       }
//     }
//   }

//   static void deleteActivityItem(
//       {String currentUserId,
//       PostModel post,
//       String comment,
//       bool isphoto,
//       bool isFollowEvent,
//       bool isCommentEvent,
//       bool isLikeEvent,
//       bool isMessageEvent,
//       bool isLikeMessageEvent}) async {
//     String boolCondition;

//     if (isFollowEvent) {
//       boolCondition = 'isFollowEvent';
//     } else if (isCommentEvent) {
//       boolCondition = 'isCommentEvent';
//     } else if (isLikeEvent) {
//       boolCondition = 'isLikeEvent';
//     } else if (isMessageEvent) {
//       boolCondition = 'isMessageEvent';
//     } else if (isLikeMessageEvent) {
//       boolCondition = 'isLikeMessageEvent';
//     }

//     QuerySnapshot activities = await activitiesRef
//         .doc(post.authorId)
//         .collection('userActivities')
//         .where('fromUserId', isEqualTo: currentUserId)
//         .where('postId', isEqualTo: post.id)
//         .where(boolCondition, isEqualTo: true)
//         .get();

//     activities.docs.forEach((element) {
//       activitiesRef
//           .doc(post.authorId)
//           .collection('userActivities')
//           .doc(element.id)
//           .delete();
//     });
//   }

//   static Future<List<Activity>> getActivities(String userId) async {
//     QuerySnapshot userActivitiesSnapshot = await activitiesRef
//         .doc(userId)
//         .collection('userActivities')
//         .orderBy('timestamp', descending: true)
//         .get();
//     // List<Activity> activity = userActivitiesSnapshot.docs
//     //     .map((doc) => Activity.fromJson(doc))
//     //     .toList();
//     //return activity;
//   }

//   static Future<PostModel> getUserPost(String userId, String postId) async {
//     DocumentSnapshot postDocSnapshot = await postsRef
//         .doc(userId)
//         .collection('userPosts')
//         .doc(postId)
//         .get();
//     return PostModel.fromDoc(postDocSnapshot);
//   }
// }
