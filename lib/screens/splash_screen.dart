import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                width: 100,
                height: 100,
                child: Image.asset(
                  "assets/images/logo.png",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.center,
              child: Text("Loading..."),
            ),
          ],
        ),
      ),
    );
  }
}
