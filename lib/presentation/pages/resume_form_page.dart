import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intelliresume/data/datasources/remote/auth_resume_ds.dart';
import 'package:intelliresume/presentation/widgets/preview/resume_preview.dart';
import 'package:intelliresume/presentation/widgets/side_menu.dart';
import '../../core/utils/app_localizations.dart';
import '../widgets/form/resume_form.dart';

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
                Expanded(child: ResumeForm()),
                const VerticalDivider(),
                Expanded(
                  child: InkWell(
                    onTap:
                        () => showAdaptiveDialog(
                          context: context,
                          builder:
                              (_) => AlertDialog.adaptive(
                                content: ResumePreview(),
                                title: Text("Preview"),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () {},
                                    child: Text("Exportar PDF"),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {},
                                    child: Text("Exportar DOCX"),
                                  ),
                                  IconButton(
                                    onPressed: () {},
                                    icon: Icon(Icons.print, color: Colors.blue),
                                  ),
                                  IconButton(
                                    onPressed:
                                        () => Navigator.of(context).pop(),
                                    icon: Icon(Icons.close, color: Colors.red),
                                  ),
                                ],
                              ),
                        ),
                    child: ResumePreview(),
                  ),
                ),
              ],
            );
          } else {
            return SingleChildScrollView(
              child: Column(
                children: [
                  ResumeForm(),
                  const Divider(),
                  InkWell(
                    onTap:
                        () => showAdaptiveDialog(
                          context: context,
                          builder:
                              (_) => AlertDialog.adaptive(
                                content: ResumePreview(),
                                title: Text("Preview"),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () {},
                                    child: Text("Exportar PDF"),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {},
                                    child: Text("Exportar DOCX"),
                                  ),
                                  IconButton(
                                    onPressed: () {},
                                    icon: Icon(Icons.print, color: Colors.blue),
                                  ),
                                  IconButton(
                                    onPressed:
                                        () => Navigator.of(context).pop(),
                                    icon: Icon(Icons.close, color: Colors.red),
                                  ),
                                ],
                              ),
                        ),
                    child: ResumePreview(),
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
