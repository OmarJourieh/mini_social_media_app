import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_app/src/auth/login.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  Animation _delayedAnimation;
  Animation _delayedAnimation2;
  Animation _delayedAnimation3;
  AnimationController _delayedAnimationController;
  String _email, _password;

  @override
  void initState() {
    super.initState();
    _delayedAnimationController =
        AnimationController(duration: Duration(seconds: 2), vsync: this);

    _delayedAnimation = Tween(begin: -0.5, end: 0.0).animate(
      CurvedAnimation(
        parent: _delayedAnimationController,
        curve: Interval(
          0.2,
          1.0,
          curve: Curves.fastOutSlowIn,
        ),
      ),
    );

    _delayedAnimation2 = Tween(begin: -0.5, end: 0.0).animate(
      CurvedAnimation(
        parent: _delayedAnimationController,
        curve: Interval(
          0.3,
          1.0,
          curve: Curves.fastOutSlowIn,
        ),
      ),
    );

    _delayedAnimation3 = Tween(begin: -0.5, end: 0.0).animate(
      CurvedAnimation(
        parent: _delayedAnimationController,
        curve: Interval(
          0.0,
          1.0,
          curve: Curves.bounceOut,
        ),
      ),
    );

    _delayedAnimationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Create new account",
          style: TextStyle(fontSize: 25),
        ),
      ),
      body: SingleChildScrollView(child: _registerForm(context)),
    );
  }

  Widget _registerForm(context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    final auth = FirebaseAuth.instance;

    return AnimatedBuilder(
      animation: _delayedAnimationController,
      builder: (context, Widget child) {
        return Column(
          children: [
            SizedBox(
              height: 70,
            ),
            Transform(
              transform: Matrix4.translationValues(
                  0, _delayedAnimation.value * height, 0),
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
                  0, _delayedAnimation2.value * height, 0),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 45, vertical: 10),
                child: TextField(
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Password",
                  ),
                  onChanged: (value) {
                    print(value);
                    setState(() {
                      _password = value.trim();
                    });
                  },
                ),
              ),
            ),
            Transform(
              transform: Matrix4.translationValues(
                  0, _delayedAnimation3.value * height, 0),
              child: Container(
                margin: EdgeInsets.fromLTRB(0, 35, 0, 0),
                child: FlatButton(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  onPressed: () {
                    print(_email);
                    print(_password);
                    auth
                        .createUserWithEmailAndPassword(
                            email: _email, password: _password)
                        .then(
                          (value) => Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen(message: "Registered Successfully! Go Ahead and Sing in!",)),
                              (route) => false),
                        );
                  },
                  child: Text(
                    "Sign up",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  color: Theme.of(context).canvasColor,
                  textColor: Theme.of(context).primaryColor,
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
          ],
        );
      },
    );
  }
}
