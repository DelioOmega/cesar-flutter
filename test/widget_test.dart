import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/main.dart';

void main() {
  testWidgets('App renders login screen', (WidgetTester tester) async {
    await tester.pumpWidget(const OnaNelApp());
    await tester.pumpAndSettle();

    // Verifica que el logo/título "TALLER DE COSTURA" está presente
    expect(find.text('TALLER DE COSTURA'), findsOneWidget);
    expect(find.text('INICIAR SESIÓN'), findsOneWidget);
  });
}
