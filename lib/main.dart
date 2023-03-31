import 'package:flutter/material.dart';
import 'views/screens/splash_page.dart';
import 'views/screens/login_page.dart';
import 'views/screens/home_page.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
     MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/splash_page",
      routes: {
        "/" : (context) => const HomePage(),
        "/splash_page" : (context) => const SplashPage(),
        "/login_page" : (context) => const LoginPage(),
      },
    ),
  );
}
