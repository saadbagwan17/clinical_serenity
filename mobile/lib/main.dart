import 'package:flutter/material.dart';
import 'screens/role_selection_screen.dart';

void main() {
  runApp(const ClinicalSerenityApp());
}

class ClinicalSerenityApp extends StatelessWidget {
  const ClinicalSerenityApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Clinical Serenity',

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
        ),
        useMaterial3: true,
      ),

      home: const RoleSelectionScreen(),
    );
  }
}
