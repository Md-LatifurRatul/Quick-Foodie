import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/presentation/screens/forgot_password_page.dart';
import 'package:food_delivery/presentation/screens/main_bottom_nav_bar.dart';
import 'package:food_delivery/presentation/utility/constants.dart';
import 'package:food_delivery/presentation/screens/sign_up_screen.dart';
import 'package:food_delivery/presentation/widgets/text_style_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? _password;
  String? _email;
  bool _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();

  Future<void> _userLogin() async {
    try {
      _isLoading = true;
      setState(() {});
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _email ?? '', password: _password ?? '');

      if (mounted) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const MainBottomNavBar()));
      }
    } on FirebaseException catch (e) {
      if (e.code == 'user-not-found') {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "No User Found for that Email",
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
            ),
          );
        }
      } else if (e.code == 'wrong-password') {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                "Wrong Password Provided by User",
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
            ),
          );
        }
      }
    } finally {
      _isLoading = false;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.loginBg,
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.07,
            vertical: MediaQuery.of(context).size.height * 0.08),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              TextFormField(
                controller: _emailTEController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  hintText: "Email",
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: Constants.defpaultPadding),
                child: TextFormField(
                  obscureText: true,
                  controller: _passwordTEController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: "Password",
                    prefixIcon: Icon(Icons.password),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const ForgotPasswordPage()));
                },
                child: const Text(
                  "Forgot Password?",
                  style: TextStyle(color: Color.fromARGB(255, 243, 152, 145)),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.06,
                child: ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () async {
                          if (_formKey.currentState!.validate()) {
                            _email = _emailTEController.text;

                            _password = _passwordTEController.text;
                            setState(() {});
                            await _userLogin();
                          }
                        },
                  child: _isLoading
                      ? const CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      : Text(
                          "Login",
                          style: TextStyleWidget.semiTextSyle,
                        ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't Have Account?",
                    style: TextStyle(color: Color.fromARGB(255, 236, 224, 223)),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignUpScreen()));
                    },
                    child: const Text(
                      "Sign Up",
                      style:
                          TextStyle(color: Color.fromARGB(255, 236, 224, 223)),
                    ),
                  ),
                ],
              ),
              const Spacer(
                flex: 1,
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailTEController.dispose();
    _passwordTEController.dispose();
    super.dispose();
  }
}
