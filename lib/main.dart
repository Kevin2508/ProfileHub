import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:profilehub/providers/user_provider.dart';
import 'package:profilehub/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ProfileHub',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          scaffoldBackgroundColor: Colors.grey[50],
          textTheme: const TextTheme(
            bodyMedium: TextStyle(fontSize: 16.0),
            bodyLarge: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}