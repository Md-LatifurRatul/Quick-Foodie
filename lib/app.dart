import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/presentation/screens/main_bottom_nav_bar.dart';
import 'package:food_delivery/presentation/screens/splash_screen.dart';
import 'package:food_delivery/presentation/utility/constants.dart';
import 'package:google_fonts/google_fonts.dart';

class FoodDeliveryApp extends StatefulWidget {
  const FoodDeliveryApp({super.key});

  @override
  State<FoodDeliveryApp> createState() => _FoodDeliveryAppState();
}

class _FoodDeliveryAppState extends State<FoodDeliveryApp> {
  @override
  Widget build(BuildContext context) {
    User? _user = FirebaseAuth.instance.currentUser;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: _user != null ? const MainBottomNavBar() : const SplashScreen(),
      theme: ThemeData(
          textTheme: TextTheme(
            headlineLarge: _textHeaderStyleBase.copyWith(fontSize: 20),
            headlineMedium: _textHeaderStyleBase.copyWith(fontSize: 16),
            headlineSmall: _textHeaderStyleBase.copyWith(
                color: Colors.black38,
                fontWeight: FontWeight.w500,
                fontSize: 14),
          ),
          inputDecorationTheme: _inputDecorationThemeStyle(),
          elevatedButtonTheme: _elevatedButtonThemeDataStyle()),
    );
  }

  ElevatedButtonThemeData _elevatedButtonThemeDataStyle() {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.amber,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  InputDecorationTheme _inputDecorationThemeStyle() {
    return const InputDecorationTheme(
      filled: true,
      fillColor: Colors.white38,
      border: InputBorder.none,
      hintStyle: TextStyle(color: Colors.white),
      contentPadding: EdgeInsets.symmetric(
          vertical: Constants.defpaultPadding * 1.2,
          horizontal: Constants.defpaultPadding),
    );
  }

  final TextStyle _textHeaderStyleBase = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontFamily: GoogleFonts.poppins().fontFamily,
  );
}
