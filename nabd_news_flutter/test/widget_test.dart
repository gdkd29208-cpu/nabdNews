import 'package:flutter_test/flutter_test.dart';

import 'package:nabd_news_flutter/app/app.dart';
import 'package:nabd_news_flutter/app/app_state.dart';

void main() {
  testWidgets('shows Nabd News shell', (WidgetTester tester) async {
    await tester.pumpWidget(
      NabdApp(appState: AppState.preview(), bootstrapOnStart: false),
    );
    await tester.pump();

    expect(find.text('نبض نيوز'), findsOneWidget);
    expect(find.text('الرئيسية'), findsWidgets);
  });
}
