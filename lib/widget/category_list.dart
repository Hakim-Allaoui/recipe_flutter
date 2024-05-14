import 'package:flutter/material.dart';

import './category_card.dart';
import '../provider/category.dart';
import './no_recipes.dart';
import '../constant/static_string.dart';

class CategoryList extends StatelessWidget {
  final List<CategoryItem> categories;

  CategoryList(this.categories);

  @override
  Widget build(BuildContext context) {
    return categories.length > 0
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: categories.length,
            itemBuilder: (BuildContext context, int index) {
              return CategoryCard(categories[index]);
            },
          )
        : NoRecipes(title: StaticString.noCategory);
  }
}
