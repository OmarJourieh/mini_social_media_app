import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/src/providers/posts_provider.dart';
import 'package:social_app/src/utils/constants.dart';

import 'models/post_model.dart';

class AddPost extends StatefulWidget {
  Post post;
  bool hasPost = false;

  AddPost({this.post, this.hasPost});

  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  String title;
  String body;
  bool isSubmitted = false;

  @override
  Widget build(BuildContext context) {
    Post post = widget.post;
    if (post != null) {
      title = post.title;
      body = post.body;
      widget.hasPost = true;
    } else {
      widget.hasPost = false;
    }
    final auth = FirebaseAuth.instance;
    final postsProvider = Provider.of<PostsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: post != null
            ? Text(
                "Edit Post",
                style: TextStyle(
                  fontSize: 25,
                ),
              )
            : Text(
                "New Post",
                style: TextStyle(
                  fontSize: 25,
                ),
              ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                child: TextField(
                  controller: post != null
                      ? (TextEditingController()..text = post.title)
                      : null,
                  onChanged: (value) {
                    title = value;
                  },
                  style: TextStyle(fontSize: 20, fontFamily: fontFamily2),
                  decoration: InputDecoration(
                    labelStyle: TextStyle(fontFamily: fontFamily1),
                    labelText: "Title",
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 30),
                child: TextField(
                  controller: post != null
                      ? (TextEditingController()..text = post.body)
                      : null,
                  onChanged: (value) {
                    body = value;
                  },
                  style: TextStyle(fontSize: 20, fontFamily: fontFamily2),
                  keyboardType: TextInputType.multiline,
                  maxLines: 6,
                  maxLength: 200,
                  scrollController: ScrollController(),
                  decoration: InputDecoration(
                    labelText: "Say something",
                    labelStyle: TextStyle(fontFamily: fontFamily1),
                    alignLabelWithHint: true,
                  ),
                ),
              ),
              SizedBox(height: 30),
              Container(
                child: FlatButton(
                  padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                  color: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 1,
                      style: BorderStyle.solid,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  onPressed: () {
                    if (body.length > 0 && title.length > 0) {
                      isSubmitted = true;
                      if (widget.hasPost == false) {
                        postsProvider.addPost(Post(
                          id: DateTime.now().toString() +
                              auth.currentUser.email,
                          body: body,
                          title: title,
                          user: auth.currentUser.email,
                          createdAt: DateTime.now().toString(),
                        ));
                      } else {
                        postsProvider.updatePost(Post(
                          id: post.id,
                          body: body,
                          title: title,
                          user: auth.currentUser.email,
                          createdAt: post.createdAt,
                        ));
                      }
                      Navigator.pop(context);
                    }
                  },
                  child: isSubmitted
                      ? CircularProgressIndicator(
                          backgroundColor: Theme.of(context).canvasColor,
                        )
                      : Text(
                          "Post",
                          style: TextStyle(
                            fontFamily: fontFamily1,
                            fontSize: 25,
                            color: Theme.of(context).canvasColor,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
