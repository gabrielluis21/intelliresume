import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/cv_provider.dart';
import '../../../../data/models/cv_data.dart';

class EducationForm extends ConsumerStatefulWidget {
  final int index;
  final Education education;

  const EducationForm({Key? key, required this.index, required this.education})
    : super(key: key);

  @override
  _EducationFormState createState() => _EducationFormState();
}

class _EducationFormState extends ConsumerState<EducationForm> {
  late TextEditingController _schoolController;
  late TextEditingController _degreeController;
  late TextEditingController _startDateController;
  late TextEditingController _endDateController;

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
    if (oldWidget.education != widget.education) {
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
    ref
        .read(resumeProvider.notifier)
        .updateEducation(
          widget.index,
          Education(
            school: _schoolController.text,
            degree: _degreeController.text,
            startDate: _startDateController.text,
            endDate: _endDateController.text,
          ),
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
              controller: _schoolController,
              decoration: const InputDecoration(
                labelText: 'Instituição *',
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => _updateEducation(),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _degreeController,
              decoration: const InputDecoration(
                labelText: 'Curso *',
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => _updateEducation(),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _startDateController,
                    decoration: const InputDecoration(
                      labelText: 'Data Início *',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (_) => _updateEducation(),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _endDateController,
                    decoration: const InputDecoration(
                      labelText: 'Data Término',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (_) => _updateEducation(),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed:
                    () => ref
                        .read(resumeProvider.notifier)
                        .removeEducation(widget.index),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
