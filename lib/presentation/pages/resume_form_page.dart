import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intelliresume/core/providers/user/user_provider.dart';
import 'package:intelliresume/di.dart';
import 'package:intelliresume/presentation/pages/resume_preview_page.dart';
import 'package:intelliresume/presentation/widgets/ai_assistant_panel.dart';
import 'package:intelliresume/presentation/widgets/preview_dialog.dart';
import 'package:intelliresume/presentation/widgets/side_menu.dart';
import 'package:multi_split_view/multi_split_view.dart';
import 'package:intelliresume/data/models/cv_data.dart';
import '../../core/providers/resume/cv_provider.dart';
import '../../core/utils/app_localizations.dart';
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
    // ... (código do menu lateral pode ser mantido ou ajustado)
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncResumeData = ref.watch(resumeDataProvider(resumeId));
    final t = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isWide = MediaQuery.of(context).size.width > 800;

    return asyncResumeData.when(
      loading:
          () =>
              const Scaffold(body: Center(child: CircularProgressIndicator())),
      error:
          (err, stack) => Scaffold(
            appBar: AppBar(title: const Text('Erro')),
            body: Center(child: Text('Falha ao carregar o currículo: $err')),
          ),
      data: (resumeData) {
        // O layout principal é construído aqui, agora com resumeData garantido
        return Scaffold(
          appBar: AppBar(title: Text(t.appTitle)),
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
                          icon: const Icon(
                            Icons.visibility,
                            semanticLabel: 'Ícone de olho',
                          ),
                          label: const Text("Visualizar Currículo"),
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
