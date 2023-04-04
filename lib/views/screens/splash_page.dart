import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  moveForward() async {
    await Future.delayed(const Duration(seconds: 3));
    Navigator.of(context).pushReplacementNamed("/login_page");
  }

  @override
  void initState() {
  moveForward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const Spacer(flex: 1,),
          const Expanded(
            flex: 2,
            child: ClipRRect(
              child: Image(
                image: AssetImage("assets/images/Logo_with_gif.gif"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Keep",
                  style: GoogleFonts.poppins(
                      letterSpacing: 2,
                      fontSize: 26,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  " Notes",
                  style: GoogleFonts.poppins(
                      letterSpacing: 1,
                      fontSize: 22,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
