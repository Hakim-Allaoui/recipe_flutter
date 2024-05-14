import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/category.dart';
import '../widget/category_list.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  bool _isInit = true;
  bool _isLoading = false;

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      _isLoading = true;

      try {
        await Provider.of<CategoryProvider>(context)
            .fetchAndSetCategories(context: context);

        setState(() {
          _isLoading = false;
        });
      } catch (error) {
        setState(() {
          _isLoading = false;
        });
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<CategoryItem> categories =
        Provider.of<CategoryProvider>(context, listen: false).categories;
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : CategoryList(categories);
  }
}
