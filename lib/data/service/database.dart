import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
  static Future addUserDetail(
      Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .set(userInfoMap);
  }

  static Future updateUserWallet(String id, String amount) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .update({'Wallet': amount});
  }

  static Future addFoodItems(
      Map<String, dynamic> userInfoMap, String name) async {
    return await FirebaseFirestore.instance.collection(name).add(userInfoMap);
  }

  static Future<Stream<QuerySnapshot>> getFooodItem(String name) async {
    return FirebaseFirestore.instance.collection(name).snapshots();
  }

  static Future addingFoodToCart(
      Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .collection('Cart')
        .add(userInfoMap);
  }

  static Future<Stream<QuerySnapshot>> getFooodCart(String id) async {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .collection("Cart")
        .snapshots();
  }
}
