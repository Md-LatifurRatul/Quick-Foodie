import 'package:food_delivery/data/models/onboarding_content.dart';
import 'package:food_delivery/presentation/utility/assets_path.dart';

class OnboardingContentListModel {
  List<OnboardingContent> onboardingContents = [
    OnboardingContent(
      image: AssetsPath.showingScreen1,
      title: "Select from Our Best Menu",
      description: "Pick your food from our menu\nAny Amount You need",
    ),
    OnboardingContent(
        image: AssetsPath.showingScreen2,
        title: "Easy and Online Payment",
        description:
            "You can pay cash on delivery and\nCard payment is availabe"),
    OnboardingContent(
        image: AssetsPath.showingScreen3,
        title: "Quick delivery at your doorstep",
        description: "Deliver your food\nat your doorstep"),
  ];
}
