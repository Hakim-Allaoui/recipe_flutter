import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_flutter_provider/provider/auth.dart';
import 'package:recipe_flutter_provider/widget/google_admob.dart';

import '../screens/search_screen.dart';
import '../constant/static_string.dart';
import '../widget/app_drawer.dart';
import '../provider/recipe.dart';
import '../widget/recipes_grid.dart';

class FavoriteScreen extends StatefulWidget {
  static const routeName = '/favorite-screen';
  final bool isFromDrawer;

  const FavoriteScreen(this.isFromDrawer);

  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  bool _isInit = true;
  bool _isLoading = false;

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });

      try {
        await Provider.of<RecipesProvider>(context, listen: false)
            .fetchAndSetFavRecipes(context: context);

        setState(() {
          _isLoading = false;
        });
      } catch (error) {
        setState(() {
          _isLoading = false;
        });
      }
    }
    _isInit = false;

    super.didChangeDependencies();
 if(Provider.of<AuthProvider>(context).getScreenIsModel == true){
      return;
    }
      if (_scaffoldKey.currentState?.isDrawerOpen == true) {
      print(" ================ ${_scaffoldKey.currentState?.isDrawerOpen}");
      Provider.of<AuthProvider>(context).setAdmobStatus = false;
    }
    else if (_scaffoldKey.currentState?.isDrawerOpen == false){
      Provider.of<AuthProvider>(context).setAdmobStatus = true;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
     final FavoriteScreen args = ModalRoute.of(context)!.settings.arguments as FavoriteScreen;
    print(" -------------------------------- ${args.isFromDrawer ?? false}");

    List<RecipeItem> recipes =
        Provider.of<RecipesProvider>(context, listen: false).favRecipes;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(StaticString.favourite),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: SearchScreen(SearchType.values[2]),
              );
            },
          )
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
              ? Center(child: CircularProgressIndicator())
              : 
              
              Column(
                children: <Widget>[
                  Expanded(child:  RecipesGrid(recipes, showFavorite: false)),
                  // GoogleAdmob()
                ],
              )
              
    );
  }
}
