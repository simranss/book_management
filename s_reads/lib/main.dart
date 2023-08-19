import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'constants/shared_prefs_strings.dart';
import 'models/home.dart';
import 'models/login.dart';
import 'pages/home.dart';
import 'pages/login.dart';
import 'utils/shared_prefs_utils.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SReads',
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
      builder: (_, isLoggedInSnapshot) {
        if (isLoggedInSnapshot.hasData) {
          var isUserLoggedIn = isLoggedInSnapshot.data;
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
        if (isLoggedInSnapshot.hasError) {
          return ChangeNotifierProvider<LoginModel>(
            create: (_) => LoginModel(),
            child: const LoginPage(),
          );
        }
        return SafeArea(
          child: Scaffold(
            body: FutureBuilder(
                future: Future.delayed(const Duration(seconds: 4), () {
                  return true;
                }),
                builder: (_, snapshot) {
                  if (snapshot.hasData) {
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
                  return const Center(child: CircularProgressIndicator());
                }),
          ),
        );
      },
    );
  }
}
