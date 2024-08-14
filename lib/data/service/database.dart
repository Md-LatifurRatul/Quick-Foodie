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
}
