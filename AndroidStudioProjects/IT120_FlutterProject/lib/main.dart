import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'services/firebase_service.dart';
import 'screens/landing_screen.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase initialized successfully');
    
    // Test Firebase connection
    final isConnected = await FirebaseService.testConnection();
    print('Firebase connection test: ${isConnected ? "SUCCESS" : "FAILED"}');
  } catch (e) {
    print('Firebase initialization failed: $e');
  }
  
  runApp(const BerriesIdentificationApp());
}

class BerriesIdentificationApp extends StatelessWidget {
  const BerriesIdentificationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Berries Identification',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const LandingScreen(),
    );
  }
}
