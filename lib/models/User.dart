import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

List<User> userListFromJson(String str) => List<User>.from(json.decode(str).map((x) => User.fromJson(x)));

String userToJson(User data) => json.encode(data.toJson());

class User {
    User({
        this.id,
        this.displayname,
        this.email,
        this.isBanned,
        this.isVerified,
        this.name,
        this.profileImageUrl,
        this.role,
        this.timeCreated,
        this.token,
        this.bio,
        this.website,
    });

    String id;
    String displayname;
    String email;
    bool isBanned;
    bool isVerified;
    String name;
    String profileImageUrl;
    String role;
    DateTime timeCreated;
    String token;
    String bio;
    String website;

    factory User.fromJson(Map json) => User(
        id: json["userid"],
        displayname: json["displayname"],
        email: json["email"],
        isBanned: json["isBanned"] == 0 ? false : true,
        isVerified: json["isVerified"] == 0 ? true : false,
        name: json["name"],
        profileImageUrl: json["profileImageUrl"],
        role: json["role"],
        timeCreated: DateTime.parse(json["timeCreated"]),
        token: json["token"],
        bio: json["bio"],
        website: json["website"],
    );

    Map<String, dynamic> toJson() => {
        "userid": id,
        "displayname": displayname,
        "email": email,
        "isBanned": isBanned,
        "isVerified": isVerified,
        "name": name,
        "profileImageUrl": profileImageUrl,
        "role": role,
        "timeCreated": timeCreated.toIso8601String(),
        "token": token,
        "bio": bio,
        "website": website,
    };
}
