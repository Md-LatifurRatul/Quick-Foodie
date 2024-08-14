import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/presentation/screens/food_delivery_home_page.dart';
import 'package:food_delivery/presentation/screens/food_order_page.dart';
import 'package:food_delivery/presentation/screens/profile_page.dart';
import 'package:food_delivery/presentation/screens/wallet_page.dart';

class MainBottomNavBar extends StatefulWidget {
  const MainBottomNavBar({super.key});

  @override
  State<MainBottomNavBar> createState() => _MainBottomNavBarState();
}

class _MainBottomNavBarState extends State<MainBottomNavBar> {
  int _currentNavIndex = 0;
  final List<Widget> _pages = [
    const FoodDeliveryHomePage(),
    const FoodOrderPage(),
    const WalletPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.blueAccent,
        buttonBackgroundColor: Colors.white,
        color: Colors.white,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 500),
        onTap: (index) {
          setState(
            () {
              _currentNavIndex = index;
            },
          );
        },
        // letIndexChange: (index) => true,
        items: const [
          Icon(
            Icons.home_outlined,
            size: 30,
          ),
          Icon(
            Icons.shopping_bag_outlined,
            size: 30,
          ),
          Icon(
            Icons.wallet_outlined,
            size: 30,
          ),
          Icon(
            Icons.person_outline,
            size: 30,
          ),
        ],
      ),
      body: _pages[_currentNavIndex],
    );
  }
}
