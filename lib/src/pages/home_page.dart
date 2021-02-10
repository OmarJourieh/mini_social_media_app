import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/src/add_post.dart';
import 'package:social_app/src/auth/login.dart';
import 'package:social_app/src/models/post_model.dart';
import 'package:social_app/src/providers/posts_provider.dart';
import 'package:social_app/src/view_post.dart';

import '../utils/constants.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final databaseReference = FirebaseDatabase.instance.reference();
  int count = 1;
  String dismissType = 'delete';

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: new Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  void initState() {
    super.initState();
    print(databaseReference.path);

    print("All Data:");
    print("----------------");
    databaseReference.once().then((DataSnapshot snapshot) {
      print('Data : ${snapshot.value}');
    });
    print("----------------");
  }

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final postsProvider = Provider.of<PostsProvider>(context);

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddPost(),
              ),
            );
            // postsProvider.addPost(Post(
            //   id: DateTime.now().toString() + auth.currentUser.email,
            //   body: "I would love to see this app working!",
            //   title: "My very second post",
            //   user: auth.currentUser.email,
            //   createdAt: DateTime.now().toString(),
            // ));
          },
          child: Icon(Icons.add),
        ),
        appBar: AppBar(
          title: Text(
            "Social App",
            style: TextStyle(
              fontSize: 30,
            ),
          ),
          // leading: Container(
          //   margin: EdgeInsets.only(left: 5),
          //   child: Icon(
          //     Icons.menu,
          //     size: 30,
          //   ),
          // ),
          actions: [
            FlatButton.icon(
              textColor: Theme.of(context).canvasColor,
              icon: Icon(
                Icons.logout,
              ),
              label: Text(
                "Logout",
                style: TextStyle(fontFamily: fontFamily2),
              ),
              onPressed: () {
                print("Go then");
                auth.signOut().then(
                      (value) => Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => LoginScreen(),
                        ),
                      ),
                    );
              },
            ),
            SizedBox(
              width: 5,
            ),
          ],
        ),
        body: FutureBuilder(
          future: postsProvider.getAllPosts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.none &&
                    snapshot.hasData == null ||
                snapshot.data == null) {
              //print('project snapshot data is: ${projectSnap.data}');
              return Center(
                child: SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(),
                ),
              );
            }
            var data = snapshot.data;
            return ListView.builder(
              itemCount: snapshot.data == null ? 0 : snapshot.data.length,
              itemBuilder: (context, index) {
                return Container(
                  color: Theme.of(context).backgroundColor,
                  margin: EdgeInsets.fromLTRB(10, 5, 10, 0),
                  child: (data[index].user == auth.currentUser.email)
                      ? Dismissible(
                          direction: DismissDirection.horizontal,
                          background: _slideRightBackground(),
                          secondaryBackground: _slideLeftBackground(),
                          confirmDismiss: (DismissDirection direction) async {
                            if (direction == DismissDirection.endToStart) {
                              return await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text("Confirm"),
                                    content: const Text(
                                        "Are you sure you wish to delete this item?"),
                                    actions: <Widget>[
                                      FlatButton(
                                          onPressed: () {
                                            postsProvider
                                                .deletePost(data[index]);
                                            print("deleting...");
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text("DELETE")),
                                      FlatButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text("CANCEL"),
                                      ),
                                    ],
                                  );
                                },
                              );
                            } else if (direction ==
                                DismissDirection.startToEnd) {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => AddPost(post: data[index],)));
                                }
                          },
                          onDismissed: (value) {},
                          key: UniqueKey(),
                          child: InkWell(
                            onTap: () {
                              _viewPost(data[index]);
                              print("Dismiss me 111!");
                            },
                            child: ListTile(
                              title: Container(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: RichText(
                                  text: TextSpan(children: [
                                    TextSpan(
                                      text: data[index].title + "\n",
                                      style: TextStyle(
                                        fontSize: 25,
                                      ),
                                    ),
                                    TextSpan(
                                      text: "by: " + data[index].user,
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ]),
                                ),
                              ),
                              subtitle: Container(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Divider(),
                                    SizedBox(height: 15),
                                    Text(
                                      data[index].body,
                                      style: TextStyle(
                                        fontFamily: fontFamily2,
                                        color: Theme.of(context).canvasColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      : InkWell(
                          onTap: () {
                            _viewPost(data[index]);
                          },
                          child: ListTile(
                            title: Container(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: RichText(
                                text: TextSpan(children: [
                                  TextSpan(
                                    text: data[index].title + "\n",
                                    style: TextStyle(
                                      fontSize: 25,
                                    ),
                                  ),
                                  TextSpan(
                                    text: "by: " + data[index].user,
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                ]),
                              ),
                            ),
                            subtitle: Container(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Divider(),
                                  SizedBox(height: 15),
                                  Text(
                                    data[index].body,
                                    style: TextStyle(
                                      fontFamily: fontFamily2,
                                      color: Theme.of(context).canvasColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _slideRightBackground() {
    dismissType = 'edit';
    return Container(
      color: Colors.green,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 20,
            ),
            Icon(
              Icons.edit,
              color: Colors.white,
            ),
            Text(
              " Edit",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.left,
            ),
          ],
        ),
        alignment: Alignment.centerLeft,
      ),
    );
  }

  Widget _slideLeftBackground() {
    dismissType = 'delete';
    return Container(
      color: Colors.red,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
            Text(
              " Delete",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.right,
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
        alignment: Alignment.centerRight,
      ),
    );
  }

  Widget _showAlertDialog(
      BuildContext context, Function callbackNo, Function callbackYes) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: callbackNo,
    );
    Widget continueButton = FlatButton(
      child: Text("Continue"),
      onPressed: callbackYes,
    );

    // set up the AlertDialog
    return AlertDialog(
      title: Text("AlertDialog"),
      content: Text(
          "Would you like to continue learning how to use Flutter alerts?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // // show the dialog
    // showDialog(
    //   context: context,
    //   builder: (BuildContext context) {
    //     return alert;
    //   },
    // );
  }

  _viewPost(Post post) {
    Navigator.push(
      context,
      PageRouteBuilder(
          opaque: false,
          transitionDuration: Duration(milliseconds: 500),
          transitionsBuilder: (BuildContext context,
              Animation<double> firstAnim,
              Animation<double> secondAnim,
              Widget child) {
            firstAnim =
                CurvedAnimation(parent: firstAnim, curve: Curves.easeOut);
            return ScaleTransition(
              scale: firstAnim,
              child: child,
              alignment: Alignment.center,
            );
          },
          pageBuilder: (BuildContext context, Animation<double> firstAnim,
              Animation<double> secondAnim) {
            return ShowPost(post: post);
          }),
    );
  }
}
