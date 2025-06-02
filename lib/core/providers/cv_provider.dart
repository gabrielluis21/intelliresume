// cv_data_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

final cvDataProvider = StateNotifierProvider<CvDataProviderNotifier, CVData>(
  (ref) => CvDataProviderNotifier(),
);

class CVData {
  String about;
  String objective;
  List<String> experiences;
  List<String> educations;
  List<String> skills;
  List<Map<String, dynamic>> socials;

  CVData({
    String? about,
    String? objective,
    List<String>? experiences,
    List<String>? educations,
    List<String>? skills,
    List<Map<String, dynamic>>? socials,
  }) : about = about ?? '',
       objective = objective ?? '',
       experiences = experiences ?? [],
       educations = educations ?? [],
       skills = skills ?? [],
       socials = socials ?? [];

  CVData copyWith({
    String? abaout,
    String? objective,
    List<String>? experiences,
    List<String>? educations,
    List<String>? skills,
    List<Map<String, dynamic>>? socials,
  }) {
    return CVData(
      about: abaout ?? about,
      objective: objective ?? this.objective,
      experiences: experiences ?? this.experiences,
      educations: educations ?? this.educations,
      skills: skills ?? this.skills,
      socials: socials ?? this.socials,
    );
  }
}

class CvDataProviderNotifier extends StateNotifier<CVData> {
  CvDataProviderNotifier() : super(CVData());

  void updateAbout(String about) {
    state = state.copyWith(abaout: about);
  }

  void updateObjective(String objective) {
    state = state.copyWith(objective: objective);
  }

  void updateExperiences({List<String> experiences = const []}) {
    state = state.copyWith(experiences: experiences);
  }

  void updateEducations({List<String> educations = const []}) {
    state = state.copyWith(educations: educations);
  }

  void updateSkills({List<String> skills = const []}) {
    state = state.copyWith(skills: skills);
  }

  void updateSocials({List<Map<String, dynamic>> socials = const []}) {
    state = state.copyWith(socials: socials);
  }
}
