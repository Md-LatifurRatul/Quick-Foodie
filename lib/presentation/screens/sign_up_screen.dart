import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/data/service/database.dart';
import 'package:food_delivery/data/service/save_user_info.dart';
import 'package:food_delivery/presentation/screens/login_page.dart';
import 'package:food_delivery/presentation/utility/assets_path.dart';
import 'package:food_delivery/presentation/widgets/text_style_widget.dart';
import 'package:random_string/random_string.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String name = '';
  String? _password;
  String _email = '';
  bool _isLoading = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameTEController = TextEditingController();

  final TextEditingController _passwordTEController = TextEditingController();
  final TextEditingController _emailTEController = TextEditingController();
  final SaveUserInfo _saveUserInfo = SaveUserInfo();

  Future<void> _userRegistration() async {
    _isLoading = true;
    setState(() {});
    if (_password != null) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: _email, password: _password ?? '');

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.redAccent,
              content: Text(
                "Registered Successfully",
                style: TextStyle(fontSize: 20),
              ),
            ),
          );
        }

        String id = randomAlpha(10);

        Map<String, dynamic> _addUserInfo = {
          "Name": _nameTEController.text,
          'Email': _emailTEController.text,
          'Wallet': "0",
          "Id": id
        };
        await Database.addUserDetail(_addUserInfo, id);

        await _saveUserInfo.saveUserName(_nameTEController.text);
        await _saveUserInfo.saveUserEmail(_emailTEController.text);
        await _saveUserInfo.saveUserWallet('0');
        await _saveUserInfo.saveUserId(id);

        if (!mounted) {
          return;
        }

        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const LoginPage()));
      } on FirebaseException catch (e) {
        if (e.code == 'weak-password') {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Colors.orangeAccent,
                content: Text(
                  "Password Provied is too weak",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            );
          }
        } else if (e.code == 'email-already-in-use') {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Colors.orangeAccent,
                content: Text(
                  "Account Already exists",
                  style: TextStyle(fontSize: 18),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 2.2,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFff5c30),
                  Color(0xFFe74b1a),
                ],
              ),
            ),
          ),
          Container(
            margin:
                EdgeInsets.only(top: MediaQuery.of(context).size.height / 3),
            height: MediaQuery.of(context).size.height / 2,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40))),
            child: const Text(""),
          ),
          Container(
            margin: const EdgeInsets.only(top: 60.0, left: 20.0, right: 20.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Center(
                      child: Image.asset(
                    AssetsPath.productLogo,
                    width: MediaQuery.of(context).size.width / 1.5,
                    fit: BoxFit.cover,
                  )),
                  const SizedBox(
                    height: 50.0,
                  ),
                  Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 1.7,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20)),
                      child: Form(
                        key: _formKey,
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Column(
                            children: [
                              // const SizedBox(
                              //   height: 10.0,
                              // ),
                              Text(
                                "Sign up",
                                style: TextStyleWidget.semiTextSyle,
                              ),
                              // const SizedBox(
                              //   height: 5.0,
                              // ),
                              TextFormField(
                                controller: _nameTEController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please Enter Name';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                    hintText: 'Name',
                                    hintStyle: TextStyleWidget.semiTextSyle,
                                    prefixIcon:
                                        const Icon(Icons.person_outlined)),
                              ),
                              const SizedBox(
                                height: 30.0,
                              ),
                              TextFormField(
                                controller: _emailTEController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please Enter E-mail';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                    hintText: 'Email',
                                    hintStyle: TextStyleWidget.semiTextSyle,
                                    prefixIcon:
                                        const Icon(Icons.email_outlined)),
                              ),
                              const SizedBox(
                                height: 30.0,
                              ),
                              TextFormField(
                                controller: _passwordTEController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please Enter Password';
                                  }
                                  return null;
                                },
                                obscureText: true,
                                decoration: InputDecoration(
                                    hintText: 'Password',
                                    hintStyle: TextStyleWidget.semiTextSyle,
                                    prefixIcon:
                                        const Icon(Icons.password_outlined)),
                              ),
                              const SizedBox(
                                height: 40.0,
                              ),
                              GestureDetector(
                                onTap: _isLoading
                                    ? null
                                    : () async {
                                        if (_formKey.currentState!.validate()) {
                                          setState(() {
                                            _email = _emailTEController.text;
                                            name = _nameTEController.text;
                                            _password =
                                                _passwordTEController.text;
                                          });
                                        }
                                        await _userRegistration();
                                      },
                                child: Material(
                                  elevation: 5.0,
                                  borderRadius: BorderRadius.circular(20),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    width: 200,
                                    decoration: BoxDecoration(
                                        color: const Color(0Xffff5722),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Center(
                                      child: _isLoading
                                          ? const CircularProgressIndicator(
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      Colors.white),
                                            )
                                          : const Text(
                                              "SIGN UP",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18.0,
                                                  fontFamily: 'Poppins1',
                                                  fontWeight: FontWeight.bold),
                                            ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 40.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account?",
                        style: TextStyleWidget.semiTextSyle,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginPage()));
                        },
                        child: Text(
                          "Login",
                          style: TextStyleWidget.semiTextSyle,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameTEController.dispose();
    _emailTEController.dispose();
    _passwordTEController.dispose();
    super.dispose();
  }
}
