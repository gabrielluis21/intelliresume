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

  ResumeData({
    this.personalInfo,
    this.about,
    this.objective,
    this.experiences,
    this.educations,
    this.skills,
    this.socials,
    this.projects,
  });

  ResumeData.initial()
    : personalInfo = UserProfile(),
      about = '',
      objective = '',
      experiences = [],
      educations = [],
      skills = [],
      socials = [],
      projects = [];

  factory ResumeData.fromJson(Map<String, dynamic> json) {
    return ResumeData(
      personalInfo: UserProfile.fromJson(json['personalInfo']),
      about: json['abaout'] as String,
      objective: json['objective'] as String,
      experiences: List<Experience>.from(
        json['experiences'].map((x) => Experience.fromJson(x)),
      ),
      educations: List<Education>.from(
        json['education'].map((x) => Education.fromJson(x)),
      ),
      socials: List<Social>.from(
        json["socials"].map((x) => Social.fromJson(x)),
      ),
      skills: List<Skill>.from(json['skills'].map((x) => Skill.fromJson(x))),
      projects: List<Project>.from(
        json['projects'].map((x) => Project.fromJson(x)),
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'personalInfo': personalInfo?.toJson(),
      'about': about,
      'objective': objective,
      'experiences': experiences?.map((e) => e).toList(),
      'education': educations?.map((e) => e).toList(),
      'skills': skills?.map((e) => e),
      'socials': socials?.map((e) => e).toList(),
      'projects': projects,
    };
  }

  ResumeData copyWith({
    UserProfile? personalInfo,
    String? about,
    String? objective,
    List<Experience>? experiences,
    List<Education>? educations,
    List<Skill>? skills,
    List<Social>? socials,
    List<Project>? projects,
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
  String? url;

  Project({this.name, this.description, this.url});

  Map<String, dynamic> toJson() {
    return {'name': name, 'description': description, 'url': url};
  }

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      name: json['name'] as String,
      description: json['description'] as String,
      url: json['url'] as String,
    );
  }

  Project copyWith({String? name, String? description, String? url}) {
    return Project(
      name: name ?? this.name,
      description: description ?? this.description,
      url: url ?? this.url,
    );
  }
}
