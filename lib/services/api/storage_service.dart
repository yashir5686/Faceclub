// import 'dart:io';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter_image_compress/flutter_image_compress.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:uuid/uuid.dart';
// import 'package:instagrampub/utilities/constants.dart';
// import 'package:path/path.dart' as Path;

// class StroageService {
//   static Future<String> uploadUserProfileImage(
//       String url, File imageFile) async {
//     String photoId = Uuid().v4();

//     if (url.isNotEmpty) {
//       //Updating user profile image
//       RegExp exp = RegExp(r'userProfile_(.*).jpg');
//       photoId = exp.firstMatch(url)[1];
//     }
//     File image = await compressImage(photoId, imageFile);
//     UploadTask uploadTask = storageRef
//         .child('images/users/userProfile_$photoId.jpg')
//         .putFile(image);
//     TaskSnapshot storageSnap = uploadTask.snapshot;
//     String downloadUrl = await storageSnap.ref.getDownloadURL();
//     return downloadUrl;
//   }

//   static Future<File> compressImage(String photoId, File image) async {
//     final tempDir = await getTemporaryDirectory();
//     final path = tempDir.path;
//     File compressedImageFile = await FlutterImageCompress.compressAndGetFile(
//       image.absolute.path,
//       '$path/img_$photoId.jpg',
//       quality: 70,
//     );
//     return compressedImageFile;
//   }

//   static Future<String> _uploadImage(
//       String path, String imageId, File image) async {
//     UploadTask uploadTask = storageRef.child(path).putFile(image);
//     TaskSnapshot storageSnap = uploadTask.snapshot;
//     String downloadUrl = await storageSnap.ref.getDownloadURL();
//     return downloadUrl;
//   }

//   static Future<String> uploadPost(File imageFile) async {
//     String photoId = Uuid().v4();
//     File image = await compressImage(photoId, imageFile);
//     UploadTask uploadTask =
//         storageRef.child('images/posts/post_$photoId.jpg').putFile(image);
//     TaskSnapshot storageSnap = uploadTask.snapshot;
//     String downloadUrl = await storageSnap.ref.getDownloadURL();
//     return downloadUrl;
//   }

//   // ignore: unused_element
//   static Future<String> _uploadVideo(
//       String path, String imageId, File image) async {
//     UploadTask uploadTask = storageRef.child(path).putFile(image);
//     TaskSnapshot storageSnap = uploadTask.snapshot;
//     // ignore: non_constant_identifier_names
//     String VideodownloadUrl = await storageSnap.ref.getDownloadURL();
//     return VideodownloadUrl;
//   }

//   static Future<String> uploadVideoPost(File imageFile) async {
//     String photoId = Uuid().v4();
//     // ignore: await_only_futures
//     File image = await imageFile;
//     UploadTask uploadTask =
//         storageRef.child('images/posts/post_$photoId.mp4').putFile(image);
//     TaskSnapshot storageSnap = uploadTask.snapshot;
//     String downloadUrl = await storageSnap.ref.getDownloadURL();
//     return downloadUrl;
//   }

//   static Future<String> uploadMessageImage(File imageFile) async {
//     String imageId = Uuid().v4();
//     File image = await compressImage(imageId, imageFile);

//     String downloadUrl = await _uploadImage(
//       'images/messages/message_$imageId.jpg',
//       imageId,
//       image,
//     );
//     return downloadUrl;
//   }

//   static Future<String> uploadStoryImage(File imageFile) async {
//     String imageId = Uuid().v4();
//     File image = await compressImage(imageId, imageFile);

//     String downloadUrl = await _uploadImage(
//       'images/stories/story_$imageId.jpg',
//       imageId,
//       image,
//     );
//     return downloadUrl;
//   }

//   static Future<String> uploadStoryVideo(File imageFile) async {
//     String imageId = Uuid().v4();
//     File image = imageFile;

//     String downloadUrl = await _uploadImage(
//       'images/stories/story_$imageId.mp4',
//       imageId,
//       image,
//     );
//     return downloadUrl;
//   }

//   // ignore: non_constant_identifier_names
//   static Future<void> deleteStory(String ImageUrl) async {
//     var fileUrl = Uri.decodeFull(Path.basename(ImageUrl)).replaceAll(new RegExp(r'(\?alt).*'), '');


//     final Reference firebaseStorageRef =
//     FirebaseStorage.instance.ref().child(fileUrl);
//     await firebaseStorageRef.delete();
//   }

//   // ignore: non_constant_identifier_names
//   static Future<void> deletepostImage(String ImageUrl) async {
//     var fileUrl = Uri.decodeFull(Path.basename(ImageUrl)).replaceAll(new RegExp(r'(\?alt).*'), '');


//     final Reference firebaseStorageRef =
//     FirebaseStorage.instance.ref().child(fileUrl);
//     await firebaseStorageRef.delete();
//   }
// }
