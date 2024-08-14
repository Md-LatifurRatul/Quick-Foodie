import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/presentation/screens/login_page.dart';
import 'package:food_delivery/presentation/utility/assets_path.dart';
import 'package:food_delivery/presentation/widgets/product_item_information.dart';

class FoodDeliveryHomePage extends StatefulWidget {
  const FoodDeliveryHomePage({super.key});

  @override
  State<FoodDeliveryHomePage> createState() => _FoodDeliveryHomePageState();
}

class _FoodDeliveryHomePageState extends State<FoodDeliveryHomePage> {
  String? _selectedProduct;

  Future<void> _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.orangeAccent,
          content: Text(
            "Sign Out Sucessfully",
            style: TextStyle(fontSize: 18),
          ),
        ),
      );

      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginPage()));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text(
            "Error Occurred Sign out failed",
            style: TextStyle(fontSize: 18),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme headLineText = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        automaticallyImplyLeading: false,
        title: Text('Hello, Ratul', style: headLineText.headlineMedium),
        actions: [
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.shopping_cart,
              color: Colors.white,
              size: 25,
            ),
          ),
          TextButton(
              onPressed: () async => _signOut(),
              child: const Icon(Icons.logout_outlined))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Delicious Food",
              style: headLineText.headlineLarge,
            ),
            Text(
              'Discover and Get Great Food',
              style: headLineText.headlineSmall,
            ),
            const SizedBox(
              height: 15,
            ),
            _showProductItem(),
            const SizedBox(
              height: 10,
            ),
            const SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ProductItemInformation(
                    foodName: "Vagitable With Salad",
                    foodInfo: "Fresh and Healthy",
                    foodPrice: "\$25",
                    layoutAxis: Axis.vertical,
                  ),
                  ProductItemInformation(
                    foodName: "Mix Vagitable With Salad",
                    foodInfo: "Spicy With Onion",
                    foodPrice: "\$28",
                    layoutAxis: Axis.vertical,
                  ),
                  ProductItemInformation(
                    foodName: "Mix Vagitable With Chili",
                    foodInfo: "Spicy With Creesp",
                    foodPrice: "\$30",
                    layoutAxis: Axis.vertical,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView(
                children: const [
                  ProductItemInformation(
                    foodName: "Vagitable With Chicken Salad",
                    foodInfo: "Honey Cheese",
                    foodPrice: "\$28",
                    layoutAxis: Axis.horizontal,
                  ),
                  ProductItemInformation(
                    foodName: "Vagitable With Chicken Salad",
                    foodInfo: "Honey Cheese",
                    foodPrice: "\$28",
                    layoutAxis: Axis.horizontal,
                  ),
                  ProductItemInformation(
                    foodName: "Vagitable With Chicken Salad",
                    foodInfo: "Honey Cheese",
                    foodPrice: "\$28",
                    layoutAxis: Axis.horizontal,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _showProductItem() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _productShowCase(AssetsPath.productIceCream, 'IceCream'),
        _productShowCase(AssetsPath.productPizza, 'Pizza'),
        _productShowCase(AssetsPath.productSalad, 'Salad'),
        _productShowCase(AssetsPath.productBurger, 'Burger'),
      ],
    );
  }

  Widget _productShowCase(String assestsImage, String productName) {
    return GestureDetector(
      onTap: () => _changeItemSelectedProduct(productName),
      child: Material(
        color: _selectedProduct == productName
            ? const Color.fromARGB(255, 47, 45, 45)
            : Colors.white,
        borderRadius: BorderRadius.circular(12),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Image.asset(
            assestsImage,
            height: 40,
            width: 70,
          ),
        ),
      ),
    );
  }

  void _changeItemSelectedProduct(String productName) {
    setState(() {
      _selectedProduct = productName;
    });
  }
}
