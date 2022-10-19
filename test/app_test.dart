import 'package:fatree/app.dart';
import 'package:fatree/timer/view/timer_page.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('App', () {
    testWidgets('Render TimerPage', (tester) async {
      await tester.pumpWidget(const App());
      expect(find.byType(TimerPage), findsOneWidget);
    });
  });
}
