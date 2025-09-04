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
  late final TextEditingController _platformController;
  late final TextEditingController _urlController;

  @override
  void initState() {
    super.initState();
    _platformController = TextEditingController(text: widget.social.platform);
    _urlController = TextEditingController(text: widget.social.url);
  }

  @override
  void didUpdateWidget(SocialForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.social != oldWidget.social) {
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
    final updatedSocial = Social(
      platform: _platformController.text,
      url: _urlController.text,
    );
    ref
        .read(localResumeProvider.notifier)
        .updateSocial(widget.index, updatedSocial);
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
                    controller: _platformController,
                    //onChanged: (_) => _updateSocial(),
                    decoration: const InputDecoration(
                      labelText: 'Plataforma (Ex: LinkedIn)',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.public),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _urlController,
                    //onChanged: (_) => _updateSocial(),
                    decoration: const InputDecoration(
                      labelText: 'URL do Perfil',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.link),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  tooltip: 'Salvar esta rede social',
                  icon: const Icon(
                    Icons.save_outlined,
                    color: Colors.blueAccent,
                  ),
                  onPressed: _updateSocial,
                ),
                IconButton(
                  tooltip: 'Remover esta rede social',
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.redAccent,
                  ),
                  onPressed:
                      () => ref
                          .read(localResumeProvider.notifier)
                          .removeSocial(widget.index),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
