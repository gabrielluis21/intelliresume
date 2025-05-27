// cv_data_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

final cvDataProvider = StateProvider<CVData>((ref) => CVData());

class CVData {
  String about;
  List<String> experiences;
  List<String> educations;
  List<String> skills;
  List<Map<String, dynamic>> socials;

  CVData({
    String? about,
    List<String>? experiences,
    List<String>? educations,
    List<String>? skills,
    List<Map<String, dynamic>>? socials,
  }) : about = about ?? '',
       experiences = experiences ?? [],
       educations = educations ?? [],
       skills = skills ?? [],
       socials = socials ?? [];

  CVData copyWith({
    String? abaout,
    List<String>? experiences,
    List<String>? educations,
    List<String>? skills,
    List<Map<String, dynamic>>? socials,
  }) {
    return CVData(
      about: abaout ?? about,
      experiences: experiences ?? this.experiences,
      educations: educations ?? this.educations,
      skills: skills ?? this.skills,
      socials: socials ?? this.socials,
    );
  }
}
