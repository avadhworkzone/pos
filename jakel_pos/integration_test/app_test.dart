import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jakel_base/widgets/button/MyOutlineButton.dart';
import 'package:jakel_pos/main.dart' as app;
import 'package:integration_test/integration_test.dart';
import 'package:jakel_pos/modules/splash/widget/splash_screen.dart';
import 'package:jakel_pos/routing/router.dart';

Future<void> addDelay(int ms) async {
  await Future<void>.delayed(Duration(milliseconds: ms));
}

Future<void> restoreFlutterError(Future<void> Function() call) async {
  final originalOnError = FlutterError.onError!;
  await call();
  final overriddenOnError = FlutterError.onError!;

  // restore FlutterError.onError
  FlutterError.onError = (FlutterErrorDetails details) {
    if (overriddenOnError != originalOnError) overriddenOnError(details);
    originalOnError(details);
  };
}

Widget createWidgetForTesting({required Widget child}) {
  return MaterialApp(
    onGenerateRoute: generateRoute,
    debugShowCheckedModeBanner: false,
    initialRoute: null,
    home: child,
  );
}

void main() {
  group('demo test', () {
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();
    testWidgets('do testing', (WidgetTester tester) async {
      await restoreFlutterError(() async {
        await app.main([""]);
        await tester.pumpAndSettle();
        await tester.pumpWidget(createWidgetForTesting(
          child: const SplashScreen(),
        ));
        await addDelay(5000);
        await tester.pumpAndSettle();
        await tester.enterText(find.byType(TextField).first, '');
        await tester.enterText(find.byType(TextField).first, 'Y7C2M9A4');
        await tester.pumpAndSettle();
        await addDelay(5000);
        await tester.tap(find.text('Done').first);
        await tester.pumpAndSettle();
        await addDelay(5000);
        await tester.enterText(find.byType(TextField).first, '');
        await tester.enterText(find.byType(TextField).first, 'RB75');
        await tester.pumpAndSettle();
        await addDelay(5000);
        await tester.enterText(find.byType(TextField).last, '');
        await tester.enterText(find.byType(TextField).last, '7500');
        await tester.pumpAndSettle();
        await addDelay(5000);
        await tester.tap(find.byType(MyOutlineButton));
        await tester.pumpAndSettle();
        await addDelay(5000);
        await tester.pumpAndSettle();
        await addDelay(10000);
      });
    });
  });
}
