import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:patient_module/infrastructure/models/category_model.dart';

class CategoryServices {
  CollectionReference<Map<String, dynamic>> _categoryServices =
      FirebaseFirestore.instance.collection('doctorCategories');

  ///Get Category
  Stream<List<CategoryModel>> streamCategory() {
    return _categoryServices.snapshots().map((event) =>
        event.docs.map((e) => CategoryModel.fromJson(e.data())).toList());
  }
}
