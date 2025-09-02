import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lab5/main.dart';

void main() {
  testWidgets('Симуляція натискання кнопки "Обнулити" для секундоміра', (WidgetTester tester) async {
    // Створення та ініціалізація віджету.
    await tester.pumpWidget(MyApp());

    // Перевіряємо початкове значення секундоміра.
    expect(find.text('Час: 0 секунд'), findsOneWidget);

    // Дочекаємось деякого часу (наприклад, 2 секунди), щоб секундомір збільшився.
    await tester.pump(Duration(seconds: 2));

    // Перевіряємо, чи секундомір збільшився.
    expect(find.text('Час: 2 секунд'), findsOneWidget);

    // Симулюємо натискання кнопки "Обнулити".
    await tester.tap(find.text('Обнулити'));
    await tester.pump(); // Дочекаємось оновлення UI після натискання кнопки.

    // Перевіряємо, чи значення секундоміра обнулене.
    expect(find.text('Час: 0 секунд'), findsOneWidget);
  });
}
