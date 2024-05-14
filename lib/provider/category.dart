import 'dart:convert';

import 'package:flutter/material.dart';

import '../api/api_call.dart';

import '../constant/custom_dialog.dart';

class CategoryProvider with ChangeNotifier {
  List<CategoryItem> _categories = [];

  List<CategoryItem> get categories {
    return List.from(_categories);
  }

  Future<void> fetchAndSetCategories({required BuildContext context}) async {
    if (categories.length > 0) {
      notifyListeners();
      return;
    }

    Map<String, String> parameters = {
      'search': '',
      'offset': '0',
      'limit': '100',
    };

    try {
      final responseData = await ApiCall.callService(
          context: context, webApi: API.Category, parameter: parameters);
      List<CategoryItem> recipeItems =
          categoryFromJson(responseData).categories;
      _categories = recipeItems;
      notifyListeners();
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
  }
}

CategoryResponse categoryFromJson(String response) =>
    CategoryResponse.fromJson(json.decode(response));

class CategoryResponse {
  bool status;
  int code;
  List<CategoryItem> categories;

  CategoryResponse({
    required this.status,
    required this.code,
    required this.categories,
  });

  factory CategoryResponse.fromJson(Map<String, dynamic> json) =>
      CategoryResponse(
        status: json["status"],
        code: json["code"],
        categories: List<CategoryItem>.from(
            json["data"].map((x) => CategoryItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "code": code,
        "data": List<dynamic>.from(categories.map((x) => x.toJson())),
      };
}

class CategoryItem {
  String cid;
  String categoryName;
  String categoryImageUrl;

  CategoryItem({
    required this.cid,
    required this.categoryName,
    required this.categoryImageUrl,
  });

  factory CategoryItem.fromJson(Map<String, dynamic> json) => CategoryItem(
        cid: json["cid"],
        categoryName: json["category_name"],
        categoryImageUrl: json["category_image_url"],
      );

  Map<String, dynamic> toJson() => {
        "cid": cid,
        "category_name": categoryName,
        "category_image_url": categoryImageUrl,
      };
}
