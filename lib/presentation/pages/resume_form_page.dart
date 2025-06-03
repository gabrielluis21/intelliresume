// Melhorias aplicadas:
// - Separação de responsabilidades (SOLID)
// - Extração de widgets para limpeza de código
// - Validações mais robustas
// - Melhor UX para mobile e PWA (scroll suave, botões fixos, feedback claro)
// - Internationalization support mantido
// - Padding e espaçamento consistente para acessibilidade

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intelliresume/data/datasources/remote/auth_resume_ds.dart';
import 'package:intelliresume/presentation/widgets/layout_template.dart';
import 'package:intelliresume/presentation/widgets/resume_preview.dart';
import 'package:intelliresume/presentation/widgets/side_menu.dart';
import '../../core/providers/resume_template_provider.dart';
import '../../core/utils/app_localizations.dart';
import '../widgets/resume_form.dart';

class ResumeFormPage extends ConsumerStatefulWidget {
  const ResumeFormPage({super.key});

  @override
  ConsumerState<ResumeFormPage> createState() => _ResumeFormPageState();
}

class _ResumeFormPageState extends ConsumerState<ResumeFormPage> {
  int _selectedIndex = 3; // Default to Form page

  void _onDestinationSelected(int index) {
    setState(() => _selectedIndex = index);

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
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final isWide = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: AppBar(title: Text(t.appTitle)),
      drawer: SideMenu(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onDestinationSelected,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (isWide) {
            return Row(
              children: [
                Expanded(child: ResumeFormContent()),
                const VerticalDivider(),
                Expanded(child: ResumePreview()),
              ],
            );
          } else {
            return SingleChildScrollView(
              child: Column(
                children: [
                  ResumeFormContent(),
                  const Divider(),
                  ResumePreview(),
                ],
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showTemplateDialog(context, ref),
        icon: Icon(Icons.palette),
        label: Text('Select Theme'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  void _showTemplateDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Escolha um modelo de currículo'),
          content: SingleChildScrollView(
            child: Column(
              children:
                  resumeTemplates.map((template) {
                    return ListTile(
                      title: Text(template.name),
                      subtitle: Text(
                        'Fonte: ${template.fontFamily}, Colunas: ${template.columns}',
                      ),
                      onTap: () {
                        ref.read(selectedTemplateProvider.notifier).state =
                            template;
                        Navigator.of(context).pop();
                      },
                    );
                  }).toList(),
            ),
          ),
        );
      },
    );
  }
}
