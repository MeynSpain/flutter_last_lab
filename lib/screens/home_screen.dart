import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_last_lab/controller/user_controller.dart';
import 'package:flutter_last_lab/screens/Widgets/http_widget.dart';
import 'package:flutter_last_lab/screens/Widgets/registation_form_widget.dart';
import 'package:flutter_last_lab/screens/Widgets/update_form_widget.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../model/model.dart';
import 'package:crypto/crypto.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final UserController userController = Get.find();
  late User _user;
  final String weatherUrl = 'https://www.gismeteo.ru';
  final String calcUrl = 'https://okcalc.com/ru/';

  @override
  void initState() {
    _user = userController.user;

    super.initState();
  }


  Future<void> launchURL(String url) async {
    final Uri _url = Uri.parse(url);

    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home screen'),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Profile: ' ,
                      style: TextStyle(fontSize: 20, color: Colors.white24),
                    ),
                    TextSpan(
                      text: '${_user.login}',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    )
                  ]
                ),


              ),
              trailing: GestureDetector(
                child: Icon(Icons.settings),
                onTap: () {
                  print('Settings');
                  _showFormSettings(context);
                },
              ),
              tileColor: Colors.blue,
            ),
            ListTile(
              leading: Icon(Icons.calculate),
              title: Text('Calculator'),
              onTap: () async {
                 launchURL(calcUrl);
              },
            ),
            ListTile(
              leading: Icon(Icons.cloud),
              title: Text('Weather'),
              onTap: () async{
                 launchURL(weatherUrl);
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Exit'),
              onTap: () {
                Get.offNamed('/login');
              },
            )
          ],
        ),
      ),
      body: HttpWidget(),
    );
  }

  void _showFormSettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: UpdateFormWidget(
            // context: context,
              isTransition: false,
              user: _user),
          actions: [
            TextButton(
              onPressed: () async {
                if (await userController.saveUser()) {
                  Navigator.of(context).pop(); // закрываем диалоговое окно
                }

              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
