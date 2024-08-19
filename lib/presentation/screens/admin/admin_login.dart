import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/presentation/screens/admin/admin_home.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final TextEditingController _usernameTEcontroller = TextEditingController();
  final TextEditingController _userpasswordTEcontroller =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFededeb),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              margin:
                  EdgeInsets.only(top: MediaQuery.of(context).size.height / 2),
              padding: const EdgeInsets.only(top: 45, left: 20, right: 20),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      colors: [Color.fromARGB(255, 53, 51, 51), Colors.black],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight),
                  borderRadius: BorderRadius.vertical(
                      top: Radius.elliptical(
                          MediaQuery.of(context).size.width, 110.0))),
            ),
            Container(
              margin: const EdgeInsets.only(left: 30, right: 30, top: 50),
              child: Form(
                key: _formkey,
                child: Column(
                  children: [
                    const Text(
                      "Let's start with\nAdmin!",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    Material(
                      elevation: 3,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        height: MediaQuery.of(context).size.height / 2,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: _buildAdminLoginForm(context),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildAdminLoginForm(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 50.0,
        ),
        Container(
          padding: const EdgeInsets.only(
            left: 20,
            top: 5,
          ),
          margin: const EdgeInsets.symmetric(horizontal: 15.0),
          decoration: BoxDecoration(
            border: Border.all(color: const Color.fromARGB(255, 160, 160, 147)),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: TextFormField(
              controller: _usernameTEcontroller,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please Enter Username';
                }
                return null;
              },
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "Username",
                hintStyle: TextStyle(
                  color: Color.fromARGB(255, 160, 160, 147),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 30.0,
        ),
        Container(
          padding: const EdgeInsets.only(
            left: 20.0,
            top: 5.0,
          ),
          margin: const EdgeInsets.symmetric(horizontal: 20.0),
          decoration: BoxDecoration(
              border:
                  Border.all(color: const Color.fromARGB(255, 160, 160, 147)),
              borderRadius: BorderRadius.circular(10)),
          child: Center(
            child: TextFormField(
              controller: _userpasswordTEcontroller,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please Enter Password';
                }
                return null;
              },
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Password",
                  hintStyle:
                      TextStyle(color: Color.fromARGB(255, 160, 160, 147))),
            ),
          ),
        ),
        const SizedBox(
          height: 20.0,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width / 1.3,
          child: ElevatedButton(
            onPressed: () {
              _loginAdmin();
            },
            child: const Text(
              "Login",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        )
      ],
    );
  }

  Future<void> _loginAdmin() async {
    FirebaseFirestore.instance.collection('Admin').get().then((snapshot) {
      for (var result in snapshot.docs) {
        if (result.data()['id'] != _usernameTEcontroller.text.trim()) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Colors.orangeAccent,
                content: Text(
                  "Your id is not correct",
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
            );
          }
        } else if (result.data()['password'] !=
            _userpasswordTEcontroller.text.trim()) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Colors.orangeAccent,
                content: Text(
                  "Your password is not correct",
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
            );
          }
        } else {
          Route route =
              MaterialPageRoute(builder: (context) => const AdminHome());
          if (mounted) {
            Navigator.pushReplacement(context, route);
          }
        }
      }
    });
  }
}
