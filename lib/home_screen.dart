import 'dart:io';
import 'dart:math';
import 'package:chips_choice/chips_choice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emailpassword/data_details.dart';
import 'package:emailpassword/models/product_models.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> tag = [];
  List<String> options = [
    'XS',
    'S',
    'M',
    'L',
    'XL',
    'XXL',
  ];

//Random Images
  String generateRandomString(int len) {
    var r = Random();
    const chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => chars[r.nextInt(chars.length)]).join();
  }

  final formkey = GlobalKey();
  bool isLoading = false;
  TextEditingController idController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController offersDetailsController = TextEditingController();
  TextEditingController brandNameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController descriptionsController = TextEditingController();

  final focusId = FocusNode();
  final focusName = FocusNode();
  final focusSize = FocusNode();
  final focusOffersDetails = FocusNode();
  final focusBrandName = FocusNode();
  final focusPrice = FocusNode();
  final focusDescriptions = FocusNode();

  //ImagePicker
  ImagePicker picker = ImagePicker();
  XFile? image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Product Details"),
        ),
        body: ListView(
            children: [
          Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                ElevatedButton(
                    onPressed: () async {
                      image =
                          await picker.pickImage(source: ImageSource.gallery);
                      setState(() {});
                    },
                    child: const Text("Pick Image")),
                image == null
                    ? Container()
                    : CircleAvatar(
                        radius: 30,
                        child: Image.file(
                          File(
                            image!.path,
                          ),
                          height: 30,
                          width: 30,
                        ),
                      ),
                const SizedBox(
                  height: 10,
                ),
                Form(
                  key: formkey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: nameController,
                        focusNode: focusName,
                        decoration: const InputDecoration(
                            labelText: 'name', border: OutlineInputBorder()),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      ChipsChoice<String>.multiple(
                        value: tag,
                        onChanged: (val) => setState(() => tag = val),
                        choiceItems: C2Choice.listFrom<String, String>(
                          source: options,
                          value: (i, v) => v,
                          label: (i, v) => v,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        controller: offersDetailsController,
                        focusNode: focusOffersDetails,
                        decoration: const InputDecoration(
                            labelText: 'offersDetails',
                            border: OutlineInputBorder()),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        controller: brandNameController,
                        focusNode: focusBrandName,
                        decoration: const InputDecoration(
                            labelText: 'BrandName',
                            border: OutlineInputBorder()),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        controller: priceController,
                        focusNode: focusPrice,
                        decoration: const InputDecoration(
                            labelText: 'Price', border: OutlineInputBorder()),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        controller: descriptionsController,
                        focusNode: focusDescriptions,
                        decoration: const InputDecoration(
                            labelText: 'Descriptions',
                            border: OutlineInputBorder()),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Center(
                  child: ElevatedButton(
                      onPressed: () {
                        submit();
                      },
                      child: const Text(
                        "Submit",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      )),
                )
              ],
            ),
          ),
        ]));
  }

  void submit() {
    if (nameController.text.trim().isNotEmpty) {
      if (offersDetailsController.text.trim().isNotEmpty) {
        if (brandNameController.text.trim().isNotEmpty) {
          if (priceController.text.trim().isNotEmpty) {
            if (descriptionsController.text.trim().isNotEmpty) {
              addImage();
            } else {
              SnackBar(
                backgroundColor: Colors.red,
                content: const Text(
                  "descriptions",
                  style: TextStyle(color: Colors.white),
                ),
                action: SnackBarAction(
                  onPressed: () {},
                  label: 'name',
                ),
              );
            }
          } else {
            SnackBar(
              backgroundColor: Colors.red,
              content: const Text(
                "price",
                style: TextStyle(color: Colors.white),
              ),
              action: SnackBarAction(
                onPressed: () {},
                label: 'name',
              ),
            );
          }
        } else {
          SnackBar(
            backgroundColor: Colors.red,
            content: const Text(
              "brandName",
              style: TextStyle(color: Colors.white),
            ),
            action: SnackBarAction(
              onPressed: () {},
              label: 'name',
            ),
          );
        }
      } else {
        SnackBar(
          backgroundColor: Colors.red,
          content: const Text(
            "offerDetails",
            style: TextStyle(color: Colors.white),
          ),
          action: SnackBarAction(
            onPressed: () {},
            label: 'name',
          ),
        );
      }
    } else {
      SnackBar(
        backgroundColor: Colors.red,
        content: const Text(
          'name',
          style: TextStyle(color: Colors.white),
        ),
        action: SnackBarAction(
          onPressed: () {},
          label: 'name',
        ),
      );
    }
  }

  CollectionReference products =
      FirebaseFirestore.instance.collection('products');

  Future<void> addProduct(ProductModel productModel) async {
    products.add(productModel.toJson()).then((value) {
      isLoading = false;
      Get.to(() => const DataDetails());
    }).catchError((error) => print(""
        "Failed to add user: $error"));
  }

  void addImage() {
    FirebaseStorage.instance
        .ref("${generateRandomString(10)}/")
        .putFile(File(image!.path))
        .then((TaskSnapshot taskSnapshot) {
      if (taskSnapshot.state == TaskState.success) {
        if (kDebugMode) {
          print("Image uploaded Successful");
        }
        // Get Image URL Now
        taskSnapshot.ref.getDownloadURL().then((imageURL) {
          if (kDebugMode) {
            print("Image Download URL is $imageURL");
          }
          ProductModel productModel = ProductModel(
            name: nameController.text,
            image: imageURL ?? "",
            size: tag,
            offersDetails: offersDetailsController.text,
            brandName: brandNameController.text,
            price: priceController.text,
            descriptions: descriptionsController.text,
          );
          addProduct(productModel);
        });
      } else if (taskSnapshot.state == TaskState.running) {
      } else if (taskSnapshot.state == TaskState.error) {}
    });
  }
}
