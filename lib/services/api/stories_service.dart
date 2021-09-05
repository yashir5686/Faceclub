// import 'package:instagrampub/models/models.dart';
// // ignore: unused_import
// import 'package:instagrampub/services/api/database_service.dart';
// import 'package:instagrampub/services/api/storage_service.dart';
// import 'package:instagrampub/utilities/constants.dart';

// class StoriesService {
//   static Future<void> createStory(Story story) async {
//     storiesRef.doc(story.authorId).collection('stories').add({
//       'timeStart': story.timeStart,
//       'timeEnd': story.timeEnd,
//       'authorId': story.authorId,
//       'imageUrl': story.imageUrl,
//       'caption': story.caption,
//       'isphoto': story.isphoto,
//       'views': story.views,
//       'location': story.location,
//       'filter': story.filter,
//       'duration': story.duration,
//       'linkUrl': story.linkUrl,
//     });
//   }

//   static Future<Story> getStoryById(String storyId) async {
//     final storyDocSnapshot =
//         await storiesRef.doc(storyId).get();
//     if (storyDocSnapshot.exists) {
//       return Story.fromDoc(storyDocSnapshot);
//     }
//     return Story();
//   }

//   static Future<List<Story>> getStoriesByUserId(
//       String userId, bool checkDate) async {
//     final DateTime timeNow = DateTime.now();

//     //QuerySnapshot snapshot;
//     List<Story> userStories = [];

//     // if (checkDate) {
//     //   snapshot = await storiesRef
//     //       .doc(userId)
//     //       .collection('stories')
//     //       .where('timeEnd', isGreaterThanOrEqualTo: timeNow)
//     //       .get();
//     // } 
//     // else {
//     //   snapshot = await storiesRef
//     //       .doc(userId)
//     //       .collection('stories')
//     //       .get();
//     // }

//     // if (snapshot.docs.isNotEmpty) {
//     //   for (var doc in snapshot.docs) {
//     //     Story story = Story.fromDoc(doc);
//     //     userStories.add(story);
//     //   }
//     //   return userStories;
//     // }
//     return null;
//   }

//   static Future<List<Story>> getStoriesbyuserid(
//       String userId, bool checkDate) async {
//     final DateTime timeNow = DateTime.now();

//     //QuerySnapshot snapshot;
//     List<Story> userStories = [];

//     // if (checkDate) {
//     //   snapshot = await storiesRef
//     //       .doc(userId)
//     //       .collection('stories')
//     //       .where('timeEnd', isGreaterThanOrEqualTo: timeNow)
//     //       .get();
//     // } 
//     // else {
//     //   snapshot = await storiesRef
//     //       .doc(userId)
//     //       .collection('stories')
//     //       .get();
//     // }

//     // if (snapshot.docs.isNotEmpty) {
//     //   for (var doc in snapshot.docs) {
//     //     Story story = Story.fromDoc(doc);
//     //     userStories.add(story);
//     //   }
//     //   return userStories;
//     // }
//     return null;
//   }


//   static Future<void> deletestory(Story story) async {
//     storiesRef
//         .doc(story.authorId)
//         .collection('stories')
//         .doc(story.id)
//         .delete();
//     StroageService.deleteStory(story.imageUrl);
//   }

//   static void setNewStoryView(String currentUserId, Story story) async {
//     final DateTime timestamp = DateTime.now();
//     Map<dynamic, dynamic> storyViews = story.views;
//     storyViews[currentUserId] = timestamp;

//     final storySnapshot = await storiesRef
//         .doc(story.authorId)
//         .collection('stories')
//         .doc(story.id)
//         .get();

//     Story storyFromDoc = Story.fromDoc(storySnapshot);

//     if (!storyFromDoc.views.containsKey(currentUserId)) {
//       await storiesRef
//           .doc(story.authorId)
//           .collection('stories')
//           .doc(story.id)
//           .update({'views': storyViews});
//     }
//   }
// }
