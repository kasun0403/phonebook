import 'package:flutter/material.dart';
import 'package:phonebook/constants/constants.dart';
import 'package:phonebook/constants/text_style.dart';
import 'package:phonebook/db/db_controller.dart';
import 'package:phonebook/model/phone_model.dart';
import 'package:phonebook/pages/add_user_page.dart';
import 'package:phonebook/pages/edit_user_page.dart';
import 'package:phonebook/util/util_functions.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PhoneModel? phoneModel;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Text("Phone Book", style: appBarStyle),
          centerTitle: true,
          actions: [
            InkWell(
              onTap: () {
                UtilFunctions().navigateTo(context, AddUserPage());
              },
              child: Row(
                children: [
                  Text(
                    "Add +",
                    style: appBarStyle,
                  ),
                  SizedBox(
                    width: size.width * 0.05,
                  )
                ],
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: SizedBox(
            height: size.height,
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: size.width / 40, vertical: size.height / 50),
              child: StreamBuilder<List<PhoneModel>>(
                stream: DatabaseController().getUsers(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final contact = snapshot.data!;
                    return ListView.builder(
                      itemCount: contact.length,
                      itemBuilder: (context, index) {
                        final contacts = snapshot.data![index];
                        return Card(
                          shadowColor: blue,
                          child: InkWell(
                            onTap: () => launch("tel:${contacts.phoneNumber}"),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  margin:
                                      EdgeInsets.only(left: size.width / 40),
                                  height: size.height / 8,
                                  width: size.width / 8,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(width: 1, color: blue),
                                    image: DecorationImage(
                                      image: NetworkImage(contacts.image!),
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: size.width * 0.05,
                                ),
                                Container(
                                  width: size.width / 3,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        contacts.name,
                                        style: homeBodyText,
                                      ),
                                      Text(
                                        contacts.phoneNumber,
                                        style: homeBodyText,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: size.width / 8,
                                ),
                                IconButton(
                                    onPressed: () {
                                      UtilFunctions().navigateTo(context,
                                          EditUserPage(contacts: contacts));
                                    },
                                    icon: Icon(Icons.edit)),
                                IconButton(
                                    onPressed: () {
                                      DatabaseController().deleteUser(contacts);
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      color: red,
                                    ))
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
          ),
        ));
  }
}
