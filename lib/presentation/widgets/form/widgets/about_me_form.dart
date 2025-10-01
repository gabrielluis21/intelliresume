import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/resume/cv_provider.dart';

class AboutMeForm extends ConsumerStatefulWidget {
  final String about;

  const AboutMeForm({super.key, required this.about});

  @override
  ConsumerState<AboutMeForm> createState() => _AboutMeFormState();
}

class _AboutMeFormState extends ConsumerState<AboutMeForm> {
  late TextEditingController _aboutController;

  @override
  void initState() {
    super.initState();
    _aboutController = TextEditingController(text: widget.about);
  }

  @override
  void didUpdateWidget(AboutMeForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.about != widget.about) {
      _aboutController.text = widget.about;
    }
  }

  void _updatebout() {
    ref.read(localResumeProvider.notifier).updateAbout(_aboutController.text);
  }

  @override
  void dispose() {
    _aboutController.dispose();
    super.dispose();
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
            TextFormField(
              maxLines: 6,
              minLines: 1,
              keyboardType: TextInputType.multiline,
              controller: _aboutController,
              onChanged: (value) {
                ref.read(localResumeProvider.notifier).updateAbout(value);
              },
              decoration: const InputDecoration(
                labelText: 'Sobre Mim *',
                hintText: 'Faça um breve resumo sobre você...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: () => _updatebout(),
                    child: const Text('Salvar'),
                  ),
                  Semantics(
                    label: 'Remover objetivo',
                    child: IconButton(
                      tooltip: 'Remover objetivo',
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        ref
                            .read(localResumeProvider.notifier)
                            .removeObjective();
                        _aboutController.clear();
                      },
                    ),
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
