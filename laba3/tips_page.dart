import 'package:flutter/material.dart';

class TipsPage extends StatelessWidget {
  final List<String> tips = [
    '🧘 Розминка перед тренуванням важлива!',
    '💧 Пий воду регулярно.',
    '🛌 Не забувай про відпочинок між підходами.',
    '🧘‍♀️ Йога допомагає з гнучкістю та зменшує стрес.',
    '🕒 Тренування краще проводити в один і той же час.',
    '🍎 Їж здорову їжу після тренування.',
    '🔥 Поступово збільшуй навантаження.',
    '📈 Веди журнал тренувань.',
    '🎧 Улюблена музика підвищує мотивацію.',
    '🧠 Не забувай про гарний настрій - спорт допомагає!',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Корисні поради'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade100, Colors.white],
          ),
        ),
        child: ListView.builder(
          padding: EdgeInsets.all(12),
          itemCount: tips.length,
          itemBuilder: (context, index) => Card(
            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            elevation: 8,  // Легке підвищення тіні
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20), // Більш округлі краї
            ),
            color: Colors.white, // Легкий фон для кожної картки
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              leading: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.lightbulb_outline,
                  color: Colors.orange,
                  size: 32,  // Більша іконка
                ),
              ),
              title: Text(
                tips[index],
                style: TextStyle(
                  fontSize: 18,  // Трохи більший шрифт
                  fontWeight: FontWeight.w500,
                  color: Colors.blue.shade800,  // Темніший колір тексту
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
