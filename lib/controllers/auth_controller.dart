import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../model/user_model.dart';

class UserRepository {
  Future<DocumentSnapshot> getUserDetails(String userId) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get();
  }
}
class AuthController extends GetxController {
  var myUser = UserModel().obs;
  getUserData() {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .snapshots()
        .listen((event) {
      if (event.exists) {
        myUser.value = UserModel.fromJson(event.data()!);
      }
    });
  }
}