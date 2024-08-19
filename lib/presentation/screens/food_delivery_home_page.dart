import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/data/service/database.dart';
import 'package:food_delivery/presentation/utility/assets_path.dart';
import 'package:food_delivery/presentation/widgets/product_item_information.dart';

class FoodDeliveryHomePage extends StatefulWidget {
  const FoodDeliveryHomePage({super.key});

  @override
  State<FoodDeliveryHomePage> createState() => _FoodDeliveryHomePageState();
}

class _FoodDeliveryHomePageState extends State<FoodDeliveryHomePage> {
  String? _selectedProduct;

  Stream<QuerySnapshot>? foodItemStream;

  Future _onLoadData(String name) async {
    foodItemStream = await Database.getFooodItem(name);

    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    _onLoadData('Pizza');
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
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 8, top: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
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
              height: 8,
            ),
            _showProductItem(),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 210,
              child: _allItemsData(Axis.horizontal, Axis.vertical),
            ),
            Expanded(
              child: _allItemsData(Axis.vertical, Axis.horizontal),
            ),
          ],
        ),
      ),
    );
  }

  Widget _allItemsData(Axis scrolAxisDirection, Axis layoutAxisDirection) {
    return StreamBuilder<QuerySnapshot>(
      stream: foodItemStream,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: snapshot.data.docs.length,
                shrinkWrap: true,
                scrollDirection: scrolAxisDirection,
                itemBuilder: (context, index) {
                  DocumentSnapshot documents = snapshot.data.docs[index];
                  return ProductItemInformation(
                    productImagePath: documents['Image'],
                    foodName: documents['Name'],
                    foodInfo: documents['Detail'],
                    foodPrice: "${documents['Price']}",
                    layoutAxis: layoutAxisDirection,
                  );
                },
              )
            : const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _showProductItem() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _productShowCase(AssetsPath.productIceCream, 'Ice-Cream'),
        _productShowCase(AssetsPath.productPizza, 'Pizza'),
        _productShowCase(AssetsPath.productSalad, 'Salad'),
        _productShowCase(AssetsPath.productBurger, 'Burger'),
      ],
    );
  }

  Widget _productShowCase(String assestsImage, String productName) {
    return GestureDetector(
      onTap: () async {
        _changeItemSelectedProduct(productName);

        foodItemStream = await Database.getFooodItem(productName);
      },
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
