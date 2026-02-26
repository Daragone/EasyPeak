import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Supabase.initialize(
    url: 'https://clxdanafwhndfduptvun.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNseGRhbmFmd2huZGZkdXB0dnVuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE3ODgyODAsImV4cCI6MjA4NzM2NDI4MH0.r-gHtyFB6hNrLrzR7x3trEBlQqXaLUwT0lpCxc7MLIs',
  );
  
  runApp(const EasyPeakApp());
}

class EasyPeakApp extends StatelessWidget {
  const EasyPeakApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EasyPeak v2',
      theme: ThemeData.dark(), // Temporary dark theme
      home: const Scaffold(
        body: Center(
          child: Text('EasyPeak Blank Canvas'),
        ),
      ),
    );
  }
}
