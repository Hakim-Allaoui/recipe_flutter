import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:recipe_flutter_provider/constant/static_string.dart';
import 'package:recipe_flutter_provider/firebase_options.dart';
import 'package:recipe_flutter_provider/screens/recipe_detail_screen.dart';

class Tools {
  static init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    await MobileAds.instance.initialize();
    MobileAds.instance.updateRequestConfiguration(
      RequestConfiguration(testDeviceIds: ["CAFF45EA5F86096123D3F220A8CA6A3E"]),
    );

    final remoteConfig = FirebaseRemoteConfig.instance;

    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(hours: 1),
    ));

    StaticString.interInterval = await getIntFromRemote('inter_every');
    debugPrint("interstitial interval: ${StaticString.interInterval}");

    configureCloudMessaging();
  }

  static Future<int> getIntFromRemote(String key) async {
    final remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.fetchAndActivate();
    return remoteConfig.getInt(key);
  }

  static Future<String> getStringFromRemote(String key) async {
    final remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.fetchAndActivate();
    return remoteConfig.getString(key);
  }

  static configureCloudMessaging() async {
    final notificationSettings =
        await FirebaseMessaging.instance.requestPermission(provisional: true);

    final apnsToken = await FirebaseMessaging.instance.getAPNSToken();
    if (apnsToken != null) {
      // APNS token is available, make FCM plugin API requests...
    }

    // await FirebaseMessaging.instance.setAutoInitEnabled(true);
    final fcmToken = await FirebaseMessaging.instance.getToken();
    debugPrint("fcmToken: $fcmToken");
  }
}
