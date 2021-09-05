import 'dart:io';
import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:instagrampub/models/User.dart';
import 'package:instagrampub/models/post.dart';
import 'package:instagrampub/utilities/constants.dart';

class SQLDatabase {
  static final FirebaseMessaging _messaging = FirebaseMessaging();

  static getUserbyId(String userid) async {
    String id = userid;
    http.Response response = await http.get(Uri.parse(
        "https://bawratest.000webhostapp.com/getuserbyid.php/?id=$id"));
    String stringResponse = response.body;
    return stringResponse;
  }

  static Future createUser(
      String name, String email, String token, String userid) async {
    var url = 'https://bawratest.000webhostapp.com/createuser.php';
    final response = await http.post(url, body: {
      'userid': userid,
      'name': name,
      'email': email,
      'token': token,
    });
  }

  static Future updateTokenwithUser(
    String currentuserid,
  ) async {
    final token = await _messaging.getToken();
    var url =
        'https://bawratest.000webhostapp.com/updateusertoken.php/?id=$currentuserid';
    http.post(url, body: {
      'token': token,
    });
  }

  static Future followuser({
    String currentUserId,
    String userId,
    String receiverToken,
  }) async {
    var url = 'https://bawratest.000webhostapp.com/onfollow.php';

    final response = await http.post(url, body: {
      'currentUserId': currentUserId,
      'userid': userId,
      'recieverToken': receiverToken,
    });
  }

  static Future Unfollowuser({
    String currentUserId,
    String userId,
  }) async {
    var url = 'https://bawratest.000webhostapp.com/onunfollow.php';

    final response = await http.post(url, body: {
      'currentUserId': currentUserId,
      'userid': userId,
    });
    if (response.statusCode == 200) {
      print('unfollwed successfully');
    } else {
      print('failed unfollowing');
    }
  }

  static Future countposts(String userid) async {
    String id = userid;
    var url = 'https://bawratest.000webhostapp.com/countuserposts.php/?id=$id';
    http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      String stringResponse = response.body;
      return stringResponse;
    }
  }

  static Future countFollowers(String userid) async {
    String id = userid;
    var url = 'https://bawratest.000webhostapp.com/countfollowers.php/?id=$id';
    http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      String stringResponse = response.body;
      return stringResponse;
    }
  }

  static Future countFollowings(String userid) async {
    String id = userid;
    var url = 'https://bawratest.000webhostapp.com/countfollowings.php/?id=$id';
    http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      String stringResponse = response.body;
      return stringResponse;
    }
  }

  static Future getuserposts(String userid) async {
    String id = userid;
    var url = 'https://bawratest.000webhostapp.com/getuserposts.php/?id=$id';
    http.Response response = await http.get(url);
    String stringresponse = response.body;
    return stringresponse;
  }

  static Future createpost(File imageFile, String currentuserid, String caption,
      String location) async {
    var uri = Uri.parse("https://bawratest.000webhostapp.com/createpost.php");

    var request = http.MultipartRequest(
      "POST",
      uri,
    );
    request.fields['userid'] = currentuserid;
    //request.fields['isphoto'] = isphoto;
    //request.fields['category'] = category;
    request.fields['caption'] = caption;
    request.fields['location'] = location;

    var pic = await http.MultipartFile.fromPath('file', imageFile.path);

    request.files.add(pic);
    final response = await request.send();
  }

  static Future updateUser(User user, File imageFile, String url) async {
    //File imageFile, String url

    var uri = Uri.parse("https://bawratest.000webhostapp.com/updateuser.php");

    var imagepath;
    if (url.isNotEmpty) {
      final picurl = Uri.parse(url);
      imagepath = picurl.path.replaceFirst('/', '');
    }

    final request = http.MultipartRequest('POST', uri);

    request.fields['userid'] = user.id;
    request.fields['name'] = user.name;
    request.fields['bio'] = user.bio;
    request.fields['website'] = user.website;
    request.fields['displayname'] = user.displayname;
    request.fields['oldpic'] = url.isNotEmpty ? imagepath : 'not updated';

    var pic = await http.MultipartFile.fromPath('file', imageFile.path);

    request.files.add(pic);
    final response = await request.send();

    // http.Response.fromStream(response).then((response) {
    //   if (response.statusCode == 200) {
    //     String serverResponse = response.body;
    //     return serverResponse;
    //   }
    // });
  }

  static Future isfollowing(String currentuserid, String userid) async {
    var uri = "https://bawratest.000webhostapp.com/checkisFollowing.php";
    final response = await http.post(
      uri,
      body: {
        'userid': userid,
        'currentuserid': currentuserid,
      },
    );

    String stringresponse = response.body;
    final count = int.parse(stringresponse);

    if (count > 0) {
      return true;
    } else {
      return false;
    }
  }

  static Future searchuser(String term) async {
    var uri = 'https://bawratest.000webhostapp.com/search.php';
    final response = await http.post(
      uri,
      body: {
        'search': term,
      },
    );
    String stringresponse = response.body;
    return stringresponse;
  }

  static Future getexploreposts(String currentuserid) async {
    var id = currentuserid;
    var url = 'https://bawratest.000webhostapp.com/getexploreposts.php/?id=$id';
    http.Response response = await http.get(url);
    String stringresponse = response.body;
    return stringresponse;
  }

  static Future getuserfollowings(String userid) async {
    var url =
        'https://bawratest.000webhostapp.com/getuserfollowings.php/?id=$userid';
    http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      String stringResponse = response.body;
      print(stringResponse);
      return stringResponse;
    }
  }

  static Future getfeedposts(String userid) async {
    String id = userid;
    var url = 'https://bawratest.000webhostapp.com/getfeedposts.php/?id=$id';
    http.Response response = await http.get(url);
    String stringresponse = response.body;
    return stringresponse;
  }

  static Future editpost(Post post, PostStatus postStatus) async {
    var uri = Uri.parse("https://bawratest.000webhostapp.com/editpost.php");

    String table;
    if (postStatus == PostStatus.archivedPost) {
      table = 'archivedposts';
    } else if (postStatus == PostStatus.feedPost) {
      table = 'posts';
    } else {
      table = 'deletedposts';
    }

    final response = await http.post(uri, body: {
      'caption': post.caption,
      'location': post.location,
      'table': table,
      'postid': post.id,
    });
  }

  static Future likepost(Post post, String userid, String recieverToken) async {
    var uri = Uri.parse("https://bawratest.000webhostapp.com/likepost.php");

    final response = await http.post(uri, body: {
      'postid': post.id,
      'userid': userid,
    });
    await addActivity(userid, post, '', 'LIKE', recieverToken);
  }

  static Future unlikepost(Post post, String userid) async {
    var uri = Uri.parse("https://bawratest.000webhostapp.com/unlikepost.php");

    final response = await http.post(uri, body: {
      'postid': post.id,
      'userid': userid,
    });
  }

  static Future isliking(String currentuserid, String postid) async {
    var uri = "https://bawratest.000webhostapp.com/checkisliked.php";
    final response = await http.post(
      uri,
      body: {
        'userid': currentuserid,
        'postid': postid,
      },
    );

    String stringresponse = response.body;
    final count = int.parse(stringresponse);

    if (count > 0) {
      return true;
    } else {
      return false;
    }
  }

  static Future createComment(String currentUserId, Post post, String comment,
      String recieverToken) async {
    var url = 'https://bawratest.000webhostapp.com/createcomment.php';
    final response = await http.post(url, body: {
      'content': comment,
      'authorId': currentUserId,
      'postid': post.id,
    });
    await addActivity(currentUserId, post, comment, 'COMMENT', recieverToken);
  }

  static Future addActivity(
    String currentUserId,
    Post post,
    String comment,
    String type,
    String recieverToken,
  ) async {
    var url = 'https://bawratest.000webhostapp.com/addactivity.php';
    if (currentUserId != post.authorId) {
      final response = await http.post(url, body: {
        'fromUserId': currentUserId,
        'postId': post.id == null ? '' : post.id,
        'userid': post.authorId == null ? '' : post.authorId,
        'postImageUrl': post.imageUrl == null ? '' : post.imageUrl,
        'comment': comment,
        'type': type,
        'recieverToken': recieverToken,
      });
    }
  }

  static Future getpostcomments(String postid) async {
    String id = postid;
    var url = 'https://bawratest.000webhostapp.com/getpostcomments.php/?postid=$id';
    http.Response response = await http.get(url);
    String stringresponse = response.body;
    return stringresponse;
  }

  static Future getActivities(String userid) async {
    String id = userid;
    var url = 'https://bawratest.000webhostapp.com/getuseractivities.php/?id=$id';
    http.Response response = await http.get(url);
    String stringresponse = response.body;
    return stringresponse;
  }

}
