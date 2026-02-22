import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/auth_repository.dart';
import '../domain/user_entity.dart';
import 'user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final SupabaseClient _supabaseClient;

  AuthRepositoryImpl(this._supabaseClient);

  @override
  Stream<UserEntity?> get authStateChanges {
    return _supabaseClient.auth.onAuthStateChange.map((event) {
      final session = event.session;
      if (session == null || session.user == null) return null;
      return UserModel(
        id: session.user!.id,
        email: session.user!.email ?? '',
      );
    });
  }

  @override
  Future<UserEntity> signInWithEmailPassword(String email, String password) async {
    final response = await _supabaseClient.auth.signInWithPassword(
      email: email,
      password: password,
    );
    
    if (response.user == null) {
      throw Exception('Falha ao realizar login: Usuário não retornado.');
    }

    return UserModel(
      id: response.user!.id,
      email: response.user!.email ?? '',
    );
  }

  @override
  Future<void> signOut() async {
    await _supabaseClient.auth.signOut();
  }

  @override
  Future<UserEntity> signUpWithEmailPassword(String email, String password, String name) async {
    final response = await _supabaseClient.auth.signUp(
      email: email,
      password: password,
      data: {'name': name},
    );

    if (response.user == null) {
      throw Exception('Falha ao realizar cadastro: Usuário não retornado.');
    }

    return UserModel(
      id: response.user!.id,
      email: response.user!.email ?? '',
      name: name,
    );
  }
}
