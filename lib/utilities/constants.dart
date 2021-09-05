import 'package:firebase_storage/firebase_storage.dart';
// ignore: unused_import
import 'package:instagrampub/utilities/custom_navigation.dart';
import 'package:intl/intl.dart';

// final _firestore = FirebaseFirestore.instance;
// final storageRef = FirebaseStorage.instance.ref();
// final usersRef = _firestore.collection('users');
// final usernameRef = _firestore.collection('usernames');
// final postsRef = _firestore.collection('posts');
// final followersRef = _firestore.collection('followers');
// final followingRef = _firestore.collection('following');
// final feedsRef = _firestore.collection('feeds');
// final likesRef = _firestore.collection('likes');
// final commentsRef = _firestore.collection('comments');
// final activitiesRef = _firestore.collection('activities');
// final archivedPostsRef = _firestore.collection('archivedPosts');
// final deletedPostsRef = _firestore.collection('deletedPosts');
// final chatsRef = _firestore.collection('chats');
// final storiesRef = _firestore.collection('stories');
// final categoryRef = _firestore.collection('categories');
final String user = 'userFeed';
final String usersFollowers = 'userFollowers';
final String userFollowing = 'userFollowing';
final String placeHolderImageRef = 'assets/images/user_placeholder.jpg';

final DateFormat timeFormat = DateFormat('E, h:mm a');

enum PostStatus {
  feedPost,
  deletedPost,
  archivedPost,
}

enum SearchFrom {
  messagesScreen,
  homeScreen,
  createStoryScreen,
}

enum CameraConsumer {
  post,
  story,
}

bool mute = true;
