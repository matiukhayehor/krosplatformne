import 'package:flutter/material.dart';
import 'home_page.dart';

void main() {
  runApp(FitnessApp());
}

class FitnessApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Фітнес Трекер',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light, // Світла тема
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark, // Темна тема
      ),
      themeMode: ThemeMode.system, // Автоматичний вибір теми в залежності від налаштувань системи
      home: HomePage(),
    );
  }
}
