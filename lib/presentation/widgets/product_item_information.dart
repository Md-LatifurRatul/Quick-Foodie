import 'package:flutter/material.dart';
import 'package:food_delivery/presentation/screens/food_details_page.dart';

class ProductItemInformation extends StatelessWidget {
  const ProductItemInformation({
    super.key,
    required this.foodName,
    required this.foodInfo,
    required this.foodPrice,
    required this.layoutAxis,
    required this.productImagePath,
  });

  final String foodName;
  final String foodInfo;
  final String foodPrice;
  final Axis layoutAxis;
  final String productImagePath;

  @override
  Widget build(BuildContext context) {
    final TextTheme headLineText = Theme.of(context).textTheme;

    Widget content = layoutAxis == Axis.vertical
        ? _foodCardVertical(headLineText)
        : _foodCartHorizontal(headLineText);

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => FoodDetailsPage(
                  productName: foodName,
                  productDetail: foodInfo,
                  productImage: productImagePath,
                  productPrice: foodPrice,
                )));
      },
      child: Card(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.only(left: 6),
          child: content,
        ),
      ),
    );
  }

  Widget _foodCartHorizontal(TextTheme headLineText) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.network(
          productImagePath,
          height: 110,
          width: 110,
          fit: BoxFit.cover,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                foodName,
                style: headLineText.headlineMedium,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                foodInfo,
                style: headLineText.headlineSmall,
              ),
              Text(
                "\$$foodPrice",
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
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.network(
          productImagePath,
          height: 120,
          width: 120,
          fit: BoxFit.cover,
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          foodName,
          style: headLineText.headlineMedium,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          foodInfo,
          style: headLineText.headlineSmall,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          "\$$foodPrice",
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ],
    );
  }
}
