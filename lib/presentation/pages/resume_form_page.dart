import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intelliresume/core/providers/user/user_provider.dart';
import 'package:intelliresume/data/datasources/remote/auth_resume_ds.dart';
import 'package:intelliresume/presentation/pages/resume_preview_page.dart';
import 'package:intelliresume/presentation/widgets/ai_assistant_panel.dart';
//import 'package:intelliresume/presentation/widgets/preview/resume_preview.dart';
import 'package:intelliresume/presentation/widgets/preview_dialog.dart';
import 'package:intelliresume/presentation/widgets/side_menu.dart';
import 'package:multi_split_view/multi_split_view.dart';
//import 'package:printing/printing';
import '../../core/providers/resume/cv_provider.dart';
import '../../core/utils/app_localizations.dart';
import '../widgets/form/resume_form.dart';

class ResumeFormPage extends ConsumerWidget {
  const ResumeFormPage({super.key});

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
        AuthService.instance.signOut();
        context.goNamed('login');
        break;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Sincroniza o userProfile com o localResumeProvider
    ref.listen<AsyncValue<dynamic>>(userProfileProvider, (previous, next) {
      final user = next.value;
      if (user != null) {
        ref.read(localResumeProvider.notifier).updatePersonalInfo(user);
      }
    });

    final t = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isWide =
        MediaQuery.of(context).size.width >
        800; // Aumentado para melhor acomodar o painel

    // Lê o estado do currículo a partir do provider, que é a única fonte de verdade.
    final resumeData = ref.watch(localResumeProvider);

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
            // Layout para telas largas com painel de instruções
            return Column(
              children: [
                Card(
                  margin: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                  color: theme.colorScheme.primaryContainer.withOpacity(0.5),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: theme.colorScheme.outlineVariant),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            "Bem-vindo ao Modo Estúdio! Use o painel de Edição à esquerda e veja o resultado em tempo real à direita. Dica: Clique em um item na visualização para editá-lo!",
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Semantics(
                    label:
                        "Modo Estúdio. O painel da esquerda contém o formulário para editar os dados. O painel da direita mostra a pré-visualização e opções de criação. As alterações são refletidas em tempo real.",
                    child: MultiSplitView(
                      axis: Axis.horizontal,
                      dividerBuilder: (
                        axis,
                        index,
                        resizable,
                        dragging,
                        highlighted,
                        themeData,
                      ) {
                        return Container(
                          color: dragging ? Colors.teal[300] : Colors.teal[100],
                          child: Icon(
                            Icons.drag_indicator_sharp,
                            size: 10,
                            color:
                                highlighted
                                    ? Colors.teal[600]
                                    : Colors.teal[400],
                          ),
                        );
                      },
                      pushDividers: true,
                      initialAreas: [
                        Area(
                          builder:
                              (context, area) => Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Semantics(
                                      header: true,
                                      child: Text(
                                        "Área de Edição",
                                        style: theme.textTheme.titleMedium,
                                      ),
                                    ),
                                  ),
                                  Expanded(child: ResumeForm()),
                                ],
                              ),
                        ),
                        Area(
                          builder:
                              (context, area) => Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Semantics(
                                      header: true,
                                      child: Text(
                                        "Visualização e Assistente de IA",
                                        style: theme.textTheme.titleMedium,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: ResumePreviewPage(
                                      resumeData: resumeData,
                                    ),
                                  ),
                                ],
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else {
            // Layout para telas estreitas com o Painel de IA no final
            return SingleChildScrollView(
              child: Column(
                children: [
                  const ResumeForm(),
                  const Divider(),
                  // Adiciona o painel de IA aqui para mobile
                  const SizedBox(
                    height: 500, // Altura definida para o painel em mobile
                    child: AIAssistantPanel(),
                  ),
                  const Divider(),
                  // Mantém o preview acessível por um botão/dialog
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.visibility),
                      label: const Text("Visualizar Currículo"),
                      onPressed:
                          () => showDialog(
                            context: context,
                            builder: (_) {
                              final currentResumeData = ref.read(
                                localResumeProvider,
                              );
                              return PreviewDialog(resume: currentResumeData);
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
  }
}
