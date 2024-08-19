import 'package:flutter/material.dart';
import 'package:food_delivery/data/service/database.dart';
import 'package:food_delivery/data/service/save_user_info.dart';
import 'package:food_delivery/presentation/widgets/scaffold_message.dart';
import 'package:food_delivery/presentation/widgets/text_style_widget.dart';

class FoodDetailsPage extends StatefulWidget {
  const FoodDetailsPage(
      {super.key,
      required this.productImage,
      required this.productName,
      required this.productDetail,
      required this.productPrice});

  final String productImage;
  final String productName;
  final String productDetail;
  final String productPrice;

  @override
  State<FoodDetailsPage> createState() => _FoodDetailsPageState();
}

class _FoodDetailsPageState extends State<FoodDetailsPage> {
  int _countNumber = 1;
  int totalPrice = 0;
  String? id;

  @override
  void initState() {
    super.initState();
    _getUserId();
    totalPrice = int.parse(widget.productPrice);
  }

  Future<void> _getUserId() async {
    id = await SaveUserInfo().getUserId();
    setState(() {});
  }

  Future<void> _addToCart() async {
    try {
      Map<String, dynamic> _addFoodtoCart = {
        "Name": widget.productName,
        "Quantity": _countNumber.toString(),
        "Total": totalPrice.toString(),
        "Image": widget.productImage
      };
      await Database.addingFoodToCart(_addFoodtoCart, id!);

      if (mounted) {
        ScaffoldMessage.showScafflodMessage(
            context, "Food Added to Cart", Colors.orangeAccent);
      }
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessage.showScafflodMessage(
          context, "Failed Adding to Cart", Colors.redAccent);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_outlined,
            size: 26,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: _buildProductDetails(context),
      ),
    );
  }

  Widget _buildProductDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.network(
          widget.productImage,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.35,
        ),
        const SizedBox(
          height: 20,
        ),
        _buildProductNameCounter(context),
        const SizedBox(
          height: 20,
        ),
        Text(widget.productDetail,
            style: TextStyleWidget.smallTextStyle,
            maxLines: 4,
            overflow: TextOverflow.ellipsis),
        const SizedBox(
          height: 30,
        ),
        _buildProductDeliveryTime(),
        const Spacer(),
        _buildTotalPrductAddToCart(context),
      ],
    );
  }

  Widget _buildTotalPrductAddToCart(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Total Price",
                style: TextStyleWidget.semiTextSyle,
              ),
              Text(
                "\$$totalPrice",
                style: TextStyleWidget.semiTextSyle,
              ),
            ],
          ),
          GestureDetector(
            onTap: () async {
              _addToCart();
            },
            child: Container(
              width: MediaQuery.of(context).size.width * 0.5,
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Text(
                    "Add to cart",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(8)),
                    child: const Icon(
                      Icons.shopping_cart_outlined,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductDeliveryTime() {
    return Row(
      children: [
        Text("Delivery Time", style: TextStyleWidget.semiTextSyle),
        const SizedBox(
          width: 30,
        ),
        const Icon(
          Icons.alarm,
          color: Colors.black54,
        ),
        const SizedBox(
          width: 8,
        ),
        Text(
          "30 min",
          style: TextStyleWidget.semiTextSyle,
        ),
      ],
    );
  }

  Widget _buildProductNameCounter(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.productName,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
        const Spacer(),
        _buildCounter(Icons.remove, _decreaseCount),
        const SizedBox(
          width: 20,
        ),
        Text(
          _countNumber.toString(),
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(
          width: 20,
        ),
        _buildCounter(Icons.add, _increaseCount),
      ],
    );
  }

  Widget _buildCounter(IconData iconName, VoidCallback? ontap) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          iconName,
          color: Colors.white,
        ),
      ),
    );
  }

  void _increaseCount() {
    _countNumber++;
    totalPrice = totalPrice + int.parse(widget.productPrice);
    setState(() {});
  }

  void _decreaseCount() {
    if (_countNumber > 1) {
      _countNumber--;
      totalPrice = totalPrice - int.parse(widget.productPrice);
    } else {
      _countNumber = 1;
    }
    setState(() {});
  }
}
