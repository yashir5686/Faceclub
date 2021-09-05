// import 'package:flutter/cupertino.dart';
// import 'package:instagrampub/models/User.dart';
// import 'package:instagrampub/models/models.dart';
// import 'package:instagrampub/models/models.dart';
// import 'package:instagrampub/models/post.dart';
// import 'package:instagrampub/utilities/constants.dart';
// import 'package:provider/provider.dart';

// class ChatService {
//   static Future<Chat> createChat(List<User> users, List<String> userIds) async {
//     Map<String, dynamic> readStatus = {};

//     for (User user in users) {
//       readStatus[user.id] = false;
//     }

//     DateTime timestamp = DateTime.now();

//     final res = await chatsRef.add({
//       'recentMessage': 'Chat Created',
//       'recentSender': '',
//       'recentTimestamp': timestamp,
//       'memberIds': userIds,
//       'readStatus': readStatus,
//     });

//     return Chat(
//       id: res.id,
//       recentMessage: 'Chat Created',
//       recentSender: '',
//       recentTimestamp: timestamp,
//       memberIds: userIds,
//       readStatus: readStatus,
//       memberInfo: users,
//     );
//   }

//   static void sendChatMessage(
//       Chat chat, Message message, User receiverUser) async {
//     chatsRef.doc(chat.id).collection('messages').add({
//       'senderId': message.senderId,
//       'text': message.text,
//       'imageUrl': message.imageUrl,
//       'timestamp': message.timestamp,
//       'isLiked': message.isLiked ?? false,
//       'giphyUrl': message.giphyUrl,
//     });

//     final chatRef = chatsRef.doc(chat.id);
//     // Get chat document
//     final chatDoc = await chatRef.get();
//     final chatData = chatDoc.data();

//     if (chatDoc.exists) {
//       final readStatus = chatData['readStatus'];
//       // Update read status to false
//       for (var userId in readStatus) {
//         if (
//           readStatus.hasOwnProperty(userId) &&
//           userId != message.senderId
//         ) {
//           chatsRef.doc(chat.id).update({
//         'readStatus.$userId': false,
//       });
//         }
//       }

//       // Update the chat doc
//       chatRef.update({
//         "recentMessage": message.text,
//         "recentSender": message.senderId,
//         "recentTimestamp": message.timestamp,
//       });
//     }

//     PostModel post = PostModel(
//       authorId: receiverUser.id,
//     );

//     // DatabaseService.addActivityItem(
//     //   comment: message.text,
//     //   currentUserId: message.senderId,
//     //   isCommentEvent: false,
//     //   isFollowEvent: false,
//     //   isLikeEvent: false,
//     //   isMessageEvent: true,
//     //   post: post,
//     //   recieverToken: receiverUser.token,
//     // );
//   }

//   static void deleteChatMessage(Chat chat, Message message) {
//     chatsRef
//         .doc(chat.id)
//         .collection('messages')
//         .doc(message.id)
//         .delete();
//   }

//   static void setchatRead(BuildContext context, Chat chat, bool read) async {
//     String currentUserId =
//         Provider.of<UserData>(context, listen: false).currentUserId;
//     chatsRef.doc(chat.id).update({
//       'readStatus.$currentUserId': read,
//     });
//   }

//   // static Future<bool> checkIfChatExist(List<String> users) async {
//   //   print(users);
//   //   QuerySnapshot snapshot = await chatsRef
//   //       .where('memberIds', arrayContainsAny: users)
//   //       .get();

//   //   return snapshot.docs.isNotEmpty;
//   // }

//   static Future<Chat> getChatById(String chatId) async {
//     final chatDocSnapshot = await chatsRef.doc(chatId).get();
//     if (chatDocSnapshot.exists) {
//       return Chat.fromDoc(chatDocSnapshot);
//     }
//     return Chat();
//   }

//   static Future<Chat> getChatByUsers(List<String> users) async {
//     final snapshot = await chatsRef.where('memberIds', whereIn: [
//       [users[1], users[0]]
//     ]).get();

//     if (snapshot.docs.isEmpty) {
//       final snapshot = await chatsRef.where('memberIds', whereIn: [
//         [users[0], users[1]]
//       ]).get();
//     }

//     if (snapshot.docs.isNotEmpty) {
//       return Chat.fromDoc(snapshot.docs[0]);
//     }
//     return null;
//   }

//   static Future<Null> likeUnlikeMessage(Message message, String chatId,
//       bool isLiked, User receiverUser, String currentUserId) {
//     // chatsRef
//     //     .doc(chatId)
//     //     .collection('messages')
//     //     .doc(message.id)
//     //     .update({'isLiked': isLiked});

//     Post post = Post(
//       authorId: receiverUser.id,
//     );

//     // if (isLiked == true) {
//     //   DatabaseService.addActivityItem(
//     //     comment: message.text ?? null,
//     //     currentUserId: currentUserId,
//     //     isCommentEvent: false,
//     //     isFollowEvent: false,
//     //     isLikeEvent: false,
//     //     isMessageEvent: false,
//     //     isLikeMessageEvent: true,
//     //     post: post,
//     //     recieverToken: receiverUser.token,
//     //   );
//     // } else {
//     //   DatabaseService.deleteActivityItem(
//     //     comment: message.text ?? null,
//     //     currentUserId: currentUserId,
//     //     isFollowEvent: false,
//     //     post: post,
//     //     isCommentEvent: false,
//     //     isLikeEvent: false,
//     //     isLikeMessageEvent: true,
//     //     isMessageEvent: false,
//     //   );
//     // }
//     return null;
//   }
// }
