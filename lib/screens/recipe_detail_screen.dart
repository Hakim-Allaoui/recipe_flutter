import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:recipe_flutter_provider/provider/auth.dart';
import 'package:recipe_flutter_provider/provider/theme_provider.dart';
import '../widget/custom_image.dart';
import 'package:share/share.dart';

import '../constant/app_bar.dart';
import '../constant/app_fonts.dart';
import '../constant/app_images.dart';
import '../constant/static_string.dart';
import '../provider/recipe.dart';
import '../constant/decoration.dart';
import '../screens/main_auth_screen.dart';

class RecipeDetailScreen extends StatefulWidget {
  static const routeName = '/recipe-details-screen';

  _RecipeDetailScreenState createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var top = 0.0;
  bool _isLoading = false;

  bool get isShrink {
    return top < (84);
  }

  AnimationController? animationController;
  Animation<double>? animation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    animation = CurvedAnimation(
      parent: animationController!,
      curve: Curves.easeInOut,
    );

    animationController!.forward();
  }

  @override
  Widget build(BuildContext context) {
    final RecipeItem recipe =
        ModalRoute.of(context)!.settings.arguments as RecipeItem;
    ThemeNotifier themeNotifier = Provider.of<ThemeNotifier>(context);
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: NestedScrollView(
            headerSliverBuilder: (ctx, scrolled) {
              return <Widget>[
                SliverAppBar(
                  iconTheme: IconThemeData(
                      color: scrolled
                          ? Theme.of(context).textTheme.titleLarge!.color
                          : Colors.white),
                  actions: <Widget>[
                    _buildShareButton(recipe.shareUrl),
                    _buildFavButton(recipe),
                  ],
                  expandedHeight: 200,
                  floating: true,
                  pinned: true,
                  flexibleSpace: _buildFlexibleTitleBar(recipe),
                )
              ];
            },
            body: AnimatedBuilder(
              animation: animationController!,
              builder: (context, child) {
                return FadeTransition(
                  opacity: animation!,
                  child: Column(
                    children: <Widget>[
                      Expanded(
                          child:
                              SingleChildScrollView(child: _buildBody(recipe))),
                      AnimatedContainer(
                        duration: Duration(milliseconds: 250),
                        height:
                            Provider.of<AuthProvider>(context).getAdmobStatus
                                ? 50.0
                                : 0.0,
                        width: double.infinity,
                        color: themeNotifier.getTheme() == lightTheme
                            ? Colors.white
                            : Colors.black,
                      )
                    ],
                  ),
                );
              },
            )),
      ),
    );
  }

  Widget _buildShareButton(String shareUrl) {
    return Padding(
      padding: EdgeInsets.only(right: 5, left: 5),
      child: FloatingActionButton(
        heroTag: null,
        mini: true,
        elevation: 0,
        backgroundColor: Colors.white,
        onPressed: () => Share.share(shareUrl),
        child: Icon(
          Icons.share,
          color: Theme.of(context).colorScheme.secondary,
          size: 22.0,
        ),
      ),
    );
  }

  Widget _buildFavButton(RecipeItem recipe) {
    return Padding(
      padding: EdgeInsets.only(right: 10),
      child: Consumer<RecipesProvider>(
        builder: (ctx, recipeProvider, _) {
          return FloatingActionButton(
            heroTag: null,
            mini: true,
            elevation: 0.0,
            onPressed: () async {
              if (!_isLoading) {
                bool isMarkedAsFav = false;
                final bool oldSatatus = recipe.isBookmark;
                setState(() {
                  _isLoading = true;
                });

                isMarkedAsFav = await recipeProvider.toggleFavoriteStatus(
                  recipe: recipe,
                  context: context,
                );

                setState(() {
                  _isLoading = false;
                });
                final String content = isMarkedAsFav
                    ? oldSatatus
                        ? 'Successfully removed from Favorite!!!'
                        : 'Successfully marked as Favorite!!'
                    : 'Please login to mark this recipe as fav.';
                // _scaffoldKey.currentState!.showSnackBar(
                //   SnackBar(
                //     duration: Duration(milliseconds: 900),
                //     content: Text(content),
                //     action: !isMarkedAsFav
                //         ? SnackBarAction(
                //             label: 'Login',
                //             onPressed: () async {
                //               Navigator.of(context).push(MaterialPageRoute(
                //                 builder: (context) => MainAuthScreen(),
                //                 fullscreenDialog: true,
                //               ));
                //             },
                //           )
                //         : null,
                //   ),
                // );

                final scaffoldMessenger = ScaffoldMessenger.of(context);
                scaffoldMessenger.showSnackBar(
                  SnackBar(
                    duration: Duration(milliseconds: 900),
                    content: Text(content),
                    action: SnackBarAction(
                      label: 'Login',
                      onPressed: () async {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => MainAuthScreen(),
                          fullscreenDialog: true,
                        ));
                      },
                    ),
                  ),
                );
              }
            },
            child: _isLoading
                ? CircularProgressIndicator()
                : Icon(
                    recipe.isBookmark ? Icons.favorite : Icons.favorite_border,
                    color: Theme.of(context).colorScheme.secondary,
                    size: 22,
                  ),
            backgroundColor: Colors.white,
          );
        },
      ),
    );
  }

  Widget _buildFlexibleTitleBar(RecipeItem recipe) {
    return LayoutBuilder(
      builder: (ctx, constraint) {
        top = constraint.maxHeight;
        return FlexibleSpaceBar(
          centerTitle: true,
          title: _buildTitle(title: recipe.recipeName),
          background: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              !isShrink
                  ? Hero(
                      tag: recipe.recipeId,
                      child: _buildImage(recipe.recipesImageUrl.first),
                    )
                  : _buildImage(recipe.recipesImageUrl.first),
              Positioned.fill(
                child: BackdropFilter(
                  filter: ui.ImageFilter.blur(
                    sigmaX: 0.1,
                    sigmaY: 0.1,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildImage(String imageUrl) {
    return FadeInImage(
      image: NetworkImage(imageUrl),
      placeholder: AssetImage(AppImages.transparent),
      fit: BoxFit.cover,
    );
  }

  Widget _buildTitle({required String title}) {
    return AnimatedOpacity(
      duration: Duration(milliseconds: 300),
      opacity: 1.0,
      child: Padding(
        padding: EdgeInsets.only(left: 60.0, right: isShrink ? 95 : 60),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16.0,
            fontFamily: AppFonts.montserrat,
            fontWeight: FontWeight.bold,
            color: isShrink
                ? Theme.of(context).textTheme.titleLarge!.color
                : Colors.white,
          ),
          maxLines: isShrink ? 1 : 3,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  Widget _buildBody(RecipeItem recipe) {
    return recipe.recipesImageUrl.length > 1
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _buildRecipeImageGrid(recipe.recipesImageUrl),
              _buildIntro(recipe), // Intro...
              _buildIngredient(recipe), //Ingridients...
              _buildInstruction(recipe),
            ],
          )
        : Container();
  }

  Widget _buildRecipeImageGrid(List<String> urls) {
    final imageWidth = (MediaQuery.of(context).size.width - 40) / 3;
    PageController controller;
    return Container(
      height: imageWidth + 10,
      decoration: cardDecoration(context: context),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      margin: EdgeInsets.all(10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: urls.length,
        itemBuilder: (BuildContext context, int listIndex) {
          String url = urls[listIndex];
          return GestureDetector(
            onTap: () {
              controller = PageController(
                  viewportFraction: 1, keepPage: true, initialPage: listIndex);
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: PageView.builder(
                        controller: controller,
                        itemCount: urls.length,
                        itemBuilder: (context, pageIndex) {
                          return Dialog(
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              child: PhotoView(
                                tightMode: true,
                                imageProvider: NetworkImage(urls[pageIndex]),
                                heroAttributes:
                                    PhotoViewHeroAttributes(tag: url),
                              ),
                            ),
                          );
                        }),
                  );
                },
              );
            },
            child: Hero(
              tag: url,
              child: Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(5.0)),
                margin: EdgeInsets.all(5),
                width: imageWidth,
                height: imageWidth,
                child: CustomImage(
                  imgURL: urls[listIndex],
                  height: imageWidth,
                  width: imageWidth,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildIntro(RecipeItem recipe) {
    return Container(
      decoration: cardDecoration(context: context),
      padding: EdgeInsets.symmetric(vertical: 10),
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          _buildSectionTitle(StaticString.intro), //Intro
          _buildDivider(),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: CustomText(
              align: TextAlign.start,
              txtTitle: recipe.summary,
              txtColor: Theme.of(context)!
                  .textTheme
                  .titleLarge!
                  .color!, // Colors.black87,
              txtFontName: AppFonts.montserrat,
              txtFontStyle: FontWeight.w500,
              txtSize: 15,
            ),
          ),
          _buildDivider(),
          Container(
            padding: EdgeInsets.only(top: 10),
            alignment: Alignment.center,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                _buildIntroButton(
                  icon: Icons.timer,
                  title: recipe.recipesTime,
                ),
                _buildIntroButton(
                  icon: Icons.people,
                  title: recipe.servingPerson,
                ),
                _buildIntroButton(
                  icon: MdiIcons.fire,
                  title: '${recipe.calories} kcal',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIntroButton({
    required String title,
    required IconData icon,
    Function? onTap,
  }) {
    return InkWell(
      onTap: () => onTap!,
      child: Column(
        children: <Widget>[
          Icon(
            icon,
            color: Theme.of(context).textTheme.titleSmall!.color,
          ),
          SizedBox(height: 5),
          CustomText(
            txtTitle: title,
            txtColor: Theme.of(context).textTheme.titleLarge!.color!,
            txtFontName: AppFonts.montserrat,
            txtFontStyle: FontWeight.w500,
            txtSize: 15,
          )
        ],
      ),
    );
  }

  Widget _buildIngredient(RecipeItem recipe) {
    print('ingredient ${recipe.ingredients}');
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
      padding: EdgeInsets.symmetric(vertical: 10),
      decoration: cardDecoration(context: context),
      child: Column(
        children: <Widget>[
          _buildSectionTitle(StaticString.ingridient),
          _buildDivider(),
          ListView.builder(
            padding: EdgeInsets.all(0),
            physics: ClampingScrollPhysics(),
            shrinkWrap: true,
            itemCount: recipe.ingredients.length,
            itemBuilder: (BuildContext context, int index) {
              return CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                activeColor: Colors.green,
                value: recipe.ingredients[index].isChecked,
                title: Text(
                    '${recipe.ingredients[index].quantity} ${recipe.ingredients[index].weight} ${recipe.ingredients[index].ingredientName}'),
                onChanged: (value) {
                  setState(() {
                    recipe.ingredients[index].isChecked = value!;
                  });
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInstruction(RecipeItem recipe) {
    return Container(
      decoration: cardDecoration(context: context),
      margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _buildSectionTitle(StaticString.insructions),
          _buildDivider(),
          Container(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 15),
              physics: ClampingScrollPhysics(),
              shrinkWrap: true,
              itemCount: recipe.direction.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: _buildDirectionTile(recipe.direction[index]),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Container(
      height: 50,
      padding: EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment.centerLeft,
      child: CustomText(
        align: TextAlign.start,
        txtTitle: title,
        txtColor:
            Theme.of(context).textTheme.titleLarge!.color!, // Colors.black,
        txtFontName: AppFonts.montserrat,
        txtFontStyle: FontWeight.w500,
        txtSize: 22,
      ),
    );
  }

  Widget _buildDirectionTile(String title) {
    return Stack(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 5.0),
          child: Image.asset(
            AppImages.checkmark,
            height: 15.0,
            width: 15.0,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 25),
          child: CustomText(
            align: TextAlign.start,
            txtTitle: title,
            txtColor: Theme.of(context).textTheme.titleLarge!.color!,
            txtFontName: AppFonts.montserrat,
            txtFontStyle: FontWeight.w500,
            txtSize: 15,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      color: Theme.of(context).textTheme.titleSmall!.color!.withOpacity(0.8),
    );
  }
}
