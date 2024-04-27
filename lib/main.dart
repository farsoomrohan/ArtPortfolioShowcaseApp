import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:test/portfolio_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Artfolio',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const PortfolioListScreen(),
    );
  }
}
