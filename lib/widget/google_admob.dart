// import 'package:firebase_admob/firebase_admob.dart';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:recipe_flutter_provider/provider/auth.dart';
// import 'package:recipe_flutter_provider/provider/theme_provider.dart';
// import './../constant/static_string.dart';

// // class GoogleAddmob {
// //   static BannerAd myBanner;
// //   // static bool isAdShow = true;
// //   static double bannerHeight = 0.0;

// //   static loadAd() {
// //     if (myBanner == null) {
// //       print("LOAD BANNER");
// //       load();
// //       bannerHeight = 50.0;
// //     } else {
// //       print(" DISPOSE BANNER ");
// //       disposeBanner();

// //       bannerHeight = 0.0;
// //     }
// //   }

// //   static load() {
// //     myBanner = buildBannerAd();
// //     myBanner!.load();
// //   }

// //   static BannerAd buildBannerAd() {
// //     return BannerAd(
// //         adUnitId: BannerAd.testAdUnitId,
// //         size: AdSize.banner,
// //         targetingInfo: MobileAdTargetingInfo(),
// //         listener: (MobileAdEvent event) {
// //           print("Mobile EVENTS : $event");
// //           if (event == MobileAdEvent.loaded && myBanner != null) {
// //             bannerHeight = 50.0;
// //             myBanner!.show(anchorOffset: 0.0, horizontalCenterOffset: 0.0);
// //           } else if (event == MobileAdEvent.failedToLoad) {
// //             myBanner!.dispose();
// //             bannerHeight = 0.0;
// //           }
// //         });
// //   }

// //   static disposeBanner() {
// //     try {
// //       if (myBanner == null) return;

// //       myBanner?.dispose();
// //     } catch (e) {
// //       print(e);
// //     }
// //   }
// // }

// class GoogleAdmob extends StatefulWidget {
//   GoogleAdmob({Key? key}) : super(key: key);

//   @override
//   _GoogleAdmobState createState() => _GoogleAdmobState();
// }

// class _GoogleAdmobState extends State<GoogleAdmob> {

//   BannerAd? myBanner;
//   // static bool isAdShow = true;
//   double bannerHeight = 0.0;

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     print("GoogleAdmob DIDCHANGE Called");
    
//   }
//   @override
//   void dispose() { 
//     disposeBanner();
//     super.dispose();
//   }

//   // static loadAd() {
//   //   if (Provider.of(context)) {
//   //     print("LOAD BANNER");
//   //     load();
//   //     bannerHeight = 50.0;
//   //   } else {
//   //     print(" DISPOSE BANNER ");
//   //     disposeBanner();
//   //     bannerHeight = 0.0;
//   //   }
//   // }

//    load() {
//     myBanner = buildBannerAd();
//     myBanner!.load();
//   }

//    BannerAd buildBannerAd() {
//     return BannerAd(
//         adUnitId: Platform.isAndroid ? StaticString.addMobAndroidBannerUnitId : StaticString.addMobiOSBannerUnitId,
//         size: AdSize.banner,
//         targetingInfo: MobileAdTargetingInfo(),
//         listener: (MobileAdEvent event) {
//           print("Mobile EVENTS : $event");
//           if (event == MobileAdEvent.loaded) {
//             bannerHeight = 50.0;
//             myBanner!.show(anchorOffset: 0.0, horizontalCenterOffset: 0.0);
//           } else if (event == MobileAdEvent.failedToLoad) {
//             myBanner!.dispose();
//             bannerHeight = 0.0;
//           }
//         });
//   }

//    disposeBanner() {
//     try {
//       myBanner!.dispose();
//       myBanner = null;    } catch (e) {
//       print(e);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     print("GoogleAdmob`s BUILD  called");
//     if(Provider.of<AuthProvider>(context).getAdmobStatus == true && myBanner == null){
//       print("true");
//       load();
//       bannerHeight = 50.0;
//     }else if(Provider.of<AuthProvider>(context).getAdmobStatus == false){
//       print("false");
//       disposeBanner();
//       myBanner = null;
//       bannerHeight = 0.0;
//     }
//     ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);
//     return AnimatedContainer(
//             duration: Duration(milliseconds: 250),
//             height: bannerHeight,
//             width: double.infinity,
//             color: themeNotifier.getTheme() == lightTheme
//                 ? Colors.white
//                 : Colors.black,
//           );
//   }
// }
