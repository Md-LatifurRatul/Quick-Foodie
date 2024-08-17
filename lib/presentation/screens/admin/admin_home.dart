import 'package:flutter/material.dart';
import 'package:food_delivery/data/service/auth.dart';
import 'package:food_delivery/presentation/screens/admin/add_food_item.dart';
import 'package:food_delivery/presentation/screens/login_page.dart';
import 'package:food_delivery/presentation/utility/assets_path.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Home Admin",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton.filled(
              color: Colors.grey,
              onPressed: () async {
                await Auth.signOutUser();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const LoginPage()));
              },
              icon: const Icon(Icons.logout_outlined)),
        ],
        centerTitle: true,
        backgroundColor: Colors.tealAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddFoodItem(),
              ),
            );
          },
          child: Card(
            color: Colors.black,
            elevation: 10,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Image.asset(
                    AssetsPath.productFood,
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(
                  width: 30.0,
                ),
                const Text(
                  "Add Food Items",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
