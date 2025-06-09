import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/cv_data.dart';
import '../../domain/entities/user_profile.dart';

class ResumeState extends StateNotifier<ResumeData> {
  ResumeState() : super(ResumeData.initial());

  void updatePersonalInfo(Map<String, dynamic> personalInfo) {
    state = state.copyWith(
      personalInfo: UserProfile.fromJson(personalInfo['personalInfo']),
      about: personalInfo['about'],
      objective: personalInfo['objective'],
      experiences: List<Experience>.from(
        personalInfo['experiences'].map((x) => Experience.fromJson(x)),
      ),
      educations: List<Education>.from(
        personalInfo['educations'].map((x) => Education.fromJson(x)),
      ),
      skills: List<Skill>.from(
        personalInfo['skills'].map((x) => Skill.fromJson(x)),
      ),
      socials: List<Social>.from(
        personalInfo['socials'].map((x) => Social.fromJson(x)),
      ),
      projects: List<Project>.from(
        personalInfo['projects'].map((x) => Project.fromJson(x)),
      ),
    );
  }

  // Experiências
  void addExperience() {
    state = state.copyWith(
      experiences: [
        ...state.experiences!,
        Experience(
          company: '',
          position: '',
          startDate: '',
          endDate: '',
          description: '',
        ),
      ],
    );
  }

  void updateExperience(int index, Experience experience) {
    final newExperiences = List<Experience>.from(state.experiences!);
    newExperiences[index] = experience;
    state = state.copyWith(experiences: newExperiences);
  }

  void removeExperience(int index) {
    final newExperiences = List<Experience>.from(state.experiences!);
    newExperiences.removeAt(index);
    state = state.copyWith(experiences: newExperiences);
  }

  // Educação
  void addEducation() {
    state = state.copyWith(
      educations: [
        ...state.educations!,
        Education(degree: '', startDate: '', endDate: '', school: ''),
      ],
    );
  }

  void updateEducation(int index, Education education) {
    final newEducations = List<Education>.from(state.educations!);
    newEducations[index] = education;
    state = state.copyWith(educations: newEducations);
  }

  void removeEducation(int index) {
    final newEducations = List<Education>.from(state.educations!);
    newEducations.removeAt(index);
    state = state.copyWith(educations: newEducations);
  }

  // Habilidades
  void addSkill() {
    state = state.copyWith(
      skills: [...state.skills!, Skill(name: '', level: '')],
    );
  }

  void updateSkill(int index, Skill skill) {
    final newSkills = List<Skill>.from(state.skills!);
    newSkills[index] = skill;
    state = state.copyWith(skills: newSkills);
  }

  void removeSkill(int index) {
    final newSkills = List<Skill>.from(state.skills!);
    newSkills.removeAt(index);
    state = state.copyWith(skills: newSkills);
  }

  // Redes Sociais
  void addSocial() {
    state = state.copyWith(
      socials: [...state.socials!, Social(platform: '', url: '')],
    );
  }

  void updateSocial(int index, Social social) {
    final newSocials = List<Social>.from(state.socials!);
    newSocials[index] = social;
    state = state.copyWith(socials: newSocials);
  }

  void removeSocial(int index) {
    final newSocials = List<Social>.from(state.socials!);
    newSocials.removeAt(index);
    state = state.copyWith(socials: newSocials);
  }
}

final resumeProvider = StateNotifierProvider<ResumeState, ResumeData>((ref) {
  return ResumeState();
});
