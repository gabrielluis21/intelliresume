import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intelliresume/core/providers/cv_provider.dart';
import 'package:intelliresume/core/providers/user_provider.dart';
import 'package:intelliresume/presentation/pages.dart';
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(localResumeProvider.notifier)
          .updatePersonalInfo(ref.watch(userProfileProvider).value);
    });
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
        resumeData: ref.watch(localResumeProvider),
        userData: ref.watch(userProfileProvider).value,
        onSectionEdit: (type, index) {},
      ),
      AIAssistantPanel(),
      Container(child: Text("Exportação aqui")),
    ];
    // TODO: implement build
    return Column(
      children: [
        TabBar(controller: _tabController, isScrollable: true, tabs: _tabs),
        Expanded(
          child: TabBarView(controller: _tabController, children: tabViews),
        ),
      ],
    );
  }
}
