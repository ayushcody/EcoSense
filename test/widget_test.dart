// This is a basic widget test.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:ecosense/main.dart';
import 'package:ecosense/providers/auth_provider.dart';
import 'package:ecosense/providers/sensor_provider.dart';
import 'package:ecosense/providers/settings_provider.dart';
import 'package:ecosense/providers/theme_provider.dart';

void main() {
  testWidgets('Smoke test - App should build without crashing',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => SettingsProvider()),
          ChangeNotifierProvider(create: (_) => SensorProvider()),
          ChangeNotifierProvider(create: (_) => AuthProvider()),
        ],
        child: const MyApp(),
      ),
    );

    // Verify the app builds at least
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
