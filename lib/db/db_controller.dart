import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:phonebook/model/phone_model.dart';

class DatabaseController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference user = FirebaseFirestore.instance.collection("users");
  Future createUser(
      {required String name,
      required String phoneNumber,
      String? image}) async {
    final userData = FirebaseFirestore.instance.collection("users").doc();

    final user = PhoneModel(
      id: userData.id,
      name: name,
      phoneNumber: phoneNumber,
      image: image,
    );
    final json = user.toJson();

    await userData.set(json);
  }

  Stream<List<PhoneModel>> getUsers() => FirebaseFirestore.instance
      .collection("users")
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => PhoneModel.fromJson(doc.data())).toList());

  Future<void> deleteUser(PhoneModel phoneModel) {
    return user
        .doc(phoneModel.id)
        .delete()
        .then((value) => print("User Deleted"))
        .catchError((error) => print("Failed to delete user: $error"));
  }

  Future<void> updateData(
      PhoneModel phoneModel, String name, String phoneNumber, String image) {
    return user
        .doc(phoneModel.id)
        .update({'name': name, 'phoneNumber': phoneNumber, 'image': image})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to Update user: $error"));
  }
}
