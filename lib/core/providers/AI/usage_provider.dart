import 'package:flutter_riverpod/legacy.dart';

/// Modelagem do uso de recursos pelo usuário na sessão atual.
class UsageTracker {
  final int aiInteractions;
  final Set<String> templatesUsed;

  UsageTracker({this.aiInteractions = 0, Set<String>? templatesUsed})
    : templatesUsed = templatesUsed ?? {};
}

/// Notifier para controlar e atualizar o UsageTracker.
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

/// Provider do UsageTracker para o estado da sessão.
final usageTrackerProvider =
    StateNotifierProvider<UsageTrackerNotifier, UsageTracker>((ref) {
      return UsageTrackerNotifier();
    });
