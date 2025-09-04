import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intelliresume/core/providers/cv_provider.dart';
import 'package:intelliresume/core/providers/user_provider.dart';
import 'package:intelliresume/data/models/cv_data.dart';
import 'package:intelliresume/presentation/pages.dart';
import 'package:intelliresume/presentation/pages/export/export_page.dart';
import 'package:intelliresume/presentation/widgets/ai_assistant_panel.dart';

class ResumePreviewPage extends ConsumerStatefulWidget {
  const ResumePreviewPage({super.key, this.resumeData});

  final ResumeData? resumeData;

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
    print(widget.resumeData?.toMap());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tabViews = <Widget>[
      ResumePreview(
        resumeData: widget.resumeData ?? ref.watch(localResumeProvider),
        userData: ref.watch(userProfileProvider).value,
        onSectionEdit: (type, index) {},
      ),
      AIAssistantPanel(),
      ExportPage(resumeData: ref.watch(localResumeProvider)),
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editor de Currículo'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: _tabs,
        ),
      ),
      body: TabBarView(controller: _tabController, children: tabViews),
    );
  }
}
