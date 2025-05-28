import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialLink extends StatelessWidget {
  final String name, url;
  final IconData icon;
  final TextTheme textTheme;
  const SocialLink({
    super.key,
    required this.icon,
    required this.name,
    required this.url,
    required this.textTheme,
  });

  Future<void> _launch() async {
    final uri = Uri.tryParse(url);
    if (uri != null && await canLaunchUrl(uri)) launchUrl(uri);
  }

  @override
  Widget build(BuildContext c) {
    return ListTile(
      leading: Icon(icon),
      title: Text(name, style: textTheme.bodyLarge),
      subtitle: Text(url, style: textTheme.bodyMedium),
      onTap: _launch,
    );
  }
}
