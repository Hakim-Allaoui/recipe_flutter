import 'package:flutter/material.dart';

import '../constant/app_images.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            width: screenSize.width,
            height: screenSize.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppImages.splashBg),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            heightFactor: 3,
            child: Image.asset(
              AppImages.appLogo,
              width: screenSize.width / 2,
            ),
          ),
        ],
      ),
    );
  }
}
