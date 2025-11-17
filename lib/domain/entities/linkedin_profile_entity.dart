class LinkedInProfileEntity {
  final String name;
  final String headline;
  final String summary;
  final List<ExperienceEntity> experiences;
  final List<EducationEntity> educations;

  LinkedInProfileEntity({
    required this.name,
    required this.headline,
    required this.summary,
    required this.experiences,
    required this.educations,
  });
}

class ExperienceEntity {
  final String companyName;
  final String title;
  final String? description;
  final DateTime startDate;
  final DateTime? endDate;

  ExperienceEntity({
    required this.companyName,
    required this.title,
    this.description,
    required this.startDate,
    this.endDate,
  });
}

class EducationEntity {
  final String schoolName;
  final String? degree;
  final String? fieldOfStudy;
  final DateTime startDate;
  final DateTime? endDate;

  EducationEntity({
    required this.schoolName,
    this.degree,
    this.fieldOfStudy,
    required this.startDate,
    this.endDate,
  });
}
