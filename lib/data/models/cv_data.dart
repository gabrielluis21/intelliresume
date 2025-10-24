import '../../domain/entities/user_profile.dart';

class ResumeData {
  UserProfile? personalInfo;
  String? about;
  String? objective;
  List<Experience> experiences;
  List<Education> educations;
  List<Skill> skills;
  List<Social> socials;
  List<Project> projects;
  List<Certificate> certificates;
  List<Language> languages;
  bool includePCDInfo; // Novo campo
  String? pcdInfo;

  ResumeData({
    this.personalInfo,
    this.about,
    this.objective,
    List<Experience>? experiences,
    List<Education>? educations,
    List<Skill>? skills,
    List<Social>? socials,
    List<Project>? projects,
    List<Certificate>? certificates,
    List<Language>? languages,
    this.pcdInfo,
    this.includePCDInfo = false,
  }) : experiences = experiences ?? [],
       educations = educations ?? [],
       skills = skills ?? [],
       socials = socials ?? [],
       projects = projects ?? [],
       certificates = certificates ?? [],
       languages = languages ?? [];

  ResumeData.initial()
    : personalInfo = null,
      about = '',
      objective = '',
      experiences = [],
      educations = [],
      skills = [],
      socials = [],
      projects = [],
      certificates = [],
      languages = [],
      pcdInfo = '',
      includePCDInfo = false;

  factory ResumeData.fromJson(Map<String, dynamic> json) {
    return ResumeData(
      personalInfo:
          json['personalInfo'] != null
              ? UserProfile.fromJson(json['personalInfo'])
              : null,
      about: json['about'] as String?,
      objective: json['objective'] as String?,
      experiences:
          (json['experiences'] as List<dynamic>?)
              ?.map((x) => Experience.fromJson(x))
              .toList() ??
          [],
      educations:
          (json['education'] as List<dynamic>?)
              ?.map((x) => Education.fromJson(x))
              .toList() ??
          [],
      socials:
          (json["socials"] as List<dynamic>?)
              ?.map((x) => Social.fromJson(x))
              .toList() ??
          [],
      skills:
          (json['skills'] as List<dynamic>?)
              ?.map((x) => Skill.fromJson(x))
              .toList() ??
          [],
      projects:
          (json['projects'] as List<dynamic>?)
              ?.map((x) => Project.fromJson(x))
              .toList() ??
          [],
      certificates:
          (json['certificates'] as List<dynamic>?)
              ?.map((x) => Certificate.fromJson(x))
              .toList() ??
          [],
      languages:
          (json['languages'] as List<dynamic>?)
              ?.map((x) => Language.fromJson(x))
              .toList() ??
          [],
      includePCDInfo: json['includePCDInfo'] ?? false,
      pcdInfo: json['includePCDInfo'] != false ? json['pcdInfo'] : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'personalInfo': personalInfo?.toJson(),
      'about': about,
      'objective': objective,
      'experiences': experiences.map((e) => e.toJson()).toList(),
      'education': educations.map((e) => e.toJson()).toList(),
      'skills': skills.map((s) => s.toJson()).toList(),
      'socials': socials.map((s) => s.toJson()).toList(),
      'projects': projects.map((p) => p.toJson()).toList(),
      'certificates': certificates.map((c) => c.toJson()).toList(),
      'languages': languages.map((l) => l.toJson()).toList(),
      'includePCDInfo': includePCDInfo,
      'pcdInfo': pcdInfo,
    };
  }

  bool get isEmpty =>
      (about == null || about!.isEmpty) &&
      experiences.isEmpty &&
      educations.isEmpty &&
      skills.isEmpty &&
      socials.isEmpty &&
      (objective == null || objective!.isEmpty) &&
      projects.isEmpty &&
      languages.isEmpty &&
      (pcdInfo == null || pcdInfo!.isEmpty) &&
      certificates.isEmpty;

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
    String? pcdInfo,
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
      pcdInfo: pcdInfo ?? this.pcdInfo,
    );
  }

  /// Converte os dados do currículo para uma string formatada para a IA.
  String toFormattedString() {
    final buffer = StringBuffer();

    if (personalInfo?.name != null && personalInfo!.name!.isNotEmpty) {
      buffer.writeln('# NOME');
      buffer.writeln(personalInfo!.name);
      buffer.writeln();
    }

    if (about != null && about!.isNotEmpty) {
      buffer.writeln('# SOBRE MIM');
      buffer.writeln(about);
      buffer.writeln();
    }

    if (objective != null && objective!.isNotEmpty) {
      buffer.writeln('# OBJETIVO');
      buffer.writeln(objective);
      buffer.writeln();
    }

    if (experiences.isNotEmpty) {
      buffer.writeln('# EXPERIÊNCIA PROFISSIONAL');
      for (final exp in experiences) {
        buffer.writeln('## ${exp.position ?? ''} em ${exp.company ?? ''}');
        buffer.writeln('### De ${exp.startDate ?? ''} - ${exp.endDate ?? ''}');
        if (exp.description != null && exp.description!.isNotEmpty) {
          buffer.writeln(exp.description);
        }
        buffer.writeln();
      }
    }

    if (educations.isNotEmpty) {
      buffer.writeln('# EDUCAÇÃO');
      for (final edu in educations) {
        buffer.writeln('## ${edu.degree ?? ''} em ${edu.school ?? ''}');
        buffer.writeln('### De ${edu.startDate ?? ''} - ${edu.endDate ?? ''}');
        if (edu.description != null && edu.description!.isNotEmpty) {
          buffer.writeln(edu.description);
        }
        buffer.writeln();
      }
    }

    if (skills.isNotEmpty) {
      buffer.writeln('# HABILIDADES');
      buffer.writeln(skills.map((s) => s.name).join(', '));
      buffer.writeln();
    }

    if (socials.isNotEmpty) {
      buffer.writeln('# REDES SOCIAIS');
      buffer.writeln({socials.map((s) => s.platform).join(', ')});
      buffer.writeln();
    }

    if (projects.isNotEmpty) {
      buffer.writeln('# PROJETOS');
      buffer.writeln(projects.map((p) => p.name).join(', '));
      buffer.writeln();
    }

    if (certificates.isNotEmpty) {
      buffer.writeln('# REDES SOCIAIS');
      buffer.writeln(certificates.map((c) => c.courseName).join(', '));
      buffer.writeln();
    }

    if (includePCDInfo != false) {
      buffer.writeln('# INFORMAÇÕES ADICIONAIS');
      buffer.writeln(pcdInfo);
      buffer.writeln();
    }

    return buffer.toString();
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
  String? url;
  String? startYear;
  String? endYear;
  List<String>? attachments;

  Project({
    this.name,
    this.description,
    this.url,
    this.startYear,
    this.endYear,
    this.attachments,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'url': url,
      'startYear': startYear,
      'endYear': endYear,
      'attachments': attachments,
    };
  }

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      name: json['name'] as String?,
      description: json['description'] as String?,
      url: json['url'] as String?,
      startYear: json['startYear'] as String?,
      endYear: json['endYear'] as String?,
      attachments:
          (json['attachments'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList(),
    );
  }

  Project copyWith({
    String? name,
    String? description,
    String? url,
    String? startYear,
    String? endYear,
    List<String>? attachments,
  }) {
    return Project(
      name: name ?? this.name,
      description: description ?? this.description,
      url: url ?? this.url,
      startYear: startYear ?? this.startYear,
      endYear: endYear ?? this.endYear,
      attachments: attachments ?? this.attachments,
    );
  }
}

class Certificate {
  String? courseName;
  String? institution;
  String? workload;
  String? startDate;
  String? endDate;
  String? certificateUrl;
  List<String>? attachments;

  Certificate({
    this.courseName,
    this.institution,
    this.workload,
    this.startDate,
    this.endDate,
    this.certificateUrl,
    this.attachments,
  });

  Certificate copyWith({
    String? courseName,
    String? institution,
    String? workload,
    String? startDate,
    String? endDate,
    String? certificateUrl,
    List<String>? attachments,
  }) {
    return Certificate(
      courseName: courseName ?? this.courseName,
      institution: institution ?? this.institution,
      workload: workload ?? this.workload,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      certificateUrl: certificateUrl ?? this.certificateUrl,
      attachments: attachments ?? this.attachments,
    );
  }

  Map<String, dynamic> toJson() => {
    'courseName': courseName,
    'institution': institution,
    'workload': workload,
    'startDate': startDate,
    'endDate': endDate,
    'certificateUrl': certificateUrl,
    'attachments': attachments,
  };

  factory Certificate.fromJson(Map<String, dynamic> json) => Certificate(
    courseName: json['courseName'] as String?,
    institution: json['institution'] as String?,
    workload: json['workload'] as String?,
    startDate: json['startDate'] as String?,
    endDate: json['endDate'] as String?,
    certificateUrl: json['certificateUrl'] as String?,
    attachments:
        (json['attachments'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList(),
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
