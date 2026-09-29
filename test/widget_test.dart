import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:rythu_mitra/main.dart';
import 'package:rythu_mitra/services/app_state_service.dart';

void main() {
  testWidgets('App smoke test - verifies Rythu Mitra renders', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AppStateService()),
        ],
        child: const RythuMitraApp(),
      ),
    );

    // Initial render
    expect(find.text('రైతు మిత్ర'), findsOneWidget);
    expect(find.text('RYTHU MITRA'), findsOneWidget);

    // Advance clock past splash timer to navigate to Language selection screen
    await tester.pump(const Duration(milliseconds: 3000));
    await tester.pumpAndSettle();

    // Verify language selection screen renders
    expect(find.text('తెలుగు'), findsOneWidget);
  });
}
