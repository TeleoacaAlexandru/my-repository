import 'package:flutter/material.dart';
import 'package:flutter_forms_files/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping Planner',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0EA5A6)),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF3FAFA),
      ),
      home: const Home(),
    );
  }
}
