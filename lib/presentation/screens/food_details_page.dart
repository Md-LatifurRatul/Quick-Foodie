import 'package:flutter/material.dart';
import 'package:food_delivery/presentation/utility/assets_path.dart';
import 'package:food_delivery/presentation/widgets/text_style_widget.dart';

class FoodDetailsPage extends StatefulWidget {
  const FoodDetailsPage({super.key});

  @override
  State<FoodDetailsPage> createState() => _FoodDetailsPageState();
}

class _FoodDetailsPageState extends State<FoodDetailsPage> {
  int _countNumber = 1;

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
        child: Column(
          children: [
            Image.asset(
              AssetsPath.productSalad2,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.35,
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Veggiterinian",
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    Text(
                      "CheackPea Salad",
                      style: Theme.of(context).textTheme.headlineLarge,
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
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
                "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
                style: TextStyleWidget.smallTextStyle,
                maxLines: 4,
                overflow: TextOverflow.ellipsis),
            const SizedBox(
              height: 30,
            ),
            Row(
              children: [
                Text("Delivery Time", style: TextStyleWidget.semiTextSyle),
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
            ),
            const Spacer(),
            Padding(
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
                        "\$25",
                        style: TextStyleWidget.semiTextSyle,
                      ),
                    ],
                  ),
                  Container(
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
                ],
              ),
            ),
          ],
        ),
      ),
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
    setState(() {});
  }

  void _decreaseCount() {
    if (_countNumber > 1) {
      _countNumber--;
    } else {
      _countNumber = 1;
    }
    setState(() {});
  }
}
