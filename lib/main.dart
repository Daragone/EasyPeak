import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'features/auth/data/auth_repository_impl.dart';
import 'features/auth/presentation/auth_screen.dart';
import 'features/auth/presentation/auth_controller.dart';
import 'features/profile/data/profile_repository_impl.dart';
import 'features/profile/presentation/profile_providers.dart';
import 'features/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Supabase.initialize(
    url: 'https://clxdanafwhndfduptvun.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNseGRhbmFmd2huZGZkdXB0dnVuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE3ODgyODAsImV4cCI6MjA4NzM2NDI4MH0.r-gHtyFB6hNrLrzR7x3trEBlQqXaLUwT0lpCxc7MLIs',
  );
  
  runApp(ProviderScope(
    overrides: [
      authRepositoryProvider.overrideWithValue(AuthRepositoryImpl(Supabase.instance.client)),
      profileRepositoryProvider.overrideWithValue(ProfileRepositoryImpl(Supabase.instance.client)),
    ],
    child: const EasyPeakApp(),
  ));
}

class EasyPeakApp extends ConsumerWidget {
  const EasyPeakApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authStateAsync = ref.watch(authStateProvider);

    return MaterialApp(
      title: 'EasyPeak',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: authStateAsync.when(
        data: (user) {
          if (user == null) {
            return const AuthScreen();
          }
          return const HomeScreen();
        },
        loading: () => const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
        error: (error, _) => Scaffold(
          body: Center(child: Text('Erro: $error')),
        ),
      ),
    );
  }
}
