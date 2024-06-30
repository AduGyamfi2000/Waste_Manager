import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/currentlocation.dart';
import 'pages/login.dart';
import 'pages/welcome_page.dart';
import 'tabs.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Future<void> initFirebase() async {
    if (kIsWeb) {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyC4KD48-b2sPr3jFX59hz5-464jSb7skXc",
            authDomain: "e-wastemanagement-app.firebaseapp.com",
            projectId: "e-wastemanagement-app",
            storageBucket: "e-wastemanagement-app.appspot.com",
            messagingSenderId: "447374274859",
            appId: "1:447374274859:web:d98c5b9b7382c97ef4156e"),
      );
    } else {
      await Firebase.initializeApp();
    }
  }

  try {
    await initFirebase();
  } catch (e) {
    if (kDebugMode) {
      print('Error initializing Firebase: $e');
    }
  }

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeModel(), // Initialize ThemeModel
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeModel>(
      builder: (context, themeModel, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'WasteManager',
          theme: themeModel.isDarkMode
              ? ThemeData(
                  hintColor: Colors.pink,
                  brightness: Brightness.light,
                  primaryColor: Colors.redAccent,
                  textTheme: const TextTheme(
                      bodyLarge: TextStyle(color: Colors.black)),
                )
              : ThemeData(
                  hintColor: Colors.red,
                  brightness: Brightness.dark,
                  primaryColor: Colors.black,
                  textTheme: const TextTheme(
                      bodyLarge: TextStyle(color: Colors.white)),
                ),
          home: const WelcomePage(),
          routes: {
            "/login": (context) => const LoginPage(),
            "/location": (context) => const CurrentLocationPage(),
            "/my": (context) => const MyTabs(),
          },
        );
      },
    );
  }
}

// ThemeModel class
class ThemeModel with ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}
