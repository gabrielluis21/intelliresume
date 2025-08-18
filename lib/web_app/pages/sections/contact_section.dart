import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactSection extends StatelessWidget {
  final GlobalKey contactKey;
  static const Color _brandBlue = Color(0xFF0D47A1);

  const ContactSection({super.key, required this.contactKey});

  @override
  Widget build(BuildContext context) {
    return Container(
      key: contactKey,
      width: 350,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Contato',
            semanticsLabel: 'Seção de contato',
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Text(
            'Tem alguma dúvida, sugestão ou precisa de suporte? Entre em contato conosco!',
            semanticsLabel:
                'Tem alguma dúvida, sugestão ou precisa de suporte? Entre em contato conosco!',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),
          ListTile(
            leading: const Icon(Icons.email_outlined, color: _brandBlue),
            title: const Text('E-mail', semanticsLabel: 'E-mail de contato'),
            subtitle: const Text(
              'suporte@intelliresume.com',
              semanticsLabel: 'E-mail de contato: suport@intelliresume.com',
            ),
            onTap: () =>
                launchUrl(Uri.parse('mailto:suporte@intelliresume.com')),
          ),
          ListTile(
            leading: const Icon(Icons.support_agent_outlined, color: _brandBlue),
            title: const Text(
              'Suporte via Chat',
              semanticsLabel: 'Suporte via Chat',
            ),
            subtitle: const Text(
              'Disponível de Seg. a Sex. das 9h às 18h',
              semanticsLabel: 'Disponível de Seg. a Sex. das 9h às 18h',
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
