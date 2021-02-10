import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_app/src/app.dart';
import 'package:social_app/src/providers/posts_provider.dart';

import 'package:provider/provider.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
       ChangeNotifierProvider<PostsProvider>(
         create: (_) => PostsProvider(),
       ),
      ],
      child: App(),
    ),
  );
}
