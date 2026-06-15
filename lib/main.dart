import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import 'config/env.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  runZonedGuarded(() {
    runApp(const MyApp());
  }, (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: !Env.isProd,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<void> testCrash() async {
    await FirebaseCrashlytics.instance.setCustomKey('userId', 'test_user_001');
    FirebaseCrashlytics.instance.log('Test crash button clicked');
    FirebaseCrashlytics.instance.crash();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('[${Env.flavor}] My App'),
      ),
      body: Center(
        child: Env.isProd
            ? Text('API URL: ${Env.apiUrl}')
            : ElevatedButton(
                onPressed: testCrash,
                child: const Text('Test Crash'),
              ),
      ),
    );
  }
}