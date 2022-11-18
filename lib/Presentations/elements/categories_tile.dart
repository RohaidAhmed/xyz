import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:patient_module/Configurations/app_config.dart';
import 'package:patient_module/Presentations/views/doctor_list.dart';
import 'package:patient_module/infrastructure/models/category_model.dart';

class CategoriesTile extends StatelessWidget {
  final CategoryModel categoryModel;

  const CategoriesTile({Key? key, required this.categoryModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.only(top: 5, bottom: 5),
          child: Container(
            child: ListTile(
              leading: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppConfigurations.color,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.category,
                      size: 20,
                      color: Colors.white,
                    ),
                  )),
              title: Text(categoryModel.categoryName.toString(),
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w500)),
              trailing: Icon(
                Icons.arrow_forward,
                color: AppConfigurations.color,
              ),
              selected: true,
              onTap: () {
                Get.to(() => DoctorList(
                    categoryID: categoryModel.categoryId.toString()));
              },
            ),
          ),
        ),
      ),
    );
  }
}
