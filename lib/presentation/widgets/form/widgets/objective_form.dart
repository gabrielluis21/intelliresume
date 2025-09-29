import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/resume/cv_provider.dart';

class ObjectiveForm extends ConsumerStatefulWidget {
  final String objective;

  const ObjectiveForm({super.key, required this.objective});

  @override
  ConsumerState<ObjectiveForm> createState() => _ObjectiveFormState();
}

class _ObjectiveFormState extends ConsumerState<ObjectiveForm> {
  late TextEditingController _objectiveController;

  final _objFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _objectiveController = TextEditingController(text: widget.objective);
  }

  @override
  void didUpdateWidget(ObjectiveForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.objective != widget.objective) {
      _objectiveController.text = widget.objective;
    }
  }

  @override
  void dispose() {
    _objectiveController.dispose();
    super.dispose();
  }

  void _updateObjective() {
    ref
        .read(localResumeProvider.notifier)
        .updateObjective(_objectiveController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _objFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                maxLines: 6,
                minLines: 1,
                keyboardType: TextInputType.multiline,
                controller: _objectiveController,
                decoration: const InputDecoration(
                  labelText: 'Objetivo(s) *',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: Row(
                  children: [
                    ElevatedButton(
                      onPressed: () => _updateObjective(),
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
                          _objectiveController.clear();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
