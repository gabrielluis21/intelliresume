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
  late final TextEditingController _nameController;
  late final TextEditingController _levelController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.skill.name);
    _levelController = TextEditingController(text: widget.skill.level);

    _nameController.addListener(_updateSkill);
    _levelController.addListener(_updateSkill);
  }

  @override
  void dispose() {
    _nameController.removeListener(_updateSkill);
    _levelController.removeListener(_updateSkill);

    _nameController.dispose();
    _levelController.dispose();
    super.dispose();
  }

  void _updateSkill() {
    final updatedSkill = Skill(
      name: _nameController.text,
      level: _levelController.text,
    );
    ref.read(localResumeProvider.notifier).updateSkill(widget.index, updatedSkill);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Habilidade',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.star_border_outlined),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _levelController,
                    decoration: const InputDecoration(
                      labelText: 'Nível (Ex: Avançado)',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.bar_chart_outlined),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  tooltip: 'Remover esta habilidade',
                  icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                  onPressed: () => ref.read(localResumeProvider.notifier).removeSkill(widget.index),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
