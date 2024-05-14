import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/category.dart';
import '../widget/category_list.dart';
import '../provider/recipe.dart';
import '../widget/recipes_grid.dart';

enum SearchType {
  Recipe,
  Category,
  FavoriteRecipe,
  RecipeFromCatetory,
}

class SearchScreen extends SearchDelegate<String> {
  final SearchType searchType;

  SearchScreen(this.searchType);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      ),
    ];
  }

  @override
  void showResults(BuildContext context) {
    super.showResults(context);
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, "");
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (searchType == SearchType.Category) {
      return _categoryList(isForResult: true);
    } else {
      return _recipesGrid(isForResult: true);
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (searchType == SearchType.Category) {
      return _categoryList();
    } else {
      return _recipesGrid();
    }
  }

  Widget _recipesGrid({bool isForResult = false}) {
    return Consumer<RecipesProvider>(
      builder: (ctx, recipeProvider, child) {
        List<RecipeItem> recipeItems =
            _getRecipeListBySearchType(recipeProvider);
        return RecipesGrid(
          query.isEmpty || isForResult
              ? recipeItems
              : recipeItems
                  .where(
                    (recipe) => recipe.recipeName.toLowerCase().contains(
                          query.toLowerCase(),
                        ),
                  )
                  .toList(),
        
        );
      },
    );
  }

  Widget _categoryList({bool isForResult = false}) {
    return Consumer<CategoryProvider>(
      builder: (ctx, catProvider, child) {
        return CategoryList(
          query.isEmpty || isForResult
              ? catProvider.categories
              : catProvider.categories
                  .where(
                    (recipe) => recipe.categoryName.toLowerCase().contains(
                          query.toLowerCase(),
                        ),
                  )
                  .toList(),
        );
      },
    );
  }

  List<RecipeItem> _getRecipeListBySearchType(RecipesProvider provider) {
    if (searchType == SearchType.Recipe) {
      return provider.recipes;
    } else if (searchType == SearchType.FavoriteRecipe) {
      return provider.favRecipes;
    } else if (searchType == SearchType.RecipeFromCatetory) {
      return provider.recipesByCat;
    }
    return <RecipeItem>[];
  }
}
