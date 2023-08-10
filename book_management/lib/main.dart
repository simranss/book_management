import 'package:book_management/constants/shared_prefs_strings.dart';
import 'package:book_management/models/home.dart';
import 'package:book_management/models/login.dart';
import 'package:book_management/pages/home.dart';
import 'package:book_management/pages/login.dart';
import 'package:book_management/utils/shared_prefs_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book Management',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: _showPage(),
    );
  }

  Widget _showPage() {
    return FutureBuilder<bool?>(
      future: SharedPrefsUtils.getBool(SharedPrefsStrings.isLoggedIn),
      builder: (_, snapshot) {
        if (snapshot.hasData) {
          var isUserLoggedIn = snapshot.data;
          if (isUserLoggedIn != null) {
            if (isUserLoggedIn) {
              return ChangeNotifierProvider<HomeModel>(
                create: (_) => HomeModel(),
                child: const HomePage(),
              );
            }
          }
          return ChangeNotifierProvider<LoginModel>(
            create: (_) => LoginModel(),
            child: const LoginPage(),
          );
        }
        if (snapshot.hasError) {
          return ChangeNotifierProvider<LoginModel>(
            create: (_) => LoginModel(),
            child: const LoginPage(),
          );
        }
        return const SafeArea(
          child: Scaffold(
            body: Center(child: CircularProgressIndicator()),
          ),
        );
      },
    );
  }
}
