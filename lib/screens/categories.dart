import 'package:flutter/material.dart';
import 'package:meals_app_using_flutter/data/dummy_data.dart';
import 'package:meals_app_using_flutter/models/Category.dart';
import 'package:meals_app_using_flutter/models/meal.dart';
import 'package:meals_app_using_flutter/screens/meals.dart';
import 'package:meals_app_using_flutter/widgets/category_grid_item.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({
    super.key,
    required this.availableMeals,
  });
  final List<Meal> availableMeals;

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

// with allow you to add a Mix-in class and it means that a class get merged with this class and give some new features to it
//SingleTickerProvider provides various features that are needed by the flutter's annimation system
class _CategoriesScreenState extends State<CategoriesScreen>
    with SingleTickerProviderStateMixin {
  // late tells flutter that once this property is used, it will have a value
  late AnimationController _animationController;
  @override
  void initState() {
    super.initState();
    //vsync parameter is responsible for making sure that this animation executes for every frame(60 time per second)
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      //between which values will flutter annimate
      lowerBound: 0,
      upperBound: 1,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // BuildContext context is used in this method so that we can pass context as a value to push
  void _selectCategory(BuildContext context, Category category) {
    final filteredMeals = widget.availableMeals
        .where((meal) => meal.categories.contains(category.id))
        .toList();
    // Navigator.of(context).push(route); same as  Navigator.push(context, route)
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => MealsScreen(
          title: category.title,
          meals: filteredMeals,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      child: GridView(
        padding: const EdgeInsets.all(24),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
        children: [
          // availableCategories.map((category) => CategoryGridItem(category: category)).toList()
          for (final category in availableCategories)
            CategoryGridItem(
              category: category,
              onSelectCategory: () {
                _selectCategory(context, category);
              },
            )
        ],
      ),
      builder: (context, child) => SlideTransition(
        position: Tween(
          begin: const Offset(0, 0.3),
          end: const Offset(0, 0),
        ).animate(
          CurvedAnimation(
              parent: _animationController, curve: Curves.easeInOut),
        ),
        child: child,
      ),
    );
  }
}
