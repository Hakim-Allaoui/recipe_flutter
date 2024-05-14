import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';
import 'package:recipe_flutter_provider/provider/theme_provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

import './screens/home_screen.dart';
import './screens/main_auth_screen.dart';
import './screens/login_screen.dart';
import './screens/recipe_detail_screen.dart';
import './screens/category_detail_screen.dart';
import './screens/favorite_screen.dart';
import './screens/profile_screen.dart';
import './screens/forgot_password_screen.dart';

import './provider/auth.dart';
import './provider/category.dart';
import './provider/recipe.dart';
import './provider/user.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual, overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]).then((_) {
    SharedPreferences.getInstance().then((prefs) {
      var darkModeOn = prefs.getBool('darkMode') ?? true;
      runApp(
        MultiProvider(
          providers: [
            ChangeNotifierProvider.value(
              value: AuthProvider(),
            ),
            ChangeNotifierProvider.value(
              value: RecipesProvider(),
            ),
            ChangeNotifierProvider.value(
              value: CategoryProvider(),
            ),
            ChangeNotifierProvider.value(
              value: UserProvider(),
            ),
            ChangeNotifierProvider.value(
              value: ThemeNotifier(darkModeOn ? darkTheme : lightTheme),
            ),
          ],
          child: MyApp(),
        ),
      );
    });
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // FirebaseAdMob.instance.initialize(
    //   appId:
    //       FirebaseAdMob.testAppId, // "ca-app-pub-3940256099942544~1458002511",
    // );
    print('Theme notifier');
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeNotifier.getTheme(),
      home: HomeScreen(false),
      routes: {
        MainAuthScreen.routeName: (ctx) => MainAuthScreen(),
        LoginScreen.routeName: (ctx) => LoginScreen(),
        HomeScreen.routeName: (ctx) => HomeScreen(false),
        RecipeDetailScreen.routeName: (ctx) => RecipeDetailScreen(),
        CategoryDetailScreen.routeName: (ctx) => CategoryDetailScreen(),
        FavoriteScreen.routeName: (ctx) => FavoriteScreen(false),
        ProfileScreen.routeName: (ctx) => ProfileScreen(),
        ForgotPasswordScreen.routeName: (ctx) => ForgotPasswordScreen(),
      },
    );

    // Ads.initializeFirebaseAdMob();
  }
}
