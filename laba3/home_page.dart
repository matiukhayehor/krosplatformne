import 'dart:math';
import 'package:flutter/material.dart';
import 'add_training_page.dart';
import 'training_history_page.dart';
import 'tips_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, String>> weatherOptions = [
    {'type': 'Сонячно ☀️'},
    {'type': 'Хмарно ☁️'},
    {'type': 'Дощ 🌧️'},
    {'type': 'Вітер 🌬️'},
    {'type': 'Сніг ❄️'},
  ];

  String todayWeather = '';
  final List<String> availableWorkouts = [
    'Кардіо 🏃',
    'Силове 💪',
    'Йога 🧘',
    'Пілатес 🤸',
    'Розтяжка 🦵',
    'Плавання 🏊',
    'Велосипед 🚴',
  ];

  @override
  void initState() {
    super.initState();
    generateRandomWeather();
  }

  void generateRandomWeather() {
    final random = Random();
    setState(() {
      todayWeather =
          weatherOptions[random.nextInt(weatherOptions.length)]['type']!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Фітнес Трекер'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 10,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade100, Colors.white],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  _buildMenuButton(
                    context,
                    '➕ Додати тренування',
                    () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => AddTrainingPage())),
                  ),
                  SizedBox(height: 15),
                  _buildMenuButton(
                    context,
                    '📅 Перегляд тренувань',
                    () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => TrainingHistoryPage())),
                  ),
                  SizedBox(height: 15),
                  _buildMenuButton(
                    context,
                    '💡 Корисні поради',
                    () => Navigator.push(
                        context, MaterialPageRoute(builder: (_) => TipsPage())),
                  ),
                ],
              ),
              _buildWeatherAndWorkouts(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeatherAndWorkouts() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildWeather(),
          SizedBox(height: 20),
          _buildWorkouts(),
        ],
      ),
    );
  }

  Widget _buildWeather() {
    return Column(
      children: [
        Text(
          'Погода сьогодні:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text(
          todayWeather,
          style: TextStyle(fontSize: 24, color: Colors.blue.shade800),
        ),
      ],
    );
  }

  Widget _buildWorkouts() {
    return Column(
      children: [
        Text(
          'Доступні тренування сьогодні:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 10,
          runSpacing: 5,
          children: availableWorkouts
              .map((w) => Chip(
                    label: Text(
                      w,
                      style: TextStyle(color: Colors.blue.shade800),
                    ),
                    backgroundColor: Colors.blue.shade50,
                    // видалили onDeleted, щоб не було хрестика
                  ))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildMenuButton(
      BuildContext context, String text, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Text(text, style: TextStyle(fontSize: 18)),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.blue.shade800,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 3,
          side: BorderSide(color: Colors.blue.shade200, width: 1),
        ),
      ),
    );
  }
}
