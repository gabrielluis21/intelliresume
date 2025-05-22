import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialLink extends StatelessWidget {
  final String name, url;
  const SocialLink({super.key, required this.name, required this.url});

  Future<void> _launch() async {
    final uri = Uri.tryParse(url);
    if (uri != null && await canLaunchUrl(uri)) launchUrl(uri);
  }

  @override
  Widget build(BuildContext c) {
    return ListTile(
      leading: const Icon(Icons.link),
      title: Text(name),
      subtitle: Text(url),
      onTap: _launch,
    );
  }
}
