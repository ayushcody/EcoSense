import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'screens/dashboard_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/alerts_screen.dart';
import 'screens/sensor_details_screen.dart';
import 'providers/settings_provider.dart';
import 'providers/sensor_provider.dart';
import 'providers/app_state.dart';
import 'providers/theme_provider.dart';
import 'providers/auth_provider.dart';
import 'theme/ecosense_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => SensorProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProxyProvider2<SettingsProvider, SensorProvider,
            AppState>(
          create: (context) => AppState(
            settingsProvider: context.read<SettingsProvider>(),
            sensorProvider: context.read<SensorProvider>(),
          ),
          update: (context, settings, sensors, previous) => AppState(
            settingsProvider: settings,
            sensorProvider: sensors,
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final authProvider = context.watch<AuthProvider>();

    return MaterialApp(
      title: 'EcoSense',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeProvider.themeMode,
      locale: const Locale('en'),
      supportedLocales: const [
        Locale('en'), // English
        Locale('hi'), // Hindi
        Locale('mr'), // Marathi
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      initialRoute: authProvider.isAuthenticated ? '/' : '/login',
      routes: {
        '/': (_) => const DashboardScreen(),
        '/settings': (_) => const SettingsScreen(),
        '/login': (_) => const LoginScreen(),
        '/signup': (_) => const SignupScreen(),
        '/alerts': (_) => const AlertsScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name?.startsWith('/sensor/') ?? false) {
          final sensorId = settings.name!.split('/')[2];
          return MaterialPageRoute(
            builder: (_) => SensorDetailsScreen(sensorId: sensorId),
          );
        }
        return null;
      },
    );
  }
}
