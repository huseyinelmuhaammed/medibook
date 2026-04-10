import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:medibook/app.dart';
import 'package:medibook/providers/appointment_provider.dart';

void main() {
  testWidgets('MediBook wizard açılış testi', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AppointmentProvider()),
        ],
        child: const MediBookApp(),
      ),
    );

    // İlk adımın yüklendiğini doğrula
    expect(find.byKey(const ValueKey('btn_ileri')), findsOneWidget);
    expect(find.byKey(const ValueKey('btn_geri')), findsOneWidget);
    expect(find.byKey(const ValueKey('input_ad')), findsOneWidget);
    expect(find.byKey(const ValueKey('input_soyad')), findsOneWidget);
    expect(find.byKey(const ValueKey('input_tc')), findsOneWidget);
  });
}
