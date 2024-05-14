import 'dart:convert';

import 'package:flutter/material.dart';

import '../constant/custom_dialog.dart';
import '../api/api_call.dart';

class RecipesProvider with ChangeNotifier {
  List<RecipeItem> _recipes = [];
  List<RecipeItem> _recipesByCategory = [];
  List<RecipeItem> _favRecipes = [];

  List<RecipeItem> get recipes {
    return List.from(_recipes);
  }

  List<RecipeItem> get recipesByCat {
    return List.from(_recipesByCategory);
  }

  List<RecipeItem> get favRecipes {
    return List.from(_favRecipes);
  }

  Future<void> fetchAndSetRecipes(
      {required BuildContext context, String? catId}) async {
    //API Parameters...
    if (recipes.length > 0 && catId == null) {
      // notifyListeners();
      return;
    }

    Map<String, String> parameters = {
      "search": "",
      "offset": '0',
      "limit": '100',
      "category_id": catId != null ? catId : ''
    };

    try {
      final responseData = await ApiCall.callService(
          context: context, webApi: API.Recipe, parameter: parameters);
      List<RecipeItem> recipeItems = recipeFromJson(responseData).data!;

      _recipesByCategory = recipeItems;
        } catch (error) {
      showDialog(
        context: context,
        builder: (context) {
          return CustomDialog(
            title: error is NoInternetException ? 'No Internet!!!' : 'Error!!!',
            buttonText: 'Okay',
            description: error.toString(),
            alertType: error is NoInternetException
                ? CustomDialogType.NoInternet
                : CustomDialogType.Error,
          );
        },
      );
      throw error;
    }

    notifyListeners();
  }

  Future<void> fetchAndSetFavRecipes({required BuildContext context}) async {
    //API Parameters...

    Map<String, String> parameters = {
      "search": "",
      "bookmark": '1',
      "offset": '0',
      "limit": '1000',
    };

    try {
      final responseData = await ApiCall.callService(
          context: context, webApi: API.Recipe, parameter: parameters);

      List<RecipeItem> recipeItems = recipeFromJson(responseData).data!;
      // print(responseData);

      _favRecipes = recipeItems;
    } catch (error) {
      showDialog(
        context: context,
        builder: (context) {
          return CustomDialog(
            title: error is NoInternetException ? 'No Internet!!!' : 'Error!!!',
            buttonText: 'Okay',
            description: error.toString(),
            alertType: error is NoInternetException
                ? CustomDialogType.NoInternet
                : CustomDialogType.Error,
          );
        },
      );
      throw error;
    }

    notifyListeners();
  }

  Future<bool> toggleFavoriteStatus({
    required BuildContext context,
    required RecipeItem recipe,
  }) async {
    // notifyListeners();

    final oldStatus = recipe.isBookmark;
    try {
      Map<String, String> parameters = {
        'bookmark': !oldStatus ? '1' : '0',
        'recipe_id': recipe.recipeId,
      };

      final responseData = await ApiCall.callService(
          context: context, webApi: API.Bookmark, parameter: parameters);
      // print('response $responseData');

      final int indexInFavRecipe = getIndex(recipe, _favRecipes);
      recipe.isBookmark = !oldStatus;
      replaceRecipeFromAllList(recipe);

      if (indexInFavRecipe >= 0 && oldStatus) {
        _favRecipes.removeAt(indexInFavRecipe);
      }
      notifyListeners();
      return true;
    } catch (error) {
      notifyListeners();
      return false;
    }
  }

  void replaceRecipeFromAllList(RecipeItem recipe) {
    final int indexInRecipes = getIndex(recipe, _recipes);
    final int indexInCatRecipes = getIndex(recipe, _recipesByCategory);

    if (indexInRecipes >= 0) {
      _recipes[indexInRecipes] = recipe;
    }

    if (indexInCatRecipes >= 0) {
      _recipesByCategory[indexInCatRecipes] = recipe;
    }
  }

  int getIndex(RecipeItem recipe, List<RecipeItem> list) {
    return list.indexWhere((value) {
      return value.recipeId == recipe.recipeId;
    });
  }
}

//Get Reciep from Json...
RecipeResponse recipeFromJson(String str) =>
    RecipeResponse.fromJson(json.decode(str));
RecipeResponse bookmarkRecipeFromJson(String str) =>
    RecipeResponse.fromJsonForBookmark(json.decode(str));

class RecipeResponse {
  bool status;
  int code;
  List<RecipeItem>? data;
  RecipeItem? bookMarkData;

  RecipeResponse({required this.status,required  this.code, this.data, this.bookMarkData});

  factory RecipeResponse.fromJson(Map<String, dynamic> json) => RecipeResponse(
        status: json["status"],
        code: json["code"],
        data: List<RecipeItem>.from(
            json["data"].map((x) => RecipeItem.fromJson(x))),
      );

  factory RecipeResponse.fromJsonForBookmark(Map<String, dynamic> json) =>
      RecipeResponse(
        status: json["status"],
        code: json["code"],
        bookMarkData: RecipeItem.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "code": code,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class RecipeItem with ChangeNotifier {
  String recipeId;
  String recipeName;
  String catId;
  String categoryName;
  String createdBy;
  String creatorImageUrl;
  String calories;
  String servingPerson;
  String recipesTime;
  List<String> recipesImageUrl;
  List<String> direction;
  String summary;
  List<Ingredient> ingredients;
  String shareUrl;
  String rating;
  bool isBookmark;

  RecipeItem({
    required this.recipeId,
    required this.recipeName,
    required this.catId,
    required this.categoryName,
    required this.createdBy,
    required this.creatorImageUrl,
    required this.calories,
    required this.servingPerson,
    required this.recipesTime,
    required this.recipesImageUrl,
    required this.direction,
    required this.summary,
    required this.ingredients,
    required this.shareUrl,
    required this.rating,
    required this.isBookmark,
  });

  factory RecipeItem.fromJson(Map<String, dynamic> json) {
    // print('recipe detail ${json["ingredients"]}');
    return RecipeItem(
      recipeId: json["recipe_id"],
      recipeName: json["recipe_name"],
      catId: json["cat_id"],
      categoryName: json["category_name"],
      createdBy: json["created_by"],
      creatorImageUrl: json["creator_image_url"],
      calories: json["calories"],
      servingPerson: json["serving_person"],
      recipesTime: json["recipes_time"],
      recipesImageUrl:
          List<String>.from(json["recipes_image_url"].map((x) => x)),
      direction: List<String>.from(json["direction"].map((x) => x)),
      summary: json["summary"],
      ingredients: List<Ingredient>.from(
          json["ingredients"].map((x) => Ingredient.fromJson(x))),
      shareUrl: json["share_url"],
      rating: json["rating"],
      isBookmark: json["is_bookmark"] == "1" ? true : false,
    );
  }

  Map<String, dynamic> toJson() => {
        "recipe_id": recipeId,
        "recipe_name": recipeName,
        "cat_id": catId,
        "category_name": categoryName,
        "created_by": createdBy,
        "creator_image_url": creatorImageUrl,
        "calories": calories,
        "serving_person": servingPerson,
        "recipes_time": recipesTime,
        "recipes_image_url": List<dynamic>.from(recipesImageUrl.map((x) => x)),
        "direction": List<dynamic>.from(direction.map((x) => x)),
        "summary": summary,
        "ingredients": List<dynamic>.from(ingredients.map((x) => x.toJson())),
        "share_url": shareUrl,
        "rating": rating,
        "is_bookmark": isBookmark,
      };
}

class Ingredient {
  String ingredientName;
  String quantity;
  String weight;
  bool isChecked;

  Ingredient(
      {required this.ingredientName,
      required this.quantity,
      required this.weight,
      this.isChecked = false});

  factory Ingredient.fromJson(Map<String, dynamic> json) => Ingredient(
      ingredientName: json["ingredient_name"],
      quantity: json["quantity"],
      weight: json["weight"],
      isChecked: false);

  Map<String, dynamic> toJson() => {
        "ingredient_name": ingredientName,
        "quantity": quantity,
        "weight": weight,
      };
}
