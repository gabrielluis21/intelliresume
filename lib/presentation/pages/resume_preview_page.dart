import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intelliresume/core/providers/editor/editor_providers.dart';
import 'package:intelliresume/core/providers/resume/cv_provider.dart';
import 'package:intelliresume/core/providers/user/user_provider.dart';
import 'package:intelliresume/presentation/pages.dart';
import 'package:intelliresume/presentation/pages/export/export_page.dart';
import 'package:intelliresume/presentation/widgets/ai_assistant_panel.dart';

class ResumePreviewPage extends ConsumerStatefulWidget {
  const ResumePreviewPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ResumePreviewPageState();
}

class _ResumePreviewPageState extends ConsumerState<ResumePreviewPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _tabs = <Widget>[
    const Tab(icon: Icon(Icons.remove_red_eye), text: 'Pré-visualização'),
    const Tab(icon: Icon(Icons.person_search_outlined), text: 'IA Assintente'),
    const Tab(icon: Icon(Icons.share_outlined), text: 'Exportação'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    print(ref.read(localResumeProvider).toMap());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProfileAsync = ref.watch(userProfileProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editor de Currículo'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: _tabs,
        ),
      ),
      body: userProfileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Erro: $err')),
        data: (userData) {
          final tabViews = <Widget>[
            ResumePreview(
              resumeData: ref.read(localResumeProvider),
              userData: userData,
              onSectionEdit: (type, index) {
                ref.read(editRequestProvider.notifier).state = EditRequest(
                  section: type,
                  index: index,
                );
              },
            ),
            AIAssistantPanel(),
            ExportPage(resumeData: ref.watch(localResumeProvider)),
          ];
          return TabBarView(controller: _tabController, children: tabViews);
        },
      ),
    );
  }
}
