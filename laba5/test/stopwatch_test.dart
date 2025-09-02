import 'package:flutter_test/flutter_test.dart';
import 'package:lab5/main.dart'; // Замість 'my_app' вкажіть назву вашого пакету.

void main() {
  testWidgets('Секундомір починається з нуля', (WidgetTester tester) async {
    // Створення та ініціалізація віджету.
    await tester.pumpWidget(MyApp());

    // Перевіряємо, чи значення секундоміра є 0.
    expect(find.text('Час: 0 секунд'), findsOneWidget);
  });

  testWidgets('Кнопка обнулення працює правильно', (WidgetTester tester) async {
    // Створення та ініціалізація віджету.
    await tester.pumpWidget(MyApp());

    // Дочекаємося деякого часу, щоб секундомір почав працювати.
    await tester.pump(Duration(seconds: 2));

    // Перевіряємо, чи секундомір збільшився.
    expect(find.text('Час: 2 секунд'), findsOneWidget);

    // Тепер натискаємо кнопку обнулення.
    await tester.tap(find.text('Обнулити'));
    await tester.pump(); // Дочекаємося оновлення UI після натискання кнопки.

    // Перевіряємо, чи значення секундоміра обнулено.
    expect(find.text('Час: 0 секунд'), findsOneWidget);
  });

  testWidgets('Секундомір збільшується кожну секунду', (WidgetTester tester) async {
    // Створення та ініціалізація віджету.
    await tester.pumpWidget(MyApp());

    // Перевіряємо початкове значення секундоміра.
    expect(find.text('Час: 0 секунд'), findsOneWidget);

    // Дочекаємося 1 секунду.
    await tester.pump(Duration(seconds: 1));

    // Перевіряємо, чи секундомір збільшився на 1.
    expect(find.text('Час: 1 секунд'), findsOneWidget);

    // Дочекаємося ще 1 секунду.
    await tester.pump(Duration(seconds: 1));

    // Перевіряємо, чи секундомір збільшився на 1 ще раз.
    expect(find.text('Час: 2 секунд'), findsOneWidget);
  });
}
