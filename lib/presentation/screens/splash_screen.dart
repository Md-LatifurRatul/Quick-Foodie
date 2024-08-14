import 'package:flutter/material.dart';
import 'package:food_delivery/data/models/onboarding_content_list_model.dart';
import 'package:food_delivery/presentation/widgets/onboarding_screen_widget.dart';
import 'package:food_delivery/presentation/widgets/page_indicator.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  final OnboardingContentListModel _onboardingModel =
      OnboardingContentListModel();
  int _currentPageIndex = 0;
  late PageController _pageViewController;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _pageViewController = PageController();
    _tabController = TabController(
        length: _onboardingModel.onboardingContents.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final _onboardData = _onboardingModel.onboardingContents;

    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView(
            controller: _pageViewController,
            onPageChanged: _handPageViewChanged,
            children: [
              OnboardingScreenWidget(
                onboardImage: _onboardData[0].image,
                onboardTitle: _onboardData[0].title,
                onboardDiscription: _onboardData[0].description,
              ),
              OnboardingScreenWidget(
                onboardImage: _onboardData[1].image,
                onboardTitle: _onboardData[1].title,
                onboardDiscription: _onboardData[1].description,
              ),
              OnboardingScreenWidget(
                  onboardImage: _onboardData[2].image,
                  onboardTitle: _onboardData[2].title,
                  onboardDiscription: _onboardData[2].description),
            ],
          ),
          PageIndicator(
              currentPageIndex: _currentPageIndex,
              tabController: _tabController,
              onUpdateCurrentPageIndex: _updateCurrentPageIndex),
        ],
      ),
    );
  }

  void _handPageViewChanged(int currentPageIndex) {
    _tabController.index = currentPageIndex;
    setState(() {
      _currentPageIndex = currentPageIndex;
    });
  }

  void _updateCurrentPageIndex(int index) {
    if (index >= 0 && index < _tabController.length) {
      _tabController.index = index;
      _pageViewController.animateToPage(index,
          duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
    } else {
      // Handle the error, maybe with a debug print or logging
      print("Index out of bounds: $index");
    }
  }

  @override
  void dispose() {
    _pageViewController.dispose();
    _tabController.dispose();
    super.dispose();
  }
}
