import 'package:flutter/material.dart';
import 'package:patient_module/Configurations/app_config.dart';
import 'package:patient_module/Presentations/elements/categories_tile.dart';
import 'package:patient_module/infrastructure/models/category_model.dart';

class CategoriesView extends StatelessWidget {
  List<CategoryModel> list = [
    CategoryModel(categoryId: "1", categoryName: "Skin Specialist"),
    CategoryModel(categoryId: "2", categoryName: "Heart Specialist"),
    CategoryModel(categoryId: "3", categoryName: "Child Specialist"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Categories"),
        centerTitle: true,
        backgroundColor: AppConfigurations.color,
      ),
      body: _getUI(context),
    );
  }

  Widget _getUI(BuildContext context) {
    return ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, i) {
          return CategoriesTile(categoryModel: list[i]);
        });
  }
}
