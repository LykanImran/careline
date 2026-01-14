import 'package:careline/page_selector.dart';
import 'package:flutter/material.dart';
import 'src/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Careline',
      theme: AppTheme.light(),
      home: const PageSelector(),
    );
  }
}
