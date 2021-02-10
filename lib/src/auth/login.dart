import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_app/src/auth/register.dart';
import 'package:social_app/src/pages/home_page.dart';

class LoginScreen extends StatefulWidget {
  final String message;
  LoginScreen({this.message});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  Animation _delayedAnimation;
  Animation _delayedAnimation2;
  Animation _delayedAnimation3;
  Animation _delayedAnimation4;
  Animation _delayedAnimation5;
  Animation _delayedAnimation6;
  AnimationController _delayedAnimationController;
  String _email, _password;
  bool clickedLogin = false;

  @override
  void initState() {
    super.initState();
    _delayedAnimationController =
        AnimationController(duration: Duration(seconds: 2), vsync: this);

    _delayedAnimation = Tween(begin: -1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _delayedAnimationController,
        curve: Interval(
          0.0,
          1.0,
          curve: Curves.fastOutSlowIn,
        ),
      ),
    );
    _delayedAnimation2 = Tween(begin: -1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _delayedAnimationController,
        curve: Interval(
          0.2,
          1.0,
          curve: Curves.fastOutSlowIn,
        ),
      ),
    );
    _delayedAnimation3 = Tween(begin: -1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _delayedAnimationController,
        curve: Interval(
          0.2,
          1.0,
          curve: Curves.fastOutSlowIn,
        ),
      ),
    );
    _delayedAnimation4 = Tween(begin: -1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _delayedAnimationController,
        curve: Interval(
          0.3,
          1.0,
          curve: Curves.fastOutSlowIn,
        ),
      ),
    );
    _delayedAnimation5 = Tween(begin: -1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _delayedAnimationController,
        curve: Interval(
          0.4,
          1.0,
          curve: Curves.fastOutSlowIn,
        ),
      ),
    );
    _delayedAnimation6 = Tween(begin: -1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _delayedAnimationController,
        curve: Interval(
          0.5,
          1.0,
          curve: Curves.fastOutSlowIn,
        ),
      ),
    );

    _delayedAnimationController.forward();
  }

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
  Widget build(BuildContext context) {
    print(widget.message);

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: _loginForm(context),
          ),
        ),
      ),
    );
  }

  Widget _loginForm(context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    final auth = FirebaseAuth.instance;

    return AnimatedBuilder(
      animation: _delayedAnimationController,
      builder: (context, Widget child) {
        return Column(
          children: [
            SizedBox(height: 70),
            Transform(
              transform: Matrix4.translationValues(
                  _delayedAnimation.value * width, 0.0, 0),
              child: Center(
                child: Container(
                  child: Text(
                    "Social App",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 60,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            SizedBox(height: 50),
            Transform(
              transform: Matrix4.translationValues(
                  -_delayedAnimation2.value * width, 0.0, 0),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 45, vertical: 10),
                child: TextField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: "Email",
                  ),
                  onChanged: (value) {
                    setState(() {
                      _email = value.trim();
                    });
                  },
                ),
              ),
            ),
            Transform(
              transform: Matrix4.translationValues(
                  _delayedAnimation3.value * width, 0.0, 0),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 45, vertical: 10),
                child: TextField(
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Password",
                  ),
                  onChanged: (value) {
                    setState(() {
                      _password = value.trim();
                    });
                  },
                ),
              ),
            ),
            Transform(
              transform: Matrix4.translationValues(
                  -_delayedAnimation4.value * width, 0.0, 0),
              child: Container(
                margin: EdgeInsets.fromLTRB(0, 35, 0, 0),
                child: FlatButton(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  onPressed: () {
                    setState(() {
                      clickedLogin = true;
                    });
                    auth
                        .signInWithEmailAndPassword(
                            email: _email, password: _password)
                        .then(
                          (value) => Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => HomePage(),
                            ),
                          ),
                        );
                  },
                  child: !clickedLogin
                      ? Text(
                          "Sign in",
                          style: TextStyle(
                            fontFamily: 'Parisienne',
                            fontSize: 25,
                          ),
                        )
                      : CircularProgressIndicator(
                          backgroundColor: Theme.of(context).canvasColor,
                        ),
                  color: Theme.of(context).primaryColor,
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 1,
                      style: BorderStyle.solid,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),
            Transform(
              transform: Matrix4.translationValues(
                  _delayedAnimation5.value * width, 0.0, 0),
              child: Container(
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => RegisterScreen()));
                  },
                  child: Text(
                    "Sign up",
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ),
            widget.message != null ? SizedBox(height: 50) : Center(),
            widget.message != null
                ? Transform(
                    transform: Matrix4.translationValues(
                        0.0, -_delayedAnimation5.value * height, 0),
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 45, vertical: 10),
                      padding:
                          EdgeInsets.symmetric(horizontal: 35, vertical: 10),
                      child: Text(
                        widget.message,
                        style: TextStyle(
                          color: Theme.of(context).indicatorColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: Theme.of(context).indicatorColor)),
                    ),
                  )
                : Center(),
          ],
        );
      },
    );
  }
}
