import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'services/app_state_service.dart';
import 'screens/splash/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppStateService()),
      ],
      child: const RythuMitraApp(),
    ),
  );
}

class RythuMitraApp extends StatelessWidget {
  const RythuMitraApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppStateService>();

    return MaterialApp(
      title: 'Rythu Mitra - Farmer Smart Assistant',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.getTheme(appState.currentLanguage, isDark: false),
      darkTheme: AppTheme.getTheme(appState.currentLanguage, isDark: true),
      themeMode: appState.themeMode,
      home: const SplashScreen(),
    );
  }
}
