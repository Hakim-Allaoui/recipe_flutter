
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widget/no_recipes.dart';

import '../provider/recipe.dart';
import './recipe_card.dart';

class RecipesGrid extends StatefulWidget {
  final List<RecipeItem> recipes;
  final bool showFavorite;
  RecipesGrid(this.recipes, {this.showFavorite = true});

  @override
  _RecipesGridState createState() => _RecipesGridState();
}

class _RecipesGridState extends State<RecipesGrid> {
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.recipes.length > 0
        ? GridView.builder(
            padding: EdgeInsets.all(10.0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
            ),
            itemCount: widget.recipes.length,
            itemBuilder: (BuildContext ctx, int index) {
              return ChangeNotifierProvider.value(
                value: widget.recipes[index],
                child: RecipeCard(
                  recipe: widget.recipes[index],
                  index: index,
                  showFavorite: widget.showFavorite,
                ),
              );
            },
          )
        : NoRecipes();
  }
}
