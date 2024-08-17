import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/data/service/database.dart';
import 'package:food_delivery/presentation/widgets/text_style_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';

class AddFoodItem extends StatefulWidget {
  const AddFoodItem({super.key});

  @override
  State<AddFoodItem> createState() => _AddFoodItemState();
}

class _AddFoodItemState extends State<AddFoodItem> {
  final TextEditingController _itemNameTEController = TextEditingController();
  final TextEditingController _itemPriceTEController = TextEditingController();
  final TextEditingController _itemDetailTEController = TextEditingController();
  String? value;

  bool _isLoading = false;

  final ImagePicker _imagePicker = ImagePicker();
  File? _selectedImage;

  final List<String> _foodCategoryItems = [
    'Ice-Cream',
    'Burger',
    "Salad",
    "Pizza"
  ];

  Future<void> _getPickedImage() async {
    var image = await _imagePicker.pickImage(source: ImageSource.gallery);

    _selectedImage = File(image!.path);
    setState(() {});
  }

  Future<void> _uploadImageItem() async {
    try {
      _isLoading = true;
      setState(() {});
      if (_selectedImage != null &&
          _itemNameTEController.text != "" &&
          _itemPriceTEController.text != "" &&
          _itemDetailTEController.text != "") {
        String addId = randomAlphaNumeric(10);

        Reference firebaseStorageRef =
            FirebaseStorage.instance.ref().child("blogImages").child(addId);
        final UploadTask uploadTask =
            firebaseStorageRef.putFile(_selectedImage!);

        var downloadUrl = await (await uploadTask).ref.getDownloadURL();
        Map<String, dynamic> addItem = {
          "Image": downloadUrl,
          "Name": _itemNameTEController.text,
          "Price": _itemPriceTEController.text,
          "Detail": _itemDetailTEController.text
        };

        await Database.addFoodItems(addItem, value!).then(
          (value) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: Colors.orangeAccent,
                  content: Text(
                    "Food Item has been added Successfully",
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
              );
            }
          },
        );

        _isLoading = false;
        _itemNameTEController.clear();
        _itemPriceTEController.clear();
        _itemDetailTEController.clear();
        _selectedImage = null;
        value = null;
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
            "Food Item has not been added! Try again",
            style: TextStyle(fontSize: 18.0),
          ),
        ),
      );
    }
    _isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: const Text(
          "Add Item",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 10, bottom: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Upload the Item Picture",
                style: TextStyleWidget.semiTextSyle,
              ),
              const SizedBox(
                height: 20,
              ),
              _selectedImage == null
                  ? GestureDetector(
                      onTap: () {
                        _getPickedImage();
                      },
                      child: Center(
                        child: SizedBox(
                          height: _size.height / 5,
                          width: _size.width / 2.5,
                          child: const Card(
                            elevation: 5,
                            child: Icon(Icons.camera_alt_outlined),
                          ),
                        ),
                      ),
                    )
                  : Center(
                      child: SizedBox(
                        height: _size.height / 5,
                        width: _size.width / 2.5,
                        child: Card(
                          elevation: 5,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              _selectedImage!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
              const SizedBox(
                height: 25,
              ),
              Text(
                "Item Name",
                style: TextStyleWidget.semiTextSyle,
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 55,
                child: TextFormField(
                  controller: _itemNameTEController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)),
                      hintStyle: const TextStyle(color: Colors.black26),
                      hintText: 'Enter Item Name'),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Item Price",
                style: TextStyleWidget.semiTextSyle,
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 55,
                child: TextFormField(
                  controller: _itemPriceTEController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)),
                      hintStyle: const TextStyle(color: Colors.black26),
                      hintText: 'Enter Item Price'),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                "Item Details",
                style: TextStyleWidget.semiTextSyle,
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                maxLines: 1,
                controller: _itemDetailTEController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)),
                    hintStyle: const TextStyle(color: Colors.black26),
                    hintText: 'Enter Item Details'),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Select Category",
                style: TextStyleWidget.semiTextSyle,
              ),
              const SizedBox(
                height: 5,
              ),
              Container(
                width: _size.width,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    color: const Color(0xFFececf8),
                    borderRadius: BorderRadius.circular(10)),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    items: _foodCategoryItems
                        .map(
                          (item) => DropdownMenuItem<String>(
                            value: item,
                            child: Text(
                              item,
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.black),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      this.value = value;
                      setState(() {});
                    },
                    dropdownColor: Colors.white,
                    hint: const Text("Select Category"),
                    iconSize: 36,
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      color: Colors.black,
                    ),
                    value: value,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.black),
                  onPressed: _isLoading
                      ? null
                      : () {
                          _uploadImageItem();
                        },
                  child: const Text(
                    "Add",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
