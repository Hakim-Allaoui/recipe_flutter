import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/recipe.dart';
import '../widget/recipes_grid.dart';

class RecipesScreen extends StatefulWidget {
  const RecipesScreen({
    Key? key,
  }) : super(key: key);

  @override
  _RecipesScreenState createState() => _RecipesScreenState();
}

class _RecipesScreenState extends State<RecipesScreen> {
  bool _isLoading = false;
  bool _isInit = true;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      _isLoading = true;

      try {
        await Provider.of<RecipesProvider>(context, listen: false)
            .fetchAndSetRecipes(context: context);
      } catch (e) {
        print('no internet in catch ${e.toString()}');
      }

      setState(() {
        _isLoading = false;
      });

      _isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<RecipeItem> recipes =
        Provider.of<RecipesProvider>(context, listen: false).recipes;

    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : RecipesGrid(recipes);
  }
}
