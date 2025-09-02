import 'package:flutter/material.dart';
import 'training_model.dart';
import 'database_helper.dart';
import 'add_training_page.dart';

class TrainingHistoryPage extends StatelessWidget {
  Future<List<Training>> _loadTrainings() async {
    return await DatabaseHelper.instance.getTrainings();
  }

  List<Training> _sortTrainingsByDate(List<Training> trainings) {
    trainings.sort((a, b) => b.date.compareTo(a.date));
    return trainings;
  }

  Widget _buildTrainingsList(List<Training> trainings) {
    return ListView.builder(
      itemCount: trainings.length,
      itemBuilder: (context, index) {
        final training = trainings[index];
        return Card(
          margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          elevation: 3,
          child: ListTile(
            leading: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  training.emoji,
                  style: TextStyle(fontSize: 24),
                ),
              ),
            ),
            title: Text(
              training.type,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${training.duration} хвилин'),
                Text(
                  '${training.date.day}.${training.date.month}.${training.date.year} '
                  '${training.date.hour}:${training.date.minute.toString().padLeft(2, '0')}',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => _editTraining(context, training),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteTraining(context, training.id!),
                ),
              ],
            ),
            onTap: () => _showTrainingDetailsDialog(context, training),
          ),
        );
      },
    );
  }

  void _editTraining(BuildContext context, Training training) async {
    final updatedTraining = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddTrainingPage(training: training),
      ),
    );

    if (updatedTraining != null) {
      await DatabaseHelper.instance.insertTraining(updatedTraining);
      Navigator.pop(context);
    }
  }

  void _deleteTraining(BuildContext context, int id) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Видалити тренування'),
        content: Text('Ви впевнені, що хочете видалити це тренування?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Скасувати'),
          ),
          TextButton(
            onPressed: () async {
              await DatabaseHelper.instance.deleteTraining(id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Тренування видалено')),
              );
              Navigator.pop(context);
            },
            child: Text('Видалити', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showTrainingDetailsDialog(BuildContext context, Training training) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                shape: BoxShape.circle,
              ),
              child: Text(
                training.emoji,
                style: TextStyle(fontSize: 28),
              ),
            ),
            SizedBox(width: 12),
            Text(training.type),
          ],
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Тривалість: ${training.duration} хвилин'),
            SizedBox(height: 12),
            Text('Дата: ${training.date.day}.${training.date.month}.${training.date.year}'),
            SizedBox(height: 4),
            Text('Час: ${training.date.hour}:${training.date.minute.toString().padLeft(2, '0')}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Закрити'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Історія тренувань'),
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
        child: FutureBuilder<List<Training>>(
          future: _loadTrainings(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Помилка: ${snapshot.error}'));
            }
            if (snapshot.hasData) {
              var trainings = _sortTrainingsByDate(snapshot.data!);
              if (trainings.isEmpty) {
                return Center(
                  child: Text(
                    'Немає даних про тренування',
                    style: TextStyle(fontSize: 18),
                  ),
                );
              }
              return _buildTrainingsList(trainings);
            }
            return Center(child: Text('Немає даних про тренування'));
          },
        ),
      ),
    );
  }
}