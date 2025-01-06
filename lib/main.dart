import 'package:document_generator/document_generator_page.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await Supabase.initialize(
    url: 'https://bhafcetsodbzrgljalge.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJoYWZjZXRzb2RienJnbGphbGdlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzYxNTEyODUsImV4cCI6MjA1MTcyNzI4NX0.Ld8D5MX7TBP7hiy-UZ7sS_HNVwkAzt5kyM6Ul9inBnM', // جایگزین کنید با کلید ناشناس شما
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false,
      title: 'Document Generator',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const DocumentGeneratorPage(),
    );
  }
}
