import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/profile_repository.dart';
import '../domain/student_profile_entity.dart';
import 'student_profile_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final SupabaseClient _supabaseClient;

  ProfileRepositoryImpl(this._supabaseClient);

  @override
  Future<StudentProfileEntity> getProfile(String userId) async {
    final response = await _supabaseClient
        .from('student_profiles')
        .select()
        .eq('user_id', userId)
        .single();
    
    return StudentProfileModel.fromJson(response);
  }
}
