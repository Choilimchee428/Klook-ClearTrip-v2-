import 'package:flutter/material.dart';
import 'screens/a_list_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ClearTripApp());
}

class ClearTripApp extends StatelessWidget {
  const ClearTripApp({super.key});
  static const brand = Color(0xFFFF5B24);
  static const ink = Color(0xFF172030);

  @override
  Widget build(BuildContext context) {
    final colors = ColorScheme.fromSeed(
      seedColor: brand, primary: brand,
      surface: Colors.white, onSurface: ink,
    );
    return MaterialApp(
      title: 'Klook ClearTrip v2',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: colors,
        scaffoldBackgroundColor: const Color(0xFFF8F8FB),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: ink,
          surfaceTintColor: Colors.white,
          elevation: 0,
          centerTitle: false,
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: brand,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 17),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 0,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        textTheme: const TextTheme(
          headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: ink),
          titleLarge: TextStyle(fontSize: 21, fontWeight: FontWeight.w800, color: ink),
          titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: ink),
          bodyMedium: TextStyle(fontSize: 14, height: 1.45, color: ink),
        ),
      ),
      home: const PackageSelectionScreen(),
    );
  }
}
