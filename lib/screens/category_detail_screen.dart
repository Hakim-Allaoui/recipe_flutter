import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_flutter_provider/provider/auth.dart';
import 'package:recipe_flutter_provider/provider/theme_provider.dart';

import '../screens/search_screen.dart';
import '../provider/recipe.dart';
import '../widget/recipes_grid.dart';

class CategoryDetailScreen extends StatefulWidget {
  static const routeName = '/category-detail-Screen';

  @override
  _CategoryDetailScreenState createState() => _CategoryDetailScreenState();
}

class _CategoryDetailScreenState extends State<CategoryDetailScreen> {
  bool _isLoading = false;
  bool _isInit = true;

  String? catId;
  String? catName;

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });

      final Map<String, String> map = ModalRoute.of(context)!.settings.arguments as Map<String, String>;
      catId = map['catId'];
      catName = map['catName'];
      await Provider.of<RecipesProvider>(context, listen: false)
          .fetchAndSetRecipes(catId: catId!, context: context);

      setState(() {
        _isLoading = false;
      });

      _isInit = false;

      super.didChangeDependencies();
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);
    List<RecipeItem> recipes =
        Provider.of<RecipesProvider>(context, listen: false).recipesByCat;
    return Scaffold(
      appBar: AppBar(
        title: Text(catName != null ? catName! : ''),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: SearchScreen(SearchType.values[3]),
              );
            },
          )
        ],
      ),
      body: SafeArea(
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
              children: <Widget>[
                Expanded(
                                  child: RecipesGrid(
                      recipes,
                    ),
                ),
            AnimatedContainer(
            duration: Duration(milliseconds: 250),
            height: Provider.of<AuthProvider>(context).getAdmobStatus? 50.0 : 0.0 ,
            width: double.infinity,
            color: themeNotifier.getTheme() == lightTheme
                ? Colors.white
                : Colors.black,
          )
              ],
            ),
      ),
    );
  }
}
