// To parse this JSON data, do
//
//     final categoryModel = categoryModelFromJson(jsonString);

import 'dart:convert';

CategoryModel categoryModelFromJson(String str) =>
    CategoryModel.fromJson(json.decode(str));

String categoryModelToJson(CategoryModel data) =>
    json.encode(data.toJson(data.categoryId!));

class CategoryModel {
  CategoryModel({
    this.categoryId,
    this.categoryName,
  });

  String? categoryId;
  String? categoryName;

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        categoryId: json["category_id"],
        categoryName: json["category_name"],
      );

  Map<String, dynamic> toJson(String docID) => {
        "category_id": docID,
        "category_name": categoryName,
      };
}
