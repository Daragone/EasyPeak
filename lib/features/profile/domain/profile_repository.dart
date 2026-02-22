import 'student_profile_entity.dart';

abstract class ProfileRepository {
  Future<StudentProfileEntity> getProfile(String userId);
}
