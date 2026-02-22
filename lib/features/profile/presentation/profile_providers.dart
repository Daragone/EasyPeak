import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/presentation/auth_controller.dart';
import '../domain/profile_repository.dart';
import '../domain/student_profile_entity.dart';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  throw UnimplementedError('profileRepositoryProvider não inicializado');
});

final currentStudentProfileProvider = FutureProvider<StudentProfileEntity?>((ref) async {
  final userState = ref.watch(authStateProvider).value;
  if (userState == null) return null;

  final profileRepo = ref.watch(profileRepositoryProvider);
  return profileRepo.getProfile(userState.id);
});
