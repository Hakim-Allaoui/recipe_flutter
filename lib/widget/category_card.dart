import 'package:flutter/material.dart';

import '../constant/app_fonts.dart';
import '../screens/category_detail_screen.dart';
import '../widget/custom_image.dart';
import '../provider/category.dart';

class CategoryCard extends StatelessWidget {
  final CategoryItem category;

  CategoryCard(this.category);

  @override
  Widget build(BuildContext context) {
    final double targetWidth = MediaQuery.of(context).size.width - 10;
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(7),
      width: MediaQuery.of(context).size.width - 10,
      height: 200.0,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        boxShadow: [
          BoxShadow(
            blurRadius: 3,
            spreadRadius: 3,
            color: Theme.of(context).textTheme.bodyMedium!.shadows!.first.color,
          ),
        ],
      ),
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Expanded(
                child: CustomImage(
                  height: 142,
                  width: targetWidth,
                  imgURL: category.categoryImageUrl,
                  // placeholderImg: CustomImages.transparent,
                ),
              ),
              SizedBox(height: 12),
              Text(
                category.categoryName,
                style: TextStyle(
                  color: Theme.of(context).textTheme.titleLarge!.color,
                  fontFamily: AppFonts.montserrat,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () async {
                  await Navigator.of(context).pushNamed(
                    CategoryDetailScreen.routeName,
                    arguments: {
                      'catId': category.cid,
                      'catName': category.categoryName,
                    },
                  );
                  // GoogleAddmob.myBanner = null;
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
