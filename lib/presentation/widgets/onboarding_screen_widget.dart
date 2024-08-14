import 'package:flutter/material.dart';
import 'package:food_delivery/presentation/widgets/text_style_widget.dart';

class OnboardingScreenWidget extends StatelessWidget {
  const OnboardingScreenWidget(
      {super.key,
      required this.onboardImage,
      required this.onboardTitle,
      required this.onboardDiscription});

  final String onboardImage;
  final String onboardTitle;
  final String onboardDiscription;

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              onboardImage,
              height: _size.height * 0.6,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              onboardTitle,
              style: TextStyleWidget.semiTextSyle,
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              onboardDiscription,
              style: TextStyleWidget.smallTextStyle,
            ),
          ],
        ),
      ),
    );
  }
}
