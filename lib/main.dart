import 'package:flutter/material.dart';
import 'config/env.dart';

void main() {
  runApp(const MyApp());
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('[${Env.flavor}] My App'),
      ),
      body: Center(
        child: Text(
          'API URL: ${Env.apiUrl}',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}