import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants.dart';
import 'package:flutter_application_1/provider/places.dart';
import 'package:flutter_application_1/screens/Home/home_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Places(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'List Shop',
        theme: ThemeData(
          primaryColor: kMainColor,
          scaffoldBackgroundColor: kBgColor
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
