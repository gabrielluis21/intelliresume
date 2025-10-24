import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intelliresume/core/providers/data/data_provider.dart';
import 'package:intelliresume/core/providers/user/user_provider.dart';
import 'package:intelliresume/di.dart';
import 'package:intelliresume/presentation/pages/resume_preview_page.dart';
import 'package:intelliresume/presentation/widgets/ai_assistant_panel.dart';
import 'package:intelliresume/presentation/widgets/preview_dialog.dart';
import 'package:intelliresume/presentation/widgets/side_menu.dart';
import 'package:multi_split_view/multi_split_view.dart';
import 'package:intelliresume/data/models/cv_data.dart';
import '../../core/providers/resume/cv_provider.dart';
import 'package:intelliresume/generated/app_localizations.dart';
import '../widgets/form/resume_form.dart';

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

class ResumeFormPage extends ConsumerWidget {
  final String resumeId;
  const ResumeFormPage({super.key, required this.resumeId});

  void _onDestinationSelected(BuildContext context, int index, WidgetRef ref) {
    switch (index) {
      case 0:
        context.goNamed('home');
        break;
      case 1:
        context.goNamed('profile');
        break;
      case 2:
        context.goNamed('history');
        break;
      case 3:
        context.goNamed('form');
        break;
      case 4:
        context.goNamed('settings');
        break;
      case 5:
        ref.read(signOutUseCaseProvider).call();
        break;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final asyncResumeData = ref.watch(resumeDataProvider(resumeId));
    final theme = Theme.of(context);
    final isWide = MediaQuery.of(context).size.width > 800;

    return asyncResumeData.when(
      loading:
          () =>
              const Scaffold(body: Center(child: CircularProgressIndicator())),
      error:
          (err, stack) => Scaffold(
            appBar: AppBar(title: Text(l10n.erro)),
            body: Center(
              child: Text(l10n.resumeForm_failedToLoadResume(err.toString())),
            ),
          ),
      data: (resumeData) {
        // O layout principal é construído aqui, agora com resumeData garantido
        return Scaffold(
          appBar: AppBar(title: Text(l10n.appTitle)),
          drawer: SideMenu(
            selectedIndex: 3, // Hardcoded para a página de formulário
            onDestinationSelected:
                (index) => _onDestinationSelected(context, index, ref),
          ),
          body: LayoutBuilder(
            builder: (context, constraints) {
              if (isWide) {
                // Layout para telas largas
                return Column(
                  children: [
                    // ... (Card de boas-vindas)
                    Expanded(
                      child: MultiSplitView(
                        // ... (configuração do MultiSplitView)
                        initialAreas: [
                          Area(
                            builder:
                                (context, area) =>
                                    ResumeForm(resume: resumeData),
                          ),
                          Area(builder: (context, area) => ResumePreviewPage()),
                        ],
                      ),
                    ),
                  ],
                );
              } else {
                // Layout para telas estreitas
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      ResumeForm(resume: resumeData),
                      const Divider(),
                      const SizedBox(height: 500, child: AIAssistantPanel()),
                      const Divider(),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ElevatedButton.icon(
                          icon: Icon(
                            Icons.visibility,
                            semanticLabel: l10n.resumeForm_eyeIconSemanticLabel,
                          ),
                          label: Text(l10n.preview),
                          onPressed:
                              () => showDialog(
                                context: context,
                                builder: (_) {
                                  final currentResumeData = ref.read(
                                    localResumeProvider,
                                  );
                                  return PreviewDialog(
                                    resume: currentResumeData,
                                  );
                                },
                              ),
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        );
      },
    );
  }
}
