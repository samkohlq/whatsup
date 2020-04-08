import 'package:flutter_test/flutter_test.dart';
import 'package:whatsup/main.dart';
import 'package:whatsup/sign_in_with_google.dart';

void main() {
  testWidgets('MyApp widget contains SignInWithGoogle widget',
      (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    expect(find.byType(SignInWithGoogle), findsOneWidget);
  });
}
