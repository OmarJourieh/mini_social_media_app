// To parse this JSON data, do
//
//     final Post = PostFromJson(jsonString);

import 'dart:convert';

Post PostFromJson(String str) => Post.fromJson(json.decode(str));

String PostToJson(Post data) => json.encode(data.toJson());

class Post {
  Post({
    this.id,
    this.user,
    this.title,
    this.body,
    this.createdAt,
    this.image,
  });

  String id;
  String user;
  String title;
  String body;
  String createdAt;
  String image;

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        id: json["id"],
        user: json["user"],
        title: json["title"],
        body: json["body"],
        createdAt: json["createdAt"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user,
        "title": title,
        "body": body,
        "createdAt": createdAt,
        "image": image,
      };
}
