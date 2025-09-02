import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CardValidatorPage(),
    );
  }
}

class CardValidatorPage extends StatefulWidget {
  @override
  _CardValidatorPageState createState() => _CardValidatorPageState();
}

class _CardValidatorPageState extends State<CardValidatorPage> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Перевірка картки')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: FormBuilder(
          key: _formKey,
          child: Column(
            children: [
              FormBuilderTextField(
                name: 'card_number',
                decoration: InputDecoration(
                  labelText: 'Номер картки',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  final card = value?.replaceAll(' ', '') ?? '';
                  if (card.isEmpty) return 'Поле не може бути порожнім';
                  if (!RegExp(r'^\d{16}$').hasMatch(card)) {
                    return 'Номер має містити 16 цифр';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              FormBuilderTextField(
                name: 'expiry_date',
                decoration: InputDecoration(
                  labelText: 'Термін дії (MM/YY)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.datetime,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Поле не може бути порожнім';
                  }

                  final regex = RegExp(r'^(0[1-9]|1[0-2])\/\d{2}$');
                  if (!regex.hasMatch(value)) {
                    return 'Невірний формат. Приклад: 12/25';
                  }

                  final parts = value.split('/');
                  final enteredMonth = int.tryParse(parts[0]) ?? 0;
                  final enteredYear = int.tryParse('20${parts[1]}') ?? 0;

                  final now = DateTime.now();
                  final cardDate = DateTime(enteredYear, enteredMonth + 1);

                  if (cardDate.isBefore(now)) {
                    return 'Термін дії минув';
                  }

                  return null;
                },
              ),
              SizedBox(height: 16),

              FormBuilderTextField(
                name: 'cvv',
                decoration: InputDecoration(
                  labelText: 'CVV',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                obscureText: true,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Введіть CVV';
                  }
                  if (!RegExp(r'^\d{3}$').hasMatch(value)) {
                    return 'CVV має містити 3 цифри';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.saveAndValidate() ?? false) {
                    final card = _formKey.currentState?.value['card_number'];
                    final expiry = _formKey.currentState?.value['expiry_date'];
                    final cvv = _formKey.currentState?.value['cvv'];

                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text('Успіх'),
                        content: Text(
                          'Картка валідна:\nНомер: $card\nТермін дії: $expiry\nCVV: $cvv',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('OK'),
                          )
                        ],
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Будь ласка, перевірте поля')),
                    );
                  }
                },
                child: Text('Перевірити'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
