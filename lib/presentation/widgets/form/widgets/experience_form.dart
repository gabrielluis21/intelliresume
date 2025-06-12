import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/cv_provider.dart';
import '../../../../data/models/cv_data.dart';

class ExperienceForm extends ConsumerStatefulWidget {
  final int index;
  final Experience experience;

  const ExperienceForm({
    super.key,
    required this.index,
    required this.experience,
  });

  @override
  _ExperienceFormState createState() => _ExperienceFormState();
}

class _ExperienceFormState extends ConsumerState<ExperienceForm> {
  late TextEditingController _companyController;
  late TextEditingController _positionController;
  late TextEditingController _startDateController;
  late TextEditingController _endDateController;
  late TextEditingController _descriptionController;

  final _expFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _companyController = TextEditingController(text: widget.experience.company);
    _positionController = TextEditingController(
      text: widget.experience.position,
    );
    _startDateController = TextEditingController(
      text: widget.experience.startDate,
    );
    _endDateController = TextEditingController(text: widget.experience.endDate);
    _descriptionController = TextEditingController(
      text: widget.experience.description ?? '',
    );
  }

  @override
  void didUpdateWidget(ExperienceForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.experience != widget.experience) {
      _companyController.text = widget.experience.company ?? '';
      _positionController.text = widget.experience.position ?? '';
      _startDateController.text = widget.experience.startDate ?? '';
      _endDateController.text = widget.experience.endDate ?? '';
      _descriptionController.text = widget.experience.description ?? '';
    }
  }

  @override
  void dispose() {
    _companyController.dispose();
    _positionController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _updateExperience() {
    ref
        .read(resumeProvider.notifier)
        .updateExperience(
          widget.index,
          Experience(
            company: _companyController.text,
            position: _positionController.text,
            startDate: _startDateController.text,
            endDate: _endDateController.text,
            description:
                _descriptionController.text.isNotEmpty
                    ? _descriptionController.text
                    : null,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _expFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _companyController,
                decoration: const InputDecoration(
                  labelText: 'Empresa *',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _positionController,
                decoration: const InputDecoration(
                  labelText: 'Cargo *',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _startDateController,
                      decoration: InputDecoration(
                        labelText: 'Data Início *',
                        border: OutlineInputBorder(),
                        suffixIcon: IconButton(
                          onPressed: () async {
                            final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now(),
                            );
                            if (picked != null) {
                              _startDateController.text =
                                  "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
                            }
                          },
                          icon: const Icon(Icons.calendar_month),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: _endDateController,
                      keyboardType: TextInputType.datetime,
                      decoration: InputDecoration(
                        labelText: 'Data Término',
                        suffixIcon: IconButton(
                          onPressed: () async {
                            final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now(),
                            );
                            if (picked != null) {
                              _endDateController.text =
                                  "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
                            }
                          },
                          icon: const Icon(Icons.calendar_month),
                        ),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Descrição (opcional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Row(
                  children: [
                    ElevatedButton(
                      onPressed: () => _updateExperience(),
                      child: const Text('Salvar'),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed:
                          () => ref
                              .read(resumeProvider.notifier)
                              .removeExperience(widget.index),
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
