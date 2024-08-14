import 'package:flutter/material.dart';
import 'package:food_delivery/presentation/screens/food_details_page.dart';
import 'package:food_delivery/presentation/utility/assets_path.dart';

class ProductItemInformation extends StatelessWidget {
  const ProductItemInformation({
    super.key,
    required this.foodName,
    required this.foodInfo,
    required this.foodPrice,
    required this.layoutAxis,
  });

  final String foodName;
  final String foodInfo;
  final String foodPrice;
  final Axis layoutAxis;

  @override
  Widget build(BuildContext context) {
    final TextTheme headLineText = Theme.of(context).textTheme;

    Widget content = layoutAxis == Axis.vertical
        ? _foodCardVertical(headLineText)
        : _foodCartHorizontal(headLineText);

    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const FoodDetailsPage()));
        },
        child: Card(
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: content,
          ),
        ),
      ),
    );
  }

  Widget _foodCartHorizontal(TextTheme headLineText) {
    return Row(
      children: [
        Image.asset(
          AssetsPath.productSalad2,
          height: 120,
          width: 120,
          fit: BoxFit.cover,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                foodName,
                style: headLineText.headlineMedium,
              ),
              Text(
                foodInfo,
                style: headLineText.headlineSmall,
              ),
              Text(
                foodPrice,
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _foodCardVertical(TextTheme headLineText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(
          AssetsPath.productSalad2,
          height: 150,
          width: 150,
          fit: BoxFit.cover,
        ),
        Text(
          foodName,
          style: headLineText.headlineMedium,
        ),
        Text(
          foodInfo,
          style: headLineText.headlineSmall,
        ),
        Text(
          foodPrice,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ],
    );
  }
}
