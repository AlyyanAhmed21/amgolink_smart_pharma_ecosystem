import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme/app_theme.dart';
import 'theme/theme_provider.dart';
import 'screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(const AmgoLinkApp());
}

class AmgoLinkApp extends StatefulWidget {
  const AmgoLinkApp({super.key});

  // Global key to access theme state from anywhere
  static final GlobalKey<_AmgoLinkAppState> appKey = GlobalKey<_AmgoLinkAppState>();

  @override
  State<AmgoLinkApp> createState() => _AmgoLinkAppState();
}

class _AmgoLinkAppState extends State<AmgoLinkApp> {
  late ThemeProvider _themeProvider;

  @override
  void initState() {
    super.initState();
    _themeProvider = ThemeProvider();
    _themeProvider.addListener(_onThemeChanged);
  }

  void _onThemeChanged() {
    setState(() {});
    _updateSystemUI();
  }

  void _updateSystemUI() {
    final isDark = _themeProvider.isDarkMode;
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        systemNavigationBarColor: isDark ? AppTheme.darkBackground : AppTheme.lightBackground,
        systemNavigationBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      ),
    );
  }

  void toggleTheme() {
    _themeProvider.toggleTheme();
  }

  bool get isDarkMode => _themeProvider.isDarkMode;

  @override
  void dispose() {
    _themeProvider.removeListener(_onThemeChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      key: AmgoLinkApp.appKey,
      title: 'AmgoLink',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeProvider.themeMode,
      home: const SplashScreen(),
    );
  }
}

// Helper to access theme toggle from anywhere
class ThemeHelper {
  static void toggleTheme(BuildContext context) {
    final state = context.findAncestorStateOfType<_AmgoLinkAppState>();
    state?.toggleTheme();
  }

  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }
}
