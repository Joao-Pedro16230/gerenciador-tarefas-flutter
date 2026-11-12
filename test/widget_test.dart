import 'package:flutter_test/flutter_test.dart';
import 'package:gerenciador_tarefas/app.dart';

void main() {
  testWidgets('Aplicativo inicia corretamente', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Bem-vindo de volta!'), findsOneWidget);
    expect(find.text('Entrar'), findsOneWidget);
  });
}
