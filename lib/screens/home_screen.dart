// import 'package:firebase_admob/firebase_admob.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:recipe_flutter_provider/provider/auth.dart';
import 'package:recipe_flutter_provider/provider/recipe.dart';
import 'package:recipe_flutter_provider/provider/theme_provider.dart';
import 'package:recipe_flutter_provider/screens/recipe_detail_screen.dart';
import 'package:recipe_flutter_provider/widget/google_admob.dart';

import '../constant/static_string.dart';
import '../widget/app_drawer.dart';
import './categories_screen.dart';
import './recipes_screen.dart';
import '../screens/search_screen.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home-screen';
  final bool isFromDrawer;

  const HomeScreen(this.isFromDrawer);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ThemeData? themeData;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  RecipeItem? recipe;

  Future<RecipeItem?> fetchRecipeByUrl(String name) async {
    final recipe = Provider.of<RecipesProvider>(context, listen: false)
        .getRecipeByUrl(context: context, name: name);

    return recipe;
  }

  void _handleMessage(RemoteMessage message) async {
    recipe = await fetchRecipeByUrl(message.data['name']);

    if(recipe != null) {
      Navigator.of(context).pushReplacementNamed(
        RecipeDetailScreen.routeName,
        arguments: recipe,
      );
    }
  }

  // In this example, suppose that all messages contain a data field with the key 'type'.
  Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    // navigate to a chat screen
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  @override
  void initState() {
    super.initState();
    setupInteractedMessage();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    print("Home screen DIDCHANGE called");
    print(
        "${Provider.of<AuthProvider>(context).getScreenIsModel} ************************************************");
    if (Provider.of<AuthProvider>(context).getScreenIsModel == true) {
      return;
    }
    if (_scaffoldKey.currentState?.isDrawerOpen == true) {
      print(" ================ ${_scaffoldKey.currentState?.isDrawerOpen}");
      Provider.of<AuthProvider>(context).setAdmobStatus = false;
    } else if (_scaffoldKey.currentState?.isDrawerOpen == false) {
      Provider.of<AuthProvider>(context).setAdmobStatus = true;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (ModalRoute.of(context)!.settings.arguments != null) {
      final HomeScreen args =
          ModalRoute.of(context)!.settings.arguments as HomeScreen;
      print(" -------------------------------- ${args.isFromDrawer ?? false}");
    }

    ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          // brightness: themeNotifier.getTheme() == lightTheme
          //     ? Brightness.light
          //     : Brightness.dark,
          systemOverlayStyle: themeNotifier.getTheme() == lightTheme
              ? SystemUiOverlayStyle.dark // For light themes
              : SystemUiOverlayStyle.light, // For dark themes
          actions: <Widget>[
            Builder(
              builder: (ctx) {
                return IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    final tabIndex = DefaultTabController.of(ctx).index;
                    showSearch(
                      context: context,
                      delegate: SearchScreen(SearchType.values[tabIndex]),
                    );
                  },
                );
              },
            )
          ],
          title: Text(StaticString.appTitle),
          bottom: TabBar(
            labelColor: Theme.of(context).colorScheme.secondary,
            unselectedLabelColor: Colors.grey,
            tabs: <Widget>[
              Tab(
                text: StaticString.recentRecipes,
                icon: Icon(Icons.access_time),
              ),
              Tab(
                text: StaticString.categories,
                icon: Icon(Icons.category),
              )
            ],
          ),
        ),
        drawer: AppDrawer(),
        body: Column(
          children: <Widget>[
            Expanded(
              child: TabBarView(
                children: <Widget>[
                  RecipesScreen(),
                  CategoriesScreen(),
                ],
              ),
            ),
            // GoogleAdmob()
          ],
        ),
      ),
    );
  }
}
