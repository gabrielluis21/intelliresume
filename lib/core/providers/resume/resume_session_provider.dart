import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:intelliresume/core/providers/domain_providers.dart';
import 'package:intelliresume/core/providers/resume/cv_provider.dart';
import 'package:intelliresume/core/providers/user/user_provider.dart';
import 'package:intelliresume/data/models/cv_data.dart';
import 'package:intelliresume/data/models/cv_model.dart';
import 'package:intelliresume/di.dart';
import 'package:uuid/uuid.dart';

// 1. Provider que busca o CVModel completo por ID.
final cvModelProvider = FutureProvider.family<CVModel, String>((
  ref,
  resumeId,
) async {
  if (resumeId == 'new') {
    // Para um novo currículo, criamos um modelo temporário
    return CVModel(
      id: 'new',
      title: '',
      data: ResumeData.initial(),
      dateCreated: DateTime.now(),
      lastModified: DateTime.now(),
      status: ResumeStatus.draft,
    );
  }

  final user = ref.watch(userProfileProvider).value;
  if (user == null) {
    throw Exception('Usuário não autenticado.');
  }

  final usecase = ref.read(getResumeByIdUsecaseProvider);
  return usecase(user.uid!, resumeId);
});

// 2. Controller para a lógica de auto-salvamento

class AutoSaveController extends StateNotifier<void> {
  final Ref ref;
  final String resumeId;
  Timer? _debounce;

  AutoSaveController(this.ref, this.resumeId) : super(null) {
    _init();
  }

  void _init() {
    // Ouve as mudanças no estado do formulário
    ref.listen(localResumeProvider, (previous, next) {
      // Ignora a primeira mudança que ocorre na inicialização
      if (previous != next) {
        _onFormChanged();
      }
    });
  }

  void _onFormChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(seconds: 5), _autoSave);
  }

  Future<void> _autoSave() async {
    print('Auto-saving...');
    final userId = ref.read(userProfileProvider).value?.uid;
    final formData = ref.read(localResumeProvider);

    // Precisamos do CVModel original para obter o ID e a data de criação
    final originalCvModelAsync = ref.read(cvModelProvider(resumeId));
    final originalCvModel = originalCvModelAsync.value;

    if (userId == null || originalCvModel == null) {
      print('Auto-save failed: User or original CV model not found.');
      return;
    }

    final bool isNewResume = originalCvModel.id == 'new';
    final String finalId = isNewResume ? const Uuid().v4() : originalCvModel.id;

    final resumeToSave = CVModel(
      id: finalId,
      title:
          originalCvModel.title.isNotEmpty
              ? originalCvModel.title
              : 'Rascunho Automático',
      data: formData,
      dateCreated: originalCvModel.dateCreated,
      lastModified: DateTime.now(),
      status: ResumeStatus.draft, // Auto-save sempre salva como rascunho
    );

    try {
      final useCase = ref.read(saveResumeUseCaseProvider);
      await useCase(userId, resumeToSave);
      print('Auto-save successful for resume ID: $finalId');

      // Se era um novo currículo, invalidamos o provider para forçar a recarga com o novo ID
      if (isNewResume) {
        ref.invalidate(cvModelProvider('new'));
        ref.read(cvModelProvider(finalId));
      }
    } catch (e) {
      print('Auto-save failed: $e');
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}

// 3. Provider que expõe o AutoSaveController
final autoSaveControllerProvider = StateNotifierProvider.autoDispose
    .family<AutoSaveController, void, String>((ref, resumeId) {
      return AutoSaveController(ref, resumeId);
    });
