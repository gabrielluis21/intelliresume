import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../data/models/cv_data.dart';
import '../../../../core/providers/cv_provider.dart';

class SocialForm extends ConsumerStatefulWidget {
  final int index;
  final Social social;

  const SocialForm({super.key, required this.index, required this.social});

  @override
  ConsumerState<SocialForm> createState() => _SocialFormState();
}

class _SocialFormState extends ConsumerState<SocialForm> {
  late TextEditingController _platformController;
  late TextEditingController _urlController;

  @override
  void initState() {
    super.initState();
    _platformController = TextEditingController(text: widget.social.platform);
    _urlController = TextEditingController(text: widget.social.url);
  }

  @override
  void didUpdateWidget(SocialForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.social != widget.social) {
      _platformController.text = widget.social.platform ?? '';
      _urlController.text = widget.social.url ?? '';
    }
  }

  @override
  void dispose() {
    _platformController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  void _updateSocial() {
    ref
        .read(resumeProvider.notifier)
        .updateSocial(
          widget.index,
          Social(platform: _platformController.text, url: _urlController.text),
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
              controller: _platformController,
              decoration: const InputDecoration(
                labelText: 'Plataforma (ex: LinkedIn) *',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _urlController,
              decoration: const InputDecoration(
                labelText: 'URL *',
                border: OutlineInputBorder(),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: _updateSocial,
                    child: const Text('Salvar'),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed:
                        () => ref
                            .read(resumeProvider.notifier)
                            .removeSocial(widget.index),
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
