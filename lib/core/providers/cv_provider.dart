import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/cv_data.dart';
import '../../domain/entities/user_profile.dart';

class ResumeState extends StateNotifier<ResumeData> {
  ResumeState() : super(ResumeData.initial());

  void updatePersonalInfo(UserProfile userProfile) {
    print(userProfile.toJson());
    state = state.copyWith(personalInfo: userProfile);
  }

  // Objetivos
  void addObjective() {
    state = state.copyWith(objective: '');
  }

  void updateObjective(String objective) {
    state = state.copyWith(objective: objective);
  }

  void removeObjective() {
    state = state.copyWith(objective: '');
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
