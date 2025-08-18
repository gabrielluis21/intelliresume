import '../../domain/entities/user_profile.dart';

class ResumeData {
  UserProfile? personalInfo;
  String? about;
  String? objective;
  List<Experience>? experiences;
  List<Education>? educations;
  List<Skill>? skills;
  List<Social>? socials;
  List<Project>? projects;
  List<Certificate>? certificates;
  List<Language>? languages;
  bool includePCDInfo; // Novo campo

  ResumeData({
    this.personalInfo,
    this.about,
    this.objective,
    this.experiences,
    this.educations,
    this.skills,
    this.socials,
    this.projects,
    this.certificates,
    this.languages,
    this.includePCDInfo = false, // Valor padrão
  });

  ResumeData.initial()
      : personalInfo = UserProfile(),
        about = '',
        objective = '',
        experiences = List<Experience>.empty(growable: true),
        educations = List<Education>.empty(growable: true),
        skills = List<Skill>.empty(growable: true),
        socials = List<Social>.empty(growable: true),
        projects = List<Project>.empty(growable: true),
        certificates = List<Certificate>.empty(growable: true),
        languages = List<Language>.empty(growable: true),
        includePCDInfo = false;

  factory ResumeData.fromJson(Map<String, dynamic> json) {
    return ResumeData(
      personalInfo: UserProfile.fromJson(json['personalInfo']),
      about: json['about'] as String?,
      objective: json['objective'] as String?,
      experiences: (json['experiences'] as List<dynamic>?)
          ?.map((x) => Experience.fromJson(x))
          .toList(),
      educations: (json['education'] as List<dynamic>?)
          ?.map((x) => Education.fromJson(x))
          .toList(),
      socials: (json["socials"] as List<dynamic>?)
          ?.map((x) => Social.fromJson(x))
          .toList(),
      skills: (json['skills'] as List<dynamic>?)
          ?.map((x) => Skill.fromJson(x))
          .toList(),
      projects: (json['projects'] as List<dynamic>?)
          ?.map((x) => Project.fromJson(x))
          .toList(),
      certificates: (json['certificates'] as List<dynamic>?)
          ?.map((x) => Certificate.fromJson(x))
          .toList(),
      languages: (json['languages'] as List<dynamic>?)
          ?.map((x) => Language.fromJson(x))
          .toList(),
      includePCDInfo: json['includePCDInfo'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'personalInfo': personalInfo?.toJson(),
      'about': about,
      'objective': objective,
      'experiences': experiences?.map((e) => e.toJson()).toList(),
      'education': educations?.map((e) => e.toJson()).toList(),
      'skills': skills?.map((s) => s.toJson()).toList(),
      'socials': socials?.map((s) => s.toJson()).toList(),
      'projects': projects?.map((p) => p.toJson()).toList(),
      'certificates': certificates?.map((c) => c.toJson()).toList(),
      'languages': languages?.map((l) => l.toJson()).toList(),
      'includePCDInfo': includePCDInfo,
    };
  }

  bool get isEmpty =>
      (about == null || about!.isEmpty) &&
      (experiences == null || experiences!.isEmpty) &&
      (educations == null || educations!.isEmpty) &&
      (skills == null || skills!.isEmpty) &&
      (socials == null || socials!.isEmpty) &&
      (objective == null || objective!.isEmpty) &&
      (projects == null || projects!.isEmpty) &&
      (languages == null || languages!.isEmpty) &&
      (certificates == null || certificates!.isEmpty);

  bool get isNotEmpty => !isEmpty;

  ResumeData copyWith({
    UserProfile? personalInfo,
    String? about,
    String? objective,
    List<Experience>? experiences,
    List<Education>? educations,
    List<Skill>? skills,
    List<Social>? socials,
    List<Project>? projects,
    List<Certificate>? certificates,
    List<Language>? languages,
    bool? includePCDInfo,
  }) {
    return ResumeData(
      personalInfo: personalInfo ?? this.personalInfo,
      about: about ?? this.about,
      objective: objective ?? this.objective,
      experiences: experiences ?? this.experiences,
      educations: educations ?? this.educations,
      skills: skills ?? this.skills,
      socials: socials ?? this.socials,
      projects: projects ?? this.projects,
      certificates: certificates ?? this.certificates,
      languages: languages ?? this.languages,
      includePCDInfo: includePCDInfo ?? this.includePCDInfo,
    );
  }
}

class Experience {
  final String? company;
  final String? position;
  final String? startDate;
  final String? endDate;
  final String? description;

  Experience({
    this.company,
    this.position,
    this.startDate,
    this.endDate,
    this.description,
  });

  Experience copyWith({
    String? company,
    String? position,
    String? startDate,
    String? endDate,
    String? description,
  }) {
    return Experience(
      company: company ?? this.company,
      position: position ?? this.position,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toJson() => {
    'company': company,
    'position': position,
    'startDate': startDate,
    'endDate': endDate,
    'description': description,
  };

  factory Experience.fromJson(Map<String, dynamic> json) => Experience(
    company: json['company'],
    position: json['position'],
    startDate: json['startDate'],
    endDate: json['endDate'],
    description: json['description'],
  );
}

class Education {
  String? school;
  String? degree;
  String? startDate;
  String? endDate;
  String? description;

  Education({
    this.school,
    this.degree,
    this.startDate,
    this.endDate,
    this.description,
  });

  Education copyWith({
    String? school,
    String? degree,
    String? startDate,
    String? endDate,
    String? description,
  }) {
    return Education(
      school: school ?? this.school,
      degree: degree ?? this.degree,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toJson() => {
    'school': school,
    'degree': degree,
    'startDate': startDate,
    'endDate': endDate,
    'description': description,
  };

  factory Education.fromJson(Map<String, dynamic> json) => Education(
    school: json['school'],
    degree: json['degree'],
    startDate: json['startDate'],
    endDate: json['endDate'],
    description: json['description'],
  );
}

class Skill {
  String? name;
  String? level;

  Skill({this.name, this.level});

  Skill copyWith({String? name, String? level}) {
    return Skill(name: name ?? this.name, level: level ?? this.level);
  }

  Map<String, dynamic> toJson() => {'name': name, 'level': level};

  factory Skill.fromJson(Map<String, dynamic> json) =>
      Skill(name: json['name'], level: json['level']);
}

class Social {
  String? platform;
  String? url;

  Social({this.platform, this.url});

  Social copyWith({String? platform, String? url}) {
    return Social(platform: platform ?? this.platform, url: url ?? this.url);
  }

  Map<String, dynamic> toJson() => {'platform': platform, 'url': url};

  factory Social.fromJson(Map<String, dynamic> json) =>
      Social(platform: json['platform'], url: json['url']);
}

class Project {
  String? name;
  String? description;
  List<String>? technologies;
  String? url;

  Project({this.name, this.description, this.technologies, this.url});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'technologies': technologies != null ? technologies?.map((e) => e) : [],
      'url': url,
    };
  }

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      name: json['name'] as String,
      description: json['description'] as String,
      technologies:
          json['tecnologies'] != null
              ? List<String>.of(json['technologies'].map((e) => e))
              : List<String>.empty(growable: true),
      url: json['url'] as String,
    );
  }

  Project copyWith({
    String? name,
    String? description,
    List<String>? technologies,
    String? url,
  }) {
    return Project(
      name: name ?? this.name,
      description: description ?? this.description,
      technologies: technologies ?? this.technologies,
      url: url ?? this.url,
    );
  }
}

class Certificate {
  String? courseName;
  String? institution;
  String? issueDate;
  String? certificateUrl;
  bool? isOnline;

  Certificate({
    this.courseName,
    this.institution,
    this.issueDate,
    this.certificateUrl,
    this.isOnline,
  });

  Certificate copyWith({
    String? courseName,
    String? institution,
    String? issueDate,
    String? certificateUrl,
    bool? isOnline,
  }) {
    return Certificate(
      courseName: courseName ?? this.courseName,
      institution: institution ?? this.institution,
      issueDate: issueDate ?? this.issueDate,
      certificateUrl: certificateUrl ?? this.certificateUrl,
      isOnline: isOnline ?? this.isOnline,
    );
  }

  Map<String, dynamic> toJson() => {
    'courseName': courseName,
    'institution': institution,
    'issueDate': issueDate,
    'certificateUrl': certificateUrl,
    'isOnline': isOnline,
  };

  factory Certificate.fromJson(Map<String, dynamic> json) => Certificate(
    courseName: json['courseName'],
    institution: json['institution'],
    issueDate: json['issueDate'],
    certificateUrl: json['certificateUrl'],
    isOnline: json['isOnline'],
  );
}

class Language {
  String? language;
  String? proficiencyLevel;

  Language({this.language, this.proficiencyLevel});

  Language copyWith({String? language, String? proficiencyLevel}) {
    return Language(
      language: language ?? this.language,
      proficiencyLevel: proficiencyLevel ?? this.proficiencyLevel,
    );
  }

  Map<String, dynamic> toJson() => {
    'language': language,
    'proficiencyLevel': proficiencyLevel,
  };

  factory Language.fromJson(Map<String, dynamic> json) => Language(
    language: json['language'],
    proficiencyLevel: json['proficiencyLevel'],
  );
}
