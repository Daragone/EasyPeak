import '../domain/student_profile_entity.dart';

class StudentProfileModel extends StudentProfileEntity {
  const StudentProfileModel({
    required super.xp,
    required super.streakDays,
    required super.currentLevelId,
  });

  factory StudentProfileModel.fromJson(Map<String, dynamic> json) {
    return StudentProfileModel(
      xp: json['xp'] as int? ?? 0,
      streakDays: json['streak_days'] as int? ?? 0,
      currentLevelId: json['current_level_id'] as int? ?? 1,
    );
  }
}
