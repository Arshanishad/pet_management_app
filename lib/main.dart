import 'package:flutter/material.dart';
import 'package:pet_management_app/provider/pet_provider.dart';
import 'package:pet_management_app/view/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await databaseFactory.getDatabasesPath();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PetProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
