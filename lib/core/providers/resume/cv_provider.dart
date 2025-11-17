import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intelliresume/core/providers/user/user_provider.dart';
import 'package:intelliresume/di.dart';
import 'package:intelliresume/domain/entities/linkedin_profile_entity.dart';

import '../../../data/models/cv_data.dart';
import '../../../domain/entities/user_profile.dart';

// --- PROVIDER DE ESTADO LOCAL ---

import 'dart:async';

// Provider que busca os dados de um currículo específico por ID.
final resumeDataProvider = FutureProvider.family<ResumeData, String>((
  ref,
  resumeId,
) async {
  if (resumeId == 'new') {
    return ResumeData.initial();
  }

  final user = ref.watch(userProfileProvider).value;
  if (user == null) {
    throw Exception('Usuário não autenticado.');
  }

  final usecase = ref.read(getResumeByIdUsecaseProvider);
  final cvModel = await usecase(user.uid!, resumeId);
  return cvModel.data;
});

/// Notifier que contém a lógica de estado para o currículo sendo editado na UI.
class LocalResumeNotifier extends StateNotifier<ResumeData> {
  final Ref _ref;

  LocalResumeNotifier(this._ref) : super(ResumeData.initial()) {
    // Listen to userProfileProvider changes
    _ref.listen<AsyncValue<UserProfile?>>(userProfileProvider, (
      previous,
      next,
    ) {
      final newUserProfile = next.value;
      // Update personalInfo in ResumeData when userProfile changes
      state = state.copyWith(personalInfo: newUserProfile);
    });
  }

  /// Inicializa o estado com dados vindos do backend (usado no modo de edição).
  void initialize(ResumeData initialData) {
    // Ensure personalInfo from the current user is merged
    final currentUserProfile = _ref.read(userProfileProvider).value;
    state = initialData.copyWith(personalInfo: currentUserProfile);
  }

  void updateFromLinkedInProfile(LinkedInProfileEntity profile) {
    final newExperiences =
        profile.experiences
            .map(
              (e) => Experience(
                company: e.companyName,
                position: e.title,
                description: e.description,
                startDate:
                    '${e.startDate.day}/${e.startDate.month}/${e.startDate.year}',
                endDate:
                    '${e.endDate?.day}/${e.endDate?.month}/${e.endDate?.year}',
              ),
            )
            .toList();

    final newEducations =
        profile.educations
            .map(
              (e) => Education(
                school: e.schoolName,
                startDate:
                    '${e.startDate.day}/${e.startDate.month}/${e.startDate.year}',
                endDate:
                    '${e.endDate?.day}/${e.endDate?.month}/${e.endDate?.year}',
              ),
            )
            .toList();

    state = state.copyWith(
      about: profile.summary,
      experiences: newExperiences,
      educations: newEducations,
      personalInfo: state.personalInfo?.copyWith(name: profile.name),
    );
  }

  // Experiências
  void addExperience(Experience newExperience) {
    state = state.copyWith(experiences: [...state.experiences, newExperience]);
  }

  void updateExperience(int index, Experience experience) {
    final newExperiences = List<Experience>.from(state.experiences);
    newExperiences[index] = experience;
    state = state.copyWith(experiences: newExperiences);
  }

  void removeExperience(int index) {
    final newExperiences = List<Experience>.from(state.experiences);
    newExperiences.removeAt(index);
    state = state.copyWith(experiences: newExperiences);
  }

  // Projetos
  void addProject(Project newProject) {
    state = state.copyWith(projects: [...state.projects, newProject]);
  }

  void updateProject(int index, Project project) {
    final newProjects = List<Project>.from(state.projects);
    newProjects[index] = project;
    state = state.copyWith(projects: newProjects);
  }

  void removeProject(int index) {
    final newProjects = List<Project>.from(state.projects);
    newProjects.removeAt(index);
    state = state.copyWith(projects: newProjects);
  }

  // Certificados
  void addCertificate(Certificate newCertificate) {
    state = state.copyWith(
      certificates: [...state.certificates, newCertificate],
    );
  }

  void updateCertificate(int index, Certificate certificate) {
    final newCertificates = List<Certificate>.from(state.certificates);
    newCertificates[index] = certificate;
    state = state.copyWith(certificates: newCertificates);
  }

  void removeCertificate(int index) {
    final newCertificates = List<Certificate>.from(state.certificates);
    newCertificates.removeAt(index);
    state = state.copyWith(certificates: newCertificates);
  }

  // Educação
  void addEducation(Education newEducation) {
    state = state.copyWith(educations: [...state.educations, newEducation]);
  }

  void updateEducation(int index, Education education) {
    final newEducations = List<Education>.from(state.educations);
    newEducations[index] = education;
    state = state.copyWith(educations: newEducations);
  }

  void removeEducation(int index) {
    final newEducations = List<Education>.from(state.educations);
    newEducations.removeAt(index);
    state = state.copyWith(educations: newEducations);
  }

  void addSkill(Skill skill) {
    state = state.copyWith(skills: [...state.skills, skill]);
  }

  void updateSkill(int index, Skill skill) {
    final newSkills = List<Skill>.from(state.skills);
    newSkills[index] = skill;
    state = state.copyWith(skills: newSkills);
  }

  void removeSkill(int index) {
    final newSkills = List<Skill>.from(state.skills);
    newSkills.removeAt(index);
    state = state.copyWith(skills: newSkills);
  }

  void addSocial(Social social) {
    state = state.copyWith(socials: [...state.socials, social]);
  }

  void updateSocial(int index, Social social) {
    final newSocials = List<Social>.from(state.socials);
    newSocials[index] = social;
    state = state.copyWith(socials: newSocials);
  }

  void removeSocial(int index) {
    final newSocials = List<Social>.from(state.socials);
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

  void updateAbout(String about) {
    state = state.copyWith(about: about);
  }

  void removeObjective() {
    state = state.copyWith(objective: '');
  }
}

/// Provider que expõe o [LocalResumeNotifier].
/// A UI (formulário e preview) irá observar este provider para obter os dados ao vivo.
final localResumeProvider =
    StateNotifierProvider<LocalResumeNotifier, ResumeData>((ref) {
      return LocalResumeNotifier(ref);
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
