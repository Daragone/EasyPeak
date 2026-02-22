import 'user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> signInWithEmailPassword(String email, String password);
  Future<UserEntity> signUpWithEmailPassword(String email, String password, String name);
  Future<void> signOut();
  Stream<UserEntity?> get authStateChanges;
}
