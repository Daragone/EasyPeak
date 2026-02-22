import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'features/auth/presentation/auth_screen.dart';
import 'features/auth/presentation/auth_controller.dart';
import 'features/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // TODO: Supabase.initialize(url: '...', anonKey: '...');
  
  runApp(const ProviderScope(child: EasyPeakApp()));
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
