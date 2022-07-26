import 'package:flutter/material.dart';
import 'package:flutter_application_eb/models/category.dart';
import 'package:flutter_application_eb/pages/category_detail.dart';
import 'package:flutter_application_eb/services/categories_service.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({Key? key}) : super(key: key);

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  Future<List<Category>>? _listCategories;
  final categoryService = CategoryService();

  void _getCategories() {
    final _listCategories = categoryService.getCategories();
    setState(() {
      this._listCategories = _listCategories;
    });
  }

  @override
  void initState() {
    super.initState();
    _getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:  IconButton(
          iconSize: 40.0,
          icon: const Icon(Icons.food_bank_rounded),
          onPressed: () { },
        ),
        centerTitle: true,
        title: const Text('BestGourmet'),
      ),
      body: FutureBuilder(
        future: _listCategories,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView(
              children: _listWidgetCategories(snapshot.data, context),
            );
          } else if (snapshot.hasError) {
            return const Text('Error');
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

List<Widget> _listWidgetCategories(data, context) {
  List<Widget> categories = [];

  for (var category in data) {
    categories.add(Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        margin: const EdgeInsets.all(15),
        elevation: 10,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryDetailPage(cover: category.coverUrl, name: category.name, description: category.description,)));
              },
              child: Column(
                children: <Widget>[
                  Image(
                    image: NetworkImage(category.coverUrl),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: Text(category.name),
                  ),
                ],
              ),
            ))));
  }

  return categories;
}
