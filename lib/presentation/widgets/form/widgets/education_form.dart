import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/resume/cv_provider.dart';
import '../../../../data/models/cv_data.dart';

class EducationForm extends ConsumerStatefulWidget {
  final int index;
  final Education education;

  const EducationForm({
    super.key,
    required this.index,
    required this.education,
  });

  @override
  ConsumerState<EducationForm> createState() => _EducationFormState();
}

class _EducationFormState extends ConsumerState<EducationForm> {
  late final TextEditingController _schoolController;
  late final TextEditingController _degreeController;
  late final TextEditingController _startDateController;
  late final TextEditingController _endDateController;

  @override
  void initState() {
    super.initState();
    _schoolController = TextEditingController(text: widget.education.school);
    _degreeController = TextEditingController(text: widget.education.degree);
    _startDateController = TextEditingController(
      text: widget.education.startDate,
    );
    _endDateController = TextEditingController(text: widget.education.endDate);
  }

  @override
  void didUpdateWidget(EducationForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.education != oldWidget.education) {
      _schoolController.text = widget.education.school ?? '';
      _degreeController.text = widget.education.degree ?? '';
      _startDateController.text = widget.education.startDate ?? '';
      _endDateController.text = widget.education.endDate ?? '';
    }
  }

  @override
  void dispose() {
    _schoolController.dispose();
    _degreeController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  void _updateEducation() {
    final updatedEducation = Education(
      school: _schoolController.text,
      degree: _degreeController.text,
      startDate: _startDateController.text,
      endDate: _endDateController.text,
    );
    ref
        .read(localResumeProvider.notifier)
        .updateEducation(widget.index, updatedEducation);
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Formação #${widget.index + 1}',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    IconButton(
                      tooltip: 'Salvarr esta formação',
                      icon: const Icon(
                        Icons.save_outlined,
                        color: Colors.blueAccent,
                      ),
                      onPressed: _updateEducation,
                    ),
                    IconButton(
                      tooltip: 'Remover esta formação',
                      icon: const Icon(
                        Icons.delete_outline,
                        color: Colors.redAccent,
                      ),
                      onPressed:
                          () => ref
                              .read(localResumeProvider.notifier)
                              .removeEducation(widget.index),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _schoolController,
              //onChanged: (_) => _updateEducation(),
              decoration: const InputDecoration(
                labelText: 'Instituição',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.school_outlined),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _degreeController,
              //onChanged: (_) => _updateEducation(),
              decoration: const InputDecoration(
                labelText: 'Curso / Graduação',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.book_outlined),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _startDateController,
                    //onChanged: (_) => _updateEducation(),
                    decoration: InputDecoration(
                      labelText: 'Data de Início',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        tooltip: 'Selecionar data de início',
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1950),
                            lastDate: DateTime.now(),
                          );
                          if (picked != null) {
                            _startDateController.text =
                                "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
                            _updateEducation();
                          }
                        },
                        icon: const Icon(Icons.calendar_today),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _endDateController,
                    //onChanged: (_) => _updateEducation(),
                    decoration: InputDecoration(
                      labelText: 'Data de Término',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        tooltip: 'Selecionar data de término',
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1950),
                            lastDate: DateTime.now(),
                          );
                          if (picked != null) {
                            _endDateController.text =
                                "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
                            _updateEducation();
                          }
                        },
                        icon: const Icon(Icons.calendar_today),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
