import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/main.dart';

void main() {
  testWidgets('App renders without error', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Verifica que la pantalla principal se renderiza con el título "Usuarios"
    expect(find.text('Usuarios'), findsOneWidget);
  });
}
