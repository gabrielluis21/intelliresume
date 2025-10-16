import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/resume/cv_provider.dart';
import '../../../../data/models/cv_data.dart';

class ProjectForm extends ConsumerStatefulWidget {
  final int index;
  final Project project;

  const ProjectForm({super.key, required this.index, required this.project});

  @override
  ConsumerState<ProjectForm> createState() => _ProjectFormState();
}

class _ProjectFormState extends ConsumerState<ProjectForm> {
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _urlController;
  late final TextEditingController _startYearController;
  late final TextEditingController _endYearController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.project.name);
    _descriptionController = TextEditingController(
      text: widget.project.description,
    );
    _urlController = TextEditingController(text: widget.project.url);
    _startYearController = TextEditingController(
      text: widget.project.startYear,
    );
    _endYearController = TextEditingController(text: widget.project.endYear);
  }

  @override
  void didUpdateWidget(ProjectForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.project != oldWidget.project) {
      _nameController.text = widget.project.name ?? '';
      _descriptionController.text = widget.project.description ?? '';
      _urlController.text = widget.project.url ?? '';
      _startYearController.text = widget.project.startYear ?? '';
      _endYearController.text = widget.project.endYear ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _urlController.dispose();
    _startYearController.dispose();
    _endYearController.dispose();
    super.dispose();
  }

  void _updateProject() {
    final updatedProject = Project(
      name: _nameController.text,
      description: _descriptionController.text,
      url: _urlController.text,
      startYear: _startYearController.text,
      endYear: _endYearController.text,
    );
    ref
        .read(localResumeProvider.notifier)
        .updateProject(widget.index, updatedProject);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Add logic to show/hide attachments based on PRO plan
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Projeto #${widget.index + 1}',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    IconButton(
                      tooltip: 'Salvar',
                      icon: const Icon(Icons.save_outlined),
                      onPressed: _updateProject,
                    ),
                    IconButton(
                      tooltip: 'Remover este projeto',
                      icon: const Icon(
                        Icons.delete_outline,
                        color: Colors.redAccent,
                      ),
                      onPressed:
                          () => ref
                              .read(localResumeProvider.notifier)
                              .removeProject(widget.index),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nome do Projeto',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.title),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _urlController,
              decoration: const InputDecoration(
                labelText: 'Link do Projeto',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.link),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _startYearController,
                    decoration: const InputDecoration(
                      labelText: 'Ano de Início',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _endYearController,
                    decoration: const InputDecoration(
                      labelText: 'Ano de Fim',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Descrição (opcional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
              keyboardType: TextInputType.multiline,
            ),
          ],
        ),
      ),
    );
  }
}
