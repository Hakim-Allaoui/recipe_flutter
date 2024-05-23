import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:recipe_flutter_provider/provider/auth.dart';
import 'package:recipe_flutter_provider/provider/theme_provider.dart';
import './../constant/static_string.dart';

class GoogleAdmob extends StatefulWidget {
  GoogleAdmob({Key? key}) : super(key: key);

  @override
  _GoogleAdmobState createState() => _GoogleAdmobState();
}

class _GoogleAdmobState extends State<GoogleAdmob> {
  BannerAd? myBanner;

  // static bool isAdShow = true;
  double bannerHeight = 0.0;
  bool _isLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("GoogleAdmob DIDCHANGE Called");
  }

  @override
  void dispose() {
    disposeBanner();
    super.dispose();
  }

  // static loadAd() {
  //   if (Provider.of(context)) {
  //     print("LOAD BANNER");
  //     load();
  //     bannerHeight = 50.0;
  //   } else {
  //     print(" DISPOSE BANNER ");
  //     disposeBanner();
  //     bannerHeight = 0.0;
  //   }
  // }

  load() {
    myBanner = buildBannerAd();
    myBanner!.load();
  }

  BannerAd buildBannerAd() {
    return BannerAd(
      adUnitId: Platform.isAndroid
          ? StaticString.addMobAndroidBannerUnitId
          : StaticString.addMobiOSBannerUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      // targetingInfo: MobileAdTargetingInfo(),
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          debugPrint('$ad loaded.');
          bannerHeight = 50.0;
          // myBanner!.show(anchorOffset: 0.0, horizontalCenterOffset: 0.0);

          // setState(() {
          //   _isLoaded = true;
          // });
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (ad, err) {
          debugPrint('BannerAd failed to load: $err');
          myBanner!.dispose();
          bannerHeight = 0.0;
          ad.dispose();
        },
      ),
    );
  }

  disposeBanner() {
    try {
      myBanner!.dispose();
      myBanner = null;
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    print("GoogleAdmob`s BUILD  called");
    if (Provider.of<AuthProvider>(context).getAdmobStatus == true &&
        myBanner == null) {
      print("true");
      load();
      bannerHeight = 50.0;
    } else if (Provider.of<AuthProvider>(context).getAdmobStatus == false) {
      print("false");
      disposeBanner();
      myBanner = null;
      bannerHeight = 0.0;
    }
    ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);
    return AnimatedContainer(
      duration: Duration(milliseconds: 250),
      height: bannerHeight,
      width: double.infinity,
      color:
          themeNotifier.getTheme() == lightTheme ? Colors.white : Colors.black,
      child: AdWidget(
        ad: myBanner!,
      ),
    );
  }
}

class AdmobInterstitialHelper {
  static InterstitialAd? _interstitialAd;
  static int _numInterstitialLoadAttempts = 0;
  static int maxFailedLoadAttempts = 3;

  static Future<void> loadAd() async {
    await InterstitialAd.load(
      adUnitId: Platform.isAndroid
          ? StaticString.addMobAndroidInterUnitId
          : StaticString.addMobiOSInterUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          debugPrint('$ad loaded.');

          ad.fullScreenContentCallback = FullScreenContentCallback(
              // Called when the ad showed the full screen content.
              onAdShowedFullScreenContent: (ad) {},
              // Called when an impression occurs on the ad.
              onAdImpression: (ad) {},
              // Called when the ad failed to show full screen content.
              onAdFailedToShowFullScreenContent: (ad, err) {
                // Dispose the ad here to free resources.
                ad.dispose();
              },
              // Called when the ad dismissed full screen content.
              onAdDismissedFullScreenContent: (ad) {
                // Dispose the ad here to free resources.
                ad.dispose();
                loadAd();
              },
              // Called when a click is recorded for an ad.
              onAdClicked: (ad) {});
          _interstitialAd = ad;
          _interstitialAd!.setImmersiveMode(true);
          _numInterstitialLoadAttempts = 0;
          // Keep a reference to the ad so you can show it later.
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('InterstitialAd failed to load: $error');
          _numInterstitialLoadAttempts += 1;

          _interstitialAd = null;
          if (_numInterstitialLoadAttempts < maxFailedLoadAttempts) {
            loadAd();
          }
        },
      ),
    );
  }

  static void showInterstitialAd() {
    if (StaticString.interInterval % 3 != 0) {
      StaticString.interInterval++;
      return;
    }

    StaticString.interInterval = 1;

    if (_interstitialAd == null) {
      print('Warning: attempt to show interstitial before loaded.');
      return;
    }

    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        loadAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        loadAd();
      },
    );
    _interstitialAd!.show();
    _interstitialAd = null;
  }
}
