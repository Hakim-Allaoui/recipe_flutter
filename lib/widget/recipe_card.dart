import 'package:flutter/material.dart';

import '../screens/recipe_detail_screen.dart';
import '../constant/app_fonts.dart';
import '../provider/recipe.dart';
import './custom_image.dart';

class RecipeCard extends StatelessWidget {
  final RecipeItem recipe;
  final int index;
  final bool showFavorite;

  // final SelectedRecipe selectedRecipe;
  // final MainModel model;

  RecipeCard({
    required this.recipe,
    required this.index,
    this.showFavorite = false,
    // required this.selectedRecipe,
    // required this.model
  });

  Widget _buildCardWithShadow(BuildContext context) {
    bool showHero = true;
    final double width = MediaQuery.of(context).size.width - 30;
    var boxDecoration = BoxDecoration(
      color: Theme.of(context).primaryColor,
      boxShadow: [
        BoxShadow(
          blurRadius: 3.0,
          spreadRadius: 3.0,
          color: Theme.of(context).textTheme.bodyMedium!.shadows!.first.color,
        )
      ],
    );
    return Container(
      padding: EdgeInsets.only(top: 7.0, right: 7.0, left: 7.0),
      width: width / 2,
      decoration: boxDecoration,
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Expanded(
                child: showHero
                    ? Hero(
                        tag: recipe.recipeId,
                        child: CustomImage(
                          imgURL: recipe.recipesImageUrl.first,
                          width: width,
                          height: 90,
                        ),
                      )
                    : CustomImage(
                        imgURL: recipe.recipesImageUrl.first,
                        width: width,
                        height: 90,
                      ),
              ),
              SizedBox(height: 5),
              _buildName(context, recipe.recipeName),
              SizedBox(height: 5),
              _buildTime(context, recipe.recipesTime),
              SizedBox(height: 7)
            ],
          ),
          showFavorite && recipe.isBookmark
              ? Align(
                  alignment: Alignment.topRight,
                  child: FloatingActionButton(
                    heroTag: null,
                    mini: true,
                    // elevation: 0,
                    backgroundColor: Colors.white,

                    child: Icon(
                      Icons.favorite,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    onPressed: () {},
                  ),
                )
              : Container(),
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () async {
                  final result = await Navigator.of(context).pushNamed(
                    RecipeDetailScreen.routeName,
                    arguments: recipe,
                  );
                  showHero = result != null ;//? result : true;
                  // GoogleAddmob.myBanner = null;
                },
              ),
            ),
          )
        ],
      ),
    );
  }

//Recipe Name...
  Widget _buildName(BuildContext context, String name) {
    return Text(
      name,
      style: TextStyle(
        color: Theme.of(context).textTheme.titleLarge!.color,
        fontFamily: AppFonts.montserrat,
      ),
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
    );
  }

//Recipe Time...
  Widget _buildTime(BuildContext context, String time) {
    return Text(
      time,
      style: TextStyle(
        color: Theme.of(context).textTheme.titleSmall!.color,
        fontFamily: AppFonts.montserrat,
        fontSize: 11.0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildCardWithShadow(context);
  }
}
