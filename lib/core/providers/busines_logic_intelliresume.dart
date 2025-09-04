// business_logic.dart
// Lógica de negócios integrada a UserProfile e UserProfileProvider

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intelliresume/core/providers/user_provider.dart';
import 'package:intelliresume/domain/entities/user_profile.dart';
import 'package:intelliresume/domain/entities/plan_type.dart';

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
    'classic',
    'studant_first_job',
    '',
  };
  static const paidTemplates = <String>{
    'intelliresume_pattern',
    'classic',
    'modern_with_sidebar',
    'timeline',
    'studant_first_job',
    'infographic',
    'international',
    'dev_tec',
  };

  // Defina aqui os templates que são exclusivos do plano Pro, se houver.
  // Se o Pro incluir todos os do Premium mais alguns, liste apenas os extras.
  static const proTemplates = <String>{
    // 'pro_exclusive_template'
  };

  UserProfile? get _profile => ref.watch(userProfileProvider).value;
  PlanType get _plan => _profile?.plan ?? PlanType.free;
  int get _usedAI => ref.watch(usageTrackerProvider).aiInteractions;
  /* Set<String> get _usedTemplates =>
      ref.watch(usageTrackerProvider).templatesUsed; */

  /// Retorna verdadeiro se o usuário pode usar o template
  bool canUseTemplate(String templateId) {
    if (_plan == PlanType.free) {
      return freeTemplates.contains(templateId);
    }
    if (_plan == PlanType.premium) {
      // Premium pode usar os gratuitos e os pagos
      return freeTemplates.contains(templateId) ||
          paidTemplates.contains(templateId);
    }
    if (_plan == PlanType.pro) {
      return true; // Pro pode usar todos
    }
    return false; // Por padrão, bloqueia se o plano for desconhecido
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
    // A lógica pode ser expandida aqui para diferentes limites por plano
    if (_plan == PlanType.free) {
      return _usedAI < 3;
    }
    // Premium e Pro têm uso ilimitado
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

  /// Atualiza o plano do usuário no perfil principal
  void upgradePlan(PlanType newPlan) {
    final notifier = ref.read(userProfileProvider.notifier);
    final profile = _profile;
    if (profile == null) throw Exception('Usuário não autenticado');
    final updated = profile.copyWith(plan: newPlan);
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
