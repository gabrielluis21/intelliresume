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
  ConsumerState<ExperienceForm> createState() => _ExperienceFormState();
}

class _ExperienceFormState extends ConsumerState<ExperienceForm> {
  late final TextEditingController _companyController;
  late final TextEditingController _positionController;
  late final TextEditingController _startDateController;
  late final TextEditingController _endDateController;
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with initial data from the provider.
    _companyController = TextEditingController(text: widget.experience.company);
    _positionController = TextEditingController(text: widget.experience.position);
    _startDateController = TextEditingController(text: widget.experience.startDate);
    _endDateController = TextEditingController(text: widget.experience.endDate);
    _descriptionController = TextEditingController(text: widget.experience.description ?? '');

    // Add listeners to each controller to update the state in real-time.
    _companyController.addListener(_updateExperience);
    _positionController.addListener(_updateExperience);
    _startDateController.addListener(_updateExperience);
    _endDateController.addListener(_updateExperience);
    _descriptionController.addListener(_updateExperience);
  }

  @override
  void dispose() {
    // It's crucial to remove listeners before disposing the controllers.
    _companyController.removeListener(_updateExperience);
    _positionController.removeListener(_updateExperience);
    _startDateController.removeListener(_updateExperience);
    _endDateController.removeListener(_updateExperience);
    _descriptionController.removeListener(_updateExperience);

    _companyController.dispose();
    _positionController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // This method is now called on every keystroke, keeping the provider in sync.
  void _updateExperience() {
    // Use a debounce here in a real-world scenario if performance becomes an issue.
    final updatedExperience = Experience(
      company: _companyController.text,
      position: _positionController.text,
      startDate: _startDateController.text,
      endDate: _endDateController.text,
      description: _descriptionController.text,
    );
    ref.read(localResumeProvider.notifier).updateExperience(widget.index, updatedExperience);
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
                  'Experiência #${widget.index + 1}',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  tooltip: 'Remover esta experiência',
                  icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                  onPressed: () => ref.read(localResumeProvider.notifier).removeExperience(widget.index),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _companyController,
              decoration: const InputDecoration(
                labelText: 'Empresa',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.business),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _positionController,
              decoration: const InputDecoration(
                labelText: 'Cargo',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.work_outline),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _startDateController,
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
                            _startDateController.text = "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
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
                            _endDateController.text = "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
                          }
                        },
                        icon: const Icon(Icons.calendar_today),
                      ),
                    ),
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
