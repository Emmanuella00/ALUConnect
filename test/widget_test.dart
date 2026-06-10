import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:aluconnect/main.dart';
import 'package:aluconnect/providers/rsvp_provider.dart';

void main() {
  testWidgets('App boots to the splash screen', (tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => RsvpProvider(),
        child: const ALUStrideApp(),
      ),
    );

    expect(find.text('ALU Stride'), findsOneWidget);
    expect(find.text('Get started'), findsOneWidget);
  });
}
