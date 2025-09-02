import 'package:flutter/material.dart';
import 'training_model.dart';
import 'database_helper.dart';

class AddTrainingPage extends StatefulWidget {
  final Training? training;

  AddTrainingPage({this.training});

  @override
  _AddTrainingPageState createState() => _AddTrainingPageState();
}

class _AddTrainingPageState extends State<AddTrainingPage> {
  late TextEditingController _typeController;
  late TextEditingController _durationController;
  final _formKey = GlobalKey<FormState>();
  String _selectedEmoji = '🏋️';

  final Map<String, String> workoutEmojis = {
    'Кардіо': '🏃',
    'Силове': '💪',
    'Йога': '🧘',
    'Пілатес': '🤸',
    'Розтяжка': '🦵',
    'Плавання': '🏊',
    'Велосипед': '🚴',
    'Бокс': '🥊',
    'Танці': '💃',
    'Ходьба': '🚶',
  };

  @override
  void initState() {
    super.initState();
    _typeController = TextEditingController(text: widget.training?.type ?? '');
    _durationController = TextEditingController(
      text: widget.training?.duration.toString() ?? '',
    );
    _selectedEmoji = widget.training?.emoji ?? '🏋️';
  }

  Future<void> _saveTraining() async {
    if (_formKey.currentState!.validate()) {
      final training = Training(
        id: widget.training?.id,
        type: _typeController.text,
        duration: int.tryParse(_durationController.text) ?? 0,
        date: widget.training?.date ?? DateTime.now(),
        emoji: _selectedEmoji,
      );

      await DatabaseHelper.instance.insertTraining(training);
      Navigator.pop(context, training);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.training != null ? 'Редагувати тренування' : 'Додати тренування'),
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                DropdownButtonFormField<String>(
                  value: _typeController.text.isEmpty ? null : _typeController.text,
                  decoration: InputDecoration(
                    labelText: 'Тип тренування',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  items: workoutEmojis.keys.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Row(
                        children: [
                          Text(workoutEmojis[value]!),
                          SizedBox(width: 10),
                          Text(value),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _typeController.text = value!;
                      _selectedEmoji = workoutEmojis[value]!;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Будь ласка, оберіть тип тренування';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _durationController,
                  decoration: InputDecoration(
                    labelText: 'Тривалість (хвилини)',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Будь ласка, введіть тривалість';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Будь ласка, введіть число';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _saveTraining,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                  child: Text(
                    widget.training != null ? 'Зберегти зміни' : 'Додати тренування',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}