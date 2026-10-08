import 'package:flutter_test/flutter_test.dart';

import 'package:studyquest/main.dart';

void main() {
  testWidgets('StudyQuest app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const StudyQuestApp());

    expect(find.text('Welcome to StudyQuest'), findsOneWidget);
    expect(find.text('Phase 0: Project Setup Complete'), findsOneWidget);
  });
}
