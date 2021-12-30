import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:online_course/global.dart';
import 'package:online_course/models/registrasi.dart';
import 'package:online_course/page/homepage.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(RegistrasiAdapter());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Global.appName,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.indigo,
      ),
      home: const HomePage(),
    );
  }
}
