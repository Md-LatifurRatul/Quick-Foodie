import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/data/service/database.dart';
import 'package:food_delivery/data/service/save_user_info.dart';
import 'package:food_delivery/presentation/widgets/text_style_widget.dart';

class FoodOrderPage extends StatefulWidget {
  const FoodOrderPage({super.key});

  @override
  State<FoodOrderPage> createState() => _FoodOrderPageState();
}

class _FoodOrderPageState extends State<FoodOrderPage> {
  Stream<QuerySnapshot>? foodCartStream;

  String? id, userWallet;
  int totalPrice = 0, amount = 0;

  Future<void> getUserId() async {
    id = await SaveUserInfo().getUserId();
    setState(() {});
  }

  Future<void> onGetCartData() async {
    await getUserId();
    foodCartStream = await Database.getFooodCart(id!);
    userWallet = await SaveUserInfo().getUserWallet();
    setState(() {});
  }

  void startTime() {
    Timer(const Duration(seconds: 1), () {
      amount = totalPrice;
      setState(
        () {},
      );
    });
  }

  @override
  void initState() {
    super.initState();
    onGetCartData();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 50),
        child: _buildFoodProductOrderCart(context),
      ),
    );
  }

  Widget _buildFoodProductOrderCart(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Material(
          elevation: 2,
          child: Container(
            padding: const EdgeInsets.only(bottom: 10),
            child: const Center(
              child: Text(
                "Food Cart",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        SizedBox(
            height: MediaQuery.of(context).size.height / 2,
            child: _foodCartItems()),
        const Spacer(),
        const Divider(),
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Total Price",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                "\$$totalPrice",
                style: TextStyleWidget.semiTextSyle,
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        _buildProductOrderCheckout()
      ],
    );
  }

  Widget _buildProductOrderCheckout() {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 20, right: 8),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
          onPressed: () async {
            int totalAmount = int.parse(userWallet!) - amount;
            await Database.updateUserWallet(id!, totalAmount.toString());
            await SaveUserInfo().saveUserWallet(totalAmount.toString());
          },
          child: const Text(
            "CheckOut",
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _foodCartItems() {
    return StreamBuilder<QuerySnapshot>(
      stream: foodCartStream,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: snapshot.data.docs.length,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  DocumentSnapshot documents = snapshot.data.docs[index];

                  totalPrice = totalPrice + int.parse(documents['Total']);

                  return Padding(
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    child: Material(
                      elevation: 5,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Container(
                              height: 90,
                              width: 40,
                              decoration: BoxDecoration(
                                  border: Border.all(),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Center(child: Text(documents['Quantity'])),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(60),
                              child: Image.network(
                                documents['Image'],
                                height: 90,
                                width: 90,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Column(
                              children: [
                                Text(
                                  documents["Name"],
                                  style: TextStyleWidget.semiTextSyle,
                                ),
                                Text(
                                  "\$${documents['Total']}",
                                  style: TextStyleWidget.semiTextSyle,
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              )
            : const Center(child: CircularProgressIndicator());
      },
    );
  }
}
