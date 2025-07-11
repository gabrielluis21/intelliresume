// business_logic.dart
// Lógica de negócios integrada a UserProfile e UserProfileProvider

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intelliresume/core/providers/user_provider.dart';
import 'package:intelliresume/domain/entities/user_profile.dart';

/// Modelagem do uso de recursos pelo usuário
class UsageTracker {
  int aiInteractions;
  Set<String> templatesUsed;

  UsageTracker({this.aiInteractions = 0, Set<String>? templatesUsed})
    : templatesUsed = templatesUsed ?? {};
}

/// Notifier para controlar e atualizar o UsageTracker
class UsageTrackerNotifier extends StateNotifier<UsageTracker> {
  UsageTrackerNotifier() : super(UsageTracker());

  void incrementAI() {
    state = UsageTracker(
      aiInteractions: state.aiInteractions + 1,
      templatesUsed: state.templatesUsed,
    );
  }

  void addTemplateUse(String templateId) {
    final updated = Set<String>.from(state.templatesUsed)..add(templateId);
    state = UsageTracker(
      aiInteractions: state.aiInteractions,
      templatesUsed: updated,
    );
  }

  void reset() {
    state = UsageTracker();
  }
}

/// Provedor do UsageTracker
final usageTrackerProvider =
    StateNotifierProvider<UsageTrackerNotifier, UsageTracker>((ref) {
      return UsageTrackerNotifier();
    });

/// Serviço de lógica de negócios para verificar limites e registrar uso,
/// agora consumindo dados de UserProfileProvider
class BusinessLogicService {
  BusinessLogicService(this.ref);
  final Ref ref;

  /// Templates disponíveis por plano
  static const freeTemplates = <String>{
    'intelli_resume',
    'classic_minimal',
    'studant',
    '',
  };
  static const paidTemplates = <String>{
    'intelli_resume',
    'classic_minimal',
    'modern_side',
    'studant',
    'executive',
    'infographic',
    'international',
    'tech_developer',
    'timeline_template',
  };

  UserProfile? get _profile => ref.watch(userProfileProvider).value;
  PlanType get _plan => _profile?.plan ?? PlanType.free;
  int get _usedAI => ref.watch(usageTrackerProvider).aiInteractions;
  Set<String> get _usedTemplates =>
      ref.watch(usageTrackerProvider).templatesUsed;

  /// Retorna verdadeiro se o usuário pode usar o template
  bool canUseTemplate(String templateId) {
    if (_plan == PlanType.free) {
      return freeTemplates.contains(templateId);
    }
    return true; // premium pode usar todos
  }

  /// Registro de uso de template (chamar após checar canUseTemplate)
  void registerTemplateUse(String templateId) {
    if (!canUseTemplate(templateId)) {
      throw Exception('Template não disponível no seu plano atual.');
    }
    ref.read(usageTrackerProvider.notifier).addTemplateUse(templateId);
  }

  /// Verifica se usuário pode usar um recurso de IA
  bool canUseAI() {
    if (_plan == PlanType.free) {
      return _usedAI < 3;
    }
    return true; // premium ilimitado
  }

  /// Registra uso de interação com IA
  void registerAIUse() {
    if (!canUseAI()) {
      throw Exception(
        'Limite de interações com IA atingido no plano gratuito.',
      );
    }
    ref.read(usageTrackerProvider.notifier).incrementAI();
  }

  /// Verifica se pode exportar (sempre permitido)
  bool canExport() => true;

  /// Solicita upgrade de plano (delegado ao provider)
  void upgradeToPremium() {
    final notifier = ref.read(userProfileProvider.notifier);
    final profile = _profile;
    if (profile == null) throw Exception('Usuário não autenticado');
    final updated = profile.copyWith(plan: PlanType.premium);
    notifier.updateUser(updated);
    // opcional: resetar UsageTracker
    ref.read(usageTrackerProvider.notifier).reset();
  }
}

/// Provedor do serviço de lógica de negócios
final businessLogicServiceProvider = Provider<BusinessLogicService>((ref) {
  return BusinessLogicService(ref);
});

// Exemplo de uso no UI:
// final logic = ref.read(businessLogicServiceProvider);
// if (logic.canUseTemplate(id)) {
//   logic.registerTemplateUse(id);
//   // gerar CV
// } else {
//   // prompt para upgrade
// }

// Para IA:
// if (logic.canUseAI()) {
//   logic.registerAIUse();
//   // chamada IA
// } else {
//   // sugestão de plano premium
// }
