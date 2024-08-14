import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:food_delivery/data/service/database.dart';
import 'package:food_delivery/data/service/save_user_info.dart';
import 'package:food_delivery/presentation/utility/assets_path.dart';
import 'package:food_delivery/data/utility/app_constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  String? wallet, id;
  int? add;

  final TextEditingController _amoutTEController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Map<String, dynamic>? _makePaymentIntent;

  Future<void> getUserInfoWallet() async {
    wallet = await SaveUserInfo().getUserWallet();

    id = await SaveUserInfo().getUserId();

    setState(() {});
  }

  Future<void> loadUser() async {
    await getUserInfoWallet();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: wallet == null
          ? const Center(child: CircularProgressIndicator())
          : Container(
              margin: const EdgeInsets.only(top: 60),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Material(
                    elevation: 2,
                    child: Container(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: const Center(
                        child: Text(
                          "Wallet",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF2F2F2),
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          AssetsPath.walletImage,
                          height: 60,
                          width: 60,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(
                          width: 40,
                        ),
                        Column(
                          children: [
                            const Text(
                              "Your Wallet",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w300),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              "\$${wallet!}",
                              style: const TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.bold),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text(
                      "Add money",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            _makePayment('100');
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color.fromARGB(255, 165, 159, 159),
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: const Text(
                              "\$100",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _makePayment('500');
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color.fromARGB(255, 165, 159, 159),
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: const Text(
                              "\$500",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _makePayment('1000');
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color.fromARGB(255, 165, 159, 159),
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: const Text(
                              "\$1000",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _makePayment('2000');
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color.fromARGB(255, 165, 159, 159),
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: const Text(
                              "\$2000",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w700),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  InkWell(
                    onTap: () {
                      _addMoneyPayment();
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color(0xFF008080),
                      ),
                      child: Center(
                        child: Text(
                          "Add Money",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontFamily: GoogleFonts.poppins().toString(),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }

  Future<void> _makePayment(String amount) async {
    try {
      _makePaymentIntent = await _createPaymentIntent(amount, 'USD');

      if (_makePaymentIntent != null) {
        await Stripe.instance
            .initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
              paymentIntentClientSecret: _makePaymentIntent!['client_secret'],
              style: ThemeMode.dark,
              merchantDisplayName: 'Latifur'),
        )
            .then((value) {
          _displayPaymentSheet(amount);
        });
      }
    } catch (e, s) {
      print('Exception: $e$s');
    }
  }

  Future<void> _displayPaymentSheet(String amount) async {
    try {
      await Stripe.instance.presentPaymentSheet().then(
        (value) async {
          add = int.parse(wallet!) + int.parse(amount);
          await SaveUserInfo().saveUserWallet(add.toString());
          if (id != null) {
            await Database.updateUserWallet(id!, add.toString());
          }

          showDialog(
            context: context,
            builder: (_) => const AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Colors.green,
                      ),
                      SizedBox(width: 8),
                      Text("Payment Sucessful")
                    ],
                  )
                ],
              ),
            ),
          );

          await getUserInfoWallet();
          _makePaymentIntent = null;
        },
      ).onError(
        (error, stackTrace) {
          print('Error is:----> $error $stackTrace');
        },
      );
    } on StripeException catch (e) {
      print("Error is:---> $e");
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          content: const Text("Cancelled"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    } catch (e) {
      print('$e');
    }
  }

  Future<Map<String, dynamic>?> _createPaymentIntent(
      String amount, String currency) async {
    try {
      Map<String, dynamic> _body = {
        'amount': _calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card',
      };
      Response response = await post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer $secretKey',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: _body,
      );

      print('Payment Intent Body->>> ${response.body.toString()}');
      return jsonDecode(response.body);
    } catch (e) {
      print('Error charging user: ${e.toString()}');
      return null;
    }
  }

  _calculateAmount(String amount) {
    final calculatedAmount = (int.parse(amount) * 100);
    return calculatedAmount.toString();
  }

  Future _addMoneyPayment() => showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 50,
                  ),
                  const Center(
                    child: Text(
                      "Add Money",
                      style: TextStyle(
                          color: Color(0xFF008080),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text("Amount"),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _amoutTEController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter Amount';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintStyle: TextStyle(color: Colors.black26),
                        hintText: 'Enter Amount'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            Navigator.of(context).pop();
                            _makePayment(_amoutTEController.text);
                          }
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width / 3,
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: const Color(0xFF008080),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Center(
                            child: Text(
                              "Pay",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          Icons.cancel,
                          color: Colors.redAccent,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      });
}
