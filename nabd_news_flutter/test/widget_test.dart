import 'package:flutter_test/flutter_test.dart';

import 'package:nabd_news_flutter/app/app.dart';

void main() {
  testWidgets('shows Nabd News shell', (WidgetTester tester) async {
    await tester.pumpWidget(const NabdApp());
    await tester.pump();

    expect(find.text('نبض نيوز'), findsOneWidget);
    expect(find.text('الرئيسية'), findsWidgets);
  });
}
