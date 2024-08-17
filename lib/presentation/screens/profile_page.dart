import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/data/service/auth.dart';
import 'package:food_delivery/data/service/save_user_info.dart';
import 'package:food_delivery/presentation/screens/login_page.dart';
import 'package:food_delivery/presentation/utility/assets_path.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? _profile, _name, _email;
  final ImagePicker _imagePicker = ImagePicker();
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _getUserProfilePref();
  }

  Future<void> _getUserProfilePref() async {
    _profile = await SaveUserInfo().getUserProfile();
    _email = await SaveUserInfo().getUserEmail();
    _name = await SaveUserInfo().getUserName();
    setState(() {});
  }

  Future<void> _getPickedImage() async {
    var image = await _imagePicker.pickImage(source: ImageSource.gallery);

    _selectedImage = File(image!.path);
    _uploadImageItem();
    setState(() {});
  }

  Future<void> _uploadImageItem() async {
    try {
      if (_selectedImage != null) {
        String addId = randomAlphaNumeric(10);

        Reference firebaseStorageRef =
            FirebaseStorage.instance.ref().child("blogImages").child(addId);
        final UploadTask uploadTask =
            firebaseStorageRef.putFile(_selectedImage!);

        var downloadUrl = await (await uploadTask).ref.getDownloadURL();
        await SaveUserInfo().saveUserProfile(downloadUrl);
        setState(() {});
      }
    } catch (e) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text(
            "Something Went Wrong for uploading profile image",
            style: TextStyle(fontSize: 18.0),
          ),
        ),
      );
    }
  }

  Future<void> _signOut() async {
    try {
      await Auth.signOutUser();
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.orangeAccent,
          content: Text(
            "Sign Out Sucessfully",
            style: TextStyle(fontSize: 18),
          ),
        ),
      );

      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginPage()));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text(
            "Error Occurred Sign out failed",
            style: TextStyle(fontSize: 18),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _name == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Stack(
                  children: [
                    Container(
                      padding:
                          const EdgeInsets.only(top: 45, left: 20, right: 20),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 5,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.vertical(
                              bottom: Radius.elliptical(
                                  MediaQuery.of(context).size.width, 105))),
                    ),
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height / 8),
                        child: Material(
                          elevation: 10,
                          borderRadius: BorderRadius.circular(60),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(60),
                            child: _selectedImage == null
                                ? GestureDetector(
                                    onTap: () {
                                      _getPickedImage();
                                    },
                                    child: _profile == null
                                        ? Image.asset(
                                            AssetsPath.boy,
                                            height: 110,
                                            width: 110,
                                            fit: BoxFit.cover,
                                          )
                                        : Image.network(
                                            _profile!,
                                            height: 110,
                                            width: 110,
                                            fit: BoxFit.cover,
                                          ),
                                  )
                                : Image.file(
                                    _selectedImage!,
                                    height: 110,
                                    width: 110,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 45, left: 120),
                      child: Text(
                        _name!,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: GoogleFonts.poppins.toString(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Column(
                  children: [
                    _buildUserCard("Name", _name!),
                    const SizedBox(
                      height: 15,
                    ),
                    _buildUserCard("Email", _email!),
                    const SizedBox(
                      height: 15,
                    ),
                    const Card(
                      margin: EdgeInsets.only(left: 10),
                      child: Padding(
                        padding: EdgeInsets.only(left: 5, bottom: 8, top: 8),
                        child: Row(
                          children: [
                            Icon(Icons.description),
                            SizedBox(
                              width: 15,
                            ),
                            Text(
                              "Terms and Condition",
                              style: TextStyle(fontSize: 18),
                            ),
                            SizedBox(
                              height: 3,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    InkWell(
                      onTap: () async {
                        await Auth.deleteUser();

                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => const LoginPage()));
                      },
                      child: const Card(
                        margin: EdgeInsets.only(left: 10),
                        child: Padding(
                          padding: EdgeInsets.only(left: 5, bottom: 8, top: 8),
                          child: Row(
                            children: [
                              Icon(Icons.delete),
                              SizedBox(
                                width: 15,
                              ),
                              Text(
                                "Delete Account",
                                style: TextStyle(fontSize: 18),
                              ),
                              SizedBox(
                                height: 3,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    InkWell(
                      onTap: () async {
                        _signOut();
                      },
                      child: const Card(
                        margin: EdgeInsets.only(left: 10),
                        child: Padding(
                          padding: EdgeInsets.only(left: 5, bottom: 8, top: 8),
                          child: Row(
                            children: [
                              Icon(Icons.logout_outlined),
                              SizedBox(
                                width: 15,
                              ),
                              Text(
                                "LogOut",
                                style: TextStyle(fontSize: 18),
                              ),
                              SizedBox(
                                height: 3,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }

  Widget _buildUserCard(String user, String userDes) {
    return Card(
      margin: const EdgeInsets.only(left: 10),
      child: Padding(
        padding: const EdgeInsets.only(left: 5, bottom: 8, top: 8),
        child: Row(
          children: [
            const Icon(Icons.person),
            const SizedBox(
              width: 15,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 3,
                ),
                Text(userDes,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
