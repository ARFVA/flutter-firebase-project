import 'package:flutter_test/flutter_test.dart';

import 'package:studyquest/main.dart';

void main() {
  testWidgets('StudyQuest app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const StudyQuestApp());

    expect(find.text('Welcome to StudyQuest'), findsOneWidget);
    expect(find.text('Phase 1: Firebase Setup In Progress'), findsOneWidget);
  });
}
