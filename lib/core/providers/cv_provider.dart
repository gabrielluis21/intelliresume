import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Necessário para o provider remoto
import 'package:intelliresume/core/providers/user_provider.dart';

import '../../data/models/cv_data.dart';
import '../../domain/entities/user_profile.dart';

// --- PROVIDER DE ESTADO LOCAL ---

/// Notifier que contém a lógica de estado para o currículo sendo editado na UI.
class LocalResumeNotifier extends StateNotifier<ResumeData> {
  LocalResumeNotifier() : super(ResumeData.initial());

  /// Inicializa o estado com dados vindos do backend (usado no modo de edição).
  void initialize(ResumeData initialData) {
    state = initialData;
  }

  void updatePersonalInfo(UserProfile? userProfile) {
    state = state.copyWith(personalInfo: userProfile);
  }

  // ... todos os outros métodos (addExperience, updateSkill, etc.) permanecem aqui ...
  // Experiências
  void addExperience(Experience? newExperience) {
    state = state.copyWith(
      experiences: [...state.experiences!, newExperience!],
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
  void addEducation(Education? newEducation) {
    state = state.copyWith(educations: [...state.educations!, newEducation!]);
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

  void addSkill(Skill? skill) {
    state = state.copyWith(skills: [...state.skills!, skill!]);
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

  void addSocial(Social? social) {
    state = state.copyWith(socials: [...state.socials!, social!]);
  }

  void updateSocial(int index, Social social) {
    final newSocials = List<Social>.from(state.socials!);
    newSocials[index] = social;
  }

  void removeSocial(int index) {
    final newSocials = List<Social>.from(state.socials!);
    newSocials.removeAt(index);
    state = state.copyWith(socials: newSocials);
  }

  void toggleIncludePCDInfo(bool value) {
    state = state.copyWith(includePCDInfo: value);
  }

  void addObjective(String objective) {
    state = state.copyWith(objective: objective);
  }

  void updateObjective(String objective) {
    state = state.copyWith(objective: objective);
  }

  void removeObjective() {
    state = state.copyWith(objective: '');
  }
}

/// Provider que expõe o [LocalResumeNotifier].
/// A UI (formulário e preview) irá observar este provider para obter os dados ao vivo.
final localResumeProvider =
    StateNotifierProvider<LocalResumeNotifier, ResumeData>((ref) {
      return LocalResumeNotifier();
    });

// --- PROVIDER DE DADOS REMOTOS ---

/// Provider que busca os dados iniciais de um currículo do Firestore.
/// Usado apenas no MODO EDIÇÃO para carregar os dados pela primeira vez.
final remoteResumeProvider = StreamProvider.family<ResumeData?, String>((
  ref,
  cvId,
) {
  if (cvId.isEmpty) {
    return Stream.value(null);
  }
  // Exemplo de como buscar do Firestore. Adapte para sua estrutura.
  final firestore = FirebaseFirestore.instance;
  final docRef = firestore
      .collection('users')
      .doc(ref.watch(userProfileProvider).value?.uid)
      .collection('resumes')
      .doc(cvId);

  return docRef.snapshots().map((snapshot) {
    if (snapshot.exists) {
      return ResumeData.fromJson(snapshot.data()!);
    } else {
      return null;
    }
  });
});
