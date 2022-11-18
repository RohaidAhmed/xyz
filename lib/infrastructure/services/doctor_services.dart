import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:patient_module/infrastructure/models/doctor_profile_model.dart';

class DoctorServices {
  CollectionReference<Map<String, dynamic>> _categoryServices =
      FirebaseFirestore.instance.collection('doctorsData');

  ///Get Category
  Stream<List<DoctorProfileModel>> streamDoctors(String categoryID) {
    return _categoryServices
        .where('category_id', isEqualTo: categoryID)
        .snapshots()
        .map((event) => event.docs
            .map((e) => DoctorProfileModel.fromJson(e.data()))
            .toList());
  }
}
