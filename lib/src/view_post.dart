import 'package:flutter/material.dart';
import 'package:social_app/src/models/post_model.dart';
import 'package:social_app/src/utils/constants.dart';

class ShowPost extends StatefulWidget {
  Post post;

  ShowPost({this.post});

  @override
  _ShowPostState createState() => _ShowPostState();
}

class _ShowPostState extends State<ShowPost> {
  @override
  Widget build(BuildContext context) {
    Post post = widget.post;
    return Dismissible(
      direction: DismissDirection.vertical,
      onDismissed: (value) {
        Navigator.pop(context);
      },
      key: UniqueKey(),
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.arrow_downward),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Theme.of(context).cardColor,
        body: SafeArea(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(20, 30, 20, 10),
                // color: Theme.of(context).backgroundColor,
                child: ListTile(
                  title: Text(
                    post.title,
                    style: TextStyle(
                        fontSize: 30,
                        color: textColor1,
                        fontFamily: fontFamily2),
                  ),
                  subtitle: Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Text(
                      "by: " + post.user,
                      style:
                          TextStyle(color: textColor3, fontFamily: fontFamily2),
                    ),
                  ),
                ),
              ),
              Divider(
                color: textColor1,
                indent: 40,
                endIndent: 40,
                height: 40,
              ),
              Container(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                child: ListTile(
                  title: Text(
                    post.body,
                    style: TextStyle(
                        fontSize: 20,
                        color: textColor3,
                        fontFamily: fontFamily2),
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
