import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:medibook/app.dart';
import 'package:medibook/providers/appointment_provider.dart';

void main() {
  testWidgets('App smoke test - renders WizardScreen', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AppointmentProvider(),
        child: const MediBookApp(),
      ),
    );
    await tester.pump();

    expect(find.byKey(const ValueKey('btn_ileri')), findsOneWidget);
  });

  testWidgets('Step 1 has required input fields', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => AppointmentProvider(),
        child: const MediBookApp(),
      ),
    );
    await tester.pump();

    expect(find.byKey(const ValueKey('input_ad')), findsOneWidget);
    expect(find.byKey(const ValueKey('input_soyad')), findsOneWidget);
    expect(find.byKey(const ValueKey('input_tc')), findsOneWidget);
    expect(find.byKey(const ValueKey('input_email')), findsOneWidget);
    expect(find.byKey(const ValueKey('input_telefon')), findsOneWidget);
    expect(find.byKey(const ValueKey('radio_erkek')), findsOneWidget);
    expect(find.byKey(const ValueKey('radio_kadin')), findsOneWidget);
  });
}
