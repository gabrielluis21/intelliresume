import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/resume/cv_provider.dart';
import '../../../../data/models/cv_data.dart';

class CertificateForm extends ConsumerStatefulWidget {
  final int index;
  final Certificate certificate;

  const CertificateForm({
    super.key,
    required this.index,
    required this.certificate,
  });

  @override
  ConsumerState<CertificateForm> createState() => _CertificateFormState();
}

class _CertificateFormState extends ConsumerState<CertificateForm> {
  late final TextEditingController _courseNameController;
  late final TextEditingController _institutionController;
  late final TextEditingController _workloadController;
  late final TextEditingController _startDateController;
  late final TextEditingController _endDateController;

  @override
  void initState() {
    super.initState();
    _courseNameController = TextEditingController(
      text: widget.certificate.courseName,
    );
    _institutionController = TextEditingController(
      text: widget.certificate.institution,
    );
    _workloadController = TextEditingController(
      text: widget.certificate.workload,
    );
    _startDateController = TextEditingController(
      text: widget.certificate.startDate,
    );
    _endDateController = TextEditingController(
      text: widget.certificate.endDate,
    );
  }

  @override
  void didUpdateWidget(CertificateForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.certificate != oldWidget.certificate) {
      _courseNameController.text = widget.certificate.courseName ?? '';
      _institutionController.text = widget.certificate.institution ?? '';
      _workloadController.text = widget.certificate.workload ?? '';
      _startDateController.text = widget.certificate.startDate ?? '';
      _endDateController.text = widget.certificate.endDate ?? '';
    }
  }

  @override
  void dispose() {
    _courseNameController.dispose();
    _institutionController.dispose();
    _workloadController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  void _updateCertificate() {
    final updatedCertificate = Certificate(
      courseName: _courseNameController.text,
      institution: _institutionController.text,
      workload: _workloadController.text,
      startDate: _startDateController.text,
      endDate: _endDateController.text,
    );
    ref
        .read(localResumeProvider.notifier)
        .updateCertificate(widget.index, updatedCertificate);
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
                  'Certificado #${widget.index + 1}',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    IconButton(
                      tooltip: 'Salvar',
                      icon: const Icon(Icons.save_outlined),
                      onPressed: _updateCertificate,
                    ),
                    IconButton(
                      tooltip: 'Remover este certificado',
                      icon: const Icon(
                        Icons.delete_outline,
                        color: Colors.redAccent,
                      ),
                      onPressed:
                          () => ref
                              .read(localResumeProvider.notifier)
                              .removeCertificate(widget.index),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _courseNameController,
              decoration: const InputDecoration(
                labelText: 'Nome do Curso',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.school_outlined),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _institutionController,
              decoration: const InputDecoration(
                labelText: 'Instituição',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.business),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _workloadController,
              decoration: const InputDecoration(
                labelText: 'Carga Horária',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.timer_outlined),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _startDateController,
                    decoration: const InputDecoration(
                      labelText: 'Data de Início',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _endDateController,
                    decoration: const InputDecoration(
                      labelText: 'Data de Fim',
                      border: OutlineInputBorder(),
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
