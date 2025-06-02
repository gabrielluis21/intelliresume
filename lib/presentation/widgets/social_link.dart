// social_link.dart
import 'package:flutter/material.dart';

class SocialLink extends StatelessWidget {
  final IconData icon;
  final String name;
  final String url;
  final TextTheme textTheme;
  final VoidCallback? onDeleted;

  const SocialLink.text({
    super.key,
    required this.icon,
    required this.name,
    required this.url,
    required this.textTheme,
    this.onDeleted,
  });

  const SocialLink({
    super.key,
    required this.icon,
    required this.name,
    required this.url,
    required this.textTheme,
    required this.onDeleted,
  });

  @override
  Widget build(BuildContext context) {
    if (onDeleted != null) {
      return Chip(
        avatar: Icon(icon, size: 16),
        label: Text(name),
        deleteIcon: const Icon(Icons.close, size: 16),
        onDeleted: onDeleted,
      );
    }
    return Chip(
      avatar: Icon(icon, size: 16),
      label: Text(url, style: textTheme.bodyMedium),
    );
  }
}
