import 'package:flutter/material.dart';
import 'package:intelliresume/generated/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intelliresume/web_app/pages/sections/section_title.dart';

class ContactSection extends StatelessWidget {
  final GlobalKey contactKey;
  static const Color _brandBlue = Color(0xFF0D47A1);

  const ContactSection({super.key, required this.contactKey});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      key: contactKey,
      width: 350,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitle(
            title: l10n.contactSection_title,
            subtitle: l10n.contactSection_description,
            textColor: Theme.of(context).textTheme.headlineSmall?.color,
          ),
          const SizedBox(height: 24),
          ListTile(
            leading: const Icon(Icons.email_outlined, color: _brandBlue),
            title: Text(
              l10n.contactSection_emailLabel,
              semanticsLabel: l10n.contactSection_emailSemanticLabel,
            ),
            subtitle: Text(
              'suporte@intelliresume.com',
              semanticsLabel: 'E-mail de contato: suport@intelliresume.com',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            onTap:
                () => launchUrl(Uri.parse('mailto:suporte@intelliresume.com')),
          ),
          ListTile(
            leading: const Icon(
              Icons.support_agent_outlined,
              color: _brandBlue,
            ),
            title: Text(
              l10n.contactSection_chatSupportLabel,
              semanticsLabel: l10n.contactSection_chatSupportLabel,
            ),
            subtitle: Text(
              l10n.contactSection_chatSupportAvailability,
              semanticsLabel: l10n.contactSection_chatSupportAvailability,
            ),
            onTap: () {
              // Lógica para abrir um chat, ex: Tawk.to, Crisp, etc.
            },
          ),
        ],
      ),
    );
  }
}
