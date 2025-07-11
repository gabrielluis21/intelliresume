import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../data/models/cv_data.dart';
import '../../../../core/providers/cv_provider.dart';

class SkillForm extends ConsumerStatefulWidget {
  final int index;
  final Skill skill;

  const SkillForm({super.key, required this.index, required this.skill});

  @override
  ConsumerState<SkillForm> createState() => _SkillFormState();
}

class _SkillFormState extends ConsumerState<SkillForm> {
  late TextEditingController _nameController;
  late TextEditingController _levelController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.skill.name);
    _levelController = TextEditingController(text: widget.skill.level);
  }

  @override
  void didUpdateWidget(SkillForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.skill != widget.skill) {
      _nameController.text = widget.skill.name ?? '';
      _levelController.text = widget.skill.level ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _levelController.dispose();
    super.dispose();
  }

  void _updateSkill() {
    ref
        .read(resumeProvider.notifier)
        .updateSkill(
          widget.index,
          Skill(name: _nameController.text, level: _levelController.text),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Habilidade *',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _levelController,
              decoration: const InputDecoration(
                labelText: 'Nível (ex: Intermediário) *',
                border: OutlineInputBorder(),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: () => _updateSkill(),
                    child: const Text('Salvar'),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed:
                        () => ref
                            .read(resumeProvider.notifier)
                            .removeSkill(widget.index),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
