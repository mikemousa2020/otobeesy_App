import 'package:flutter/material.dart';
import 'callApi.dart';
import 'homePage.dart';
//import 'homePage.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  build(context) {
    return MaterialApp(
      
      debugShowCheckedModeBanner: false,
      title: appTitle,
      
      theme: ThemeData(
        iconTheme: const IconThemeData(
            color: Colors.blue,
            opacity: 1.0,
            size: 50.0
        ),
        fontFamily: "cairo",
      ),
      home:      
      
      HomePage(),

    );
  }
}

