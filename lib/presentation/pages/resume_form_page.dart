import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intelliresume/core/providers/user_provider.dart';
import 'package:intelliresume/data/datasources/remote/auth_resume_ds.dart';
import 'package:intelliresume/presentation/widgets/export_buttons.dart';
import 'package:intelliresume/presentation/widgets/preview/resume_preview.dart';
import 'package:intelliresume/presentation/widgets/side_menu.dart';
//import 'package:printing/printing.dart';
import '../../core/providers/cv_provider.dart';
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
    final current = ref.watch(userProfileProvider);
    final resumeData = ref.watch(resumeProvider);
    var resume = resumeData.copyWith(personalInfo: current.value);
    print(resume.toMap());

    return Scaffold(
      appBar: AppBar(title: Text(t.appTitle)),
      drawer: SideMenu(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onDestinationSelected,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (isWide) {
            return InkWell(
              onTap:
                  () => showAdaptiveDialog(
                    context: context,
                    builder:
                        (_) => AlertDialog.adaptive(
                          contentPadding: EdgeInsets.all(4),
                          actionsPadding: EdgeInsets.all(15),
                          scrollable: true,
                          content: SizedBox(
                            height: MediaQuery.of(context).size.height * .90,
                            width: MediaQuery.of(context).size.width * .80,
                            child: ResumePreview(),
                          ),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Preview"),
                              IconButton(
                                onPressed: () => Navigator.of(context).pop(),
                                icon: Icon(Icons.close, color: Colors.red),
                              ),
                            ],
                          ),
                          actions: [ExportButtons(resumeData: resume)],
                        ),
                  ),
              child: Row(
                children: [
                  Expanded(child: ResumeForm()),
                  const VerticalDivider(),
                  Expanded(child: ResumePreview()),
                ],
              ),
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
                                    onPressed: () {
                                      context.pushNamed('preview-pdf');
                                    },
                                    child: Text("Exportar PDF"),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      context.pushNamed('preview-docx');
                                    },
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
