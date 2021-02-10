import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_app/src/models/post_model.dart';

class PostsProvider with ChangeNotifier {
  final CollectionReference postsCollection = FirebaseFirestore.instance
      .collection('posts'); //searches or creates the posts collection
  final CollectionReference postsRef =
      FirebaseFirestore.instance.collection('/posts');

  Future getAllPosts() async {
    QuerySnapshot allPosts = await postsRef.get();

    var shot = allPosts.docs.map((e) => Post(
          id: e.data()['id'],
          body: e.data()['body'],
          title: e.data()['title'],
          user: e.data()['user'],
          createdAt: e.data()['createdAt'],
          image: e.data()['image'],
        )).toList();
        
    return shot;
  }

  Post getSinglePost(String id) {}

  void addPost(Post post) async {
    await postsRef.doc(post.id).set(post.toJson());

    notifyListeners();
  }

  void updatePost(Post post) async {
    await postsRef.doc(post.id).set(post.toJson());

    notifyListeners();
  }

  void deletePost(Post post) async {
    await postsRef.doc(post.id).delete();

    notifyListeners();
  }
}
