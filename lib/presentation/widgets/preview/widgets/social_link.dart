// social_link.dart
import 'package:flutter/material.dart';
import '../../../../data/models/cv_data.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialLink extends StatelessWidget {
  final Social social;
  final TextTheme theme;

  const SocialLink({super.key, required this.social, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      link: true,
      label: 'Abrir perfil em ${social.platform}. Link para ${social.url}',
      child: InkWell(
        onTap: () {
          if (social.url != null && social.url!.isNotEmpty) {
            // Open the URL in a web browser
            launchUrl(
              Uri.parse(social.url!),
              mode: LaunchMode.externalApplication,
            ).catchError((error) {
              // Handle error if the URL cannot be opened
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Could not open URL: ${social.url}')),
              );
              return false;
            });
          }
        },
        child: Chip(
          label: Text(
            social.platform ?? '',
            style: theme.bodyMedium?.copyWith(color: Colors.blue.shade800),
          ),
        ),
      ),
    );
  }
}
