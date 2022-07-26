import 'package:flutter/material.dart';
import 'package:flutter_application_eb/models/recipe.dart';
import 'package:flutter_application_eb/services/recipe_service.dart';

class CategoryDetailPage extends StatefulWidget {
  final String name;
  final String cover;
  final String description;

  const CategoryDetailPage(
      {Key? key,
      required this.name,
      required this.cover,
      required this.description})
      : super(key: key);

  @override
  State<CategoryDetailPage> createState() => _CategoryDetailPageState();
}

class _CategoryDetailPageState extends State<CategoryDetailPage> {
  Future<List<Recipe>>? _listRecipes;
  final recipeService = RecipeService();

  void _getRecipes() {
    final _listRecipes = recipeService.getRecipes(widget.name);
    setState(() {
      this._listRecipes = _listRecipes;
    });
  }

  @override
  void initState() {
    super.initState();
    _getRecipes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            title: Text(widget.name),
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: widget.name,
                child: FadeInImage(
                  image: NetworkImage(widget.cover),
                  fit: BoxFit.cover,
                  placeholder: NetworkImage(widget.cover),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              child: Center(
                child: Text(widget.description),
              ),
            ),
          ),
        ];
      },
      body: FutureBuilder(
        future: _listRecipes,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView(
              children: _listWidgetRecipes(snapshot.data, context),
            );
          } else if (snapshot.hasError) {
            return const Text('Error');
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    ));
  }
}

List<Widget> _listWidgetRecipes(data, context) {
  List<Widget> recipes = [];

  for (var recipe in data) {
    recipes.add(Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        margin: const EdgeInsets.all(15),
        elevation: 10,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Column(
            children: <Widget>[
              Image(
                image: NetworkImage(recipe.coverUrl),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: Text(recipe.name),
              ),
            ],
          ),
        )));
  }

  return recipes;
}
