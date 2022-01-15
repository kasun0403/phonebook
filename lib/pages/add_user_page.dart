import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phonebook/constants/constants.dart';
import 'package:phonebook/constants/text_style.dart';
import 'package:phonebook/db/db_controller.dart';
import 'package:phonebook/model/phone_model.dart';
import 'package:phonebook/util/util_functions.dart';
import 'package:phonebook/widgets/text_field.dart';

class AddUserPage extends StatefulWidget {
  AddUserPage({
    Key? key,
  }) : super(key: key);

  @override
  _AddUserPageState createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  final _formKey = GlobalKey<FormState>();
  PhoneModel? phoneModel;
  File? pickFile;
  bool? isLoading;
  String urls = "";
  final ImagePicker imagePicker = ImagePicker();
  List<PhoneModel> phoneDataList = [];
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNoController = TextEditingController();

  getImage() async {
    var img = await imagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      pickFile = File(img!.path);
    });
  }

  uploadFile() async {
    var imageFile =
        await FirebaseStorage.instance.ref().child("users").child("/.jpg");
    UploadTask task = imageFile.putFile(pickFile!);
    TaskSnapshot snapshot = await task;
    urls = await snapshot.ref.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme,
        title: Text(
          "Add Contact",
          style: appBarStyle,
        ),
        centerTitle: true,
        elevation: 0,
        leading: InkWell(
            onTap: () {
              UtilFunctions().navigateBack(context);
            },
            child: Icon(
              Icons.arrow_back,
              color: white,
            )),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: size.height / 1.2,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: size.width / 20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: size.height / 40),
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      CircleAvatar(
                        radius: 90,
                        backgroundImage: pickFile == null
                            ? AssetImage("assets/images/user1.png")
                            : FileImage(File(pickFile!.path)) as ImageProvider,
                      ),
                      Positioned(
                        bottom: 15,
                        right: 3,
                        child: IconButton(
                          icon: Icon(
                            Icons.add_a_photo_rounded,
                            size: 45,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            getImage();
                          },
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: size.height / 40),
                  MyInputField(
                    title: "Name",
                    hint: "Enter Name",
                    controller: nameController,
                  ),
                  SizedBox(height: size.height / 40),
                  MyInputField(
                    title: "Phone Number",
                    hint: "Enter Phone Number",
                    maxline: 5,
                    controller: phoneNoController,
                  ),
                  SizedBox(height: size.height / 20),
                  InkWell(
                    onTap: () async {
                      await validateData();
                      await uploadFile();
                      await DatabaseController().createUser(
                        name: nameController.text,
                        phoneNumber: phoneNoController.text,
                        image: urls,
                      );
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: size.width,
                      height: size.height / 15,
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(20)),
                      child: Text(
                        "Add Contact",
                        style: btnText,
                      ),
                    ),
                  ),
                  SizedBox(height: size.height / 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  validateData() {
    if (nameController.text.isNotEmpty && phoneNoController.text.isNotEmpty) {
    } else if (nameController.text.isEmpty || phoneNoController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: black,
          content: Text(
            'Add All Data',
          )));
    }
  }
}
