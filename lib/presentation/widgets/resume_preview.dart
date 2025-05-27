// lib/pages/resume_preview_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intelliresume/core/providers/resume_template_provider.dart';
import '../../data/models/resume_template.dart';
import 'header_section.dart';
import 'section.dart';
import 'experience_list.dart';
import 'education_list.dart';
import 'skill_chip.dart';
import 'social_link.dart';
import '../../core/utils/app_localizations.dart';
import '../../core/providers/cv_provider.dart';
import 'package:google_fonts/google_fonts.dart';

class ResumePreview extends ConsumerWidget {
  const ResumePreview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final template = ref.watch(selectedTemplateProvider);

    final textTheme = GoogleFonts.getTextTheme(
      template.fontFamily,
    ).apply(bodyColor: Colors.black, displayColor: Colors.black);

    return Theme(
      data: template.theme.copyWith(textTheme: textTheme),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child:
            template.columns == 2
                ? Row(
                  children: [
                    Expanded(child: _buildSidebar(template)),
                    const VerticalDivider(),
                    Expanded(child: _buildMainContent(template)),
                  ],
                )
                : SingleChildScrollView(child: _buildMainContent(template)),
      ),
    );
  }

  Widget _buildSidebar(ResumeTemplate template) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Contato',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: template.fontSize + 2,
          ),
        ),
        const SizedBox(height: 8),
        Text('email@exemplo.com'),
        Text('Telefone: (00) 0000-0000'),
        const SizedBox(height: 16),
        Text(
          'Habilidades',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: template.fontSize + 2,
          ),
        ),
        Text('- Liderança'),
        Text('- Comunicação'),
        Text('- Gestão de Projetos'),
      ],
    );
  }

  Widget _buildMainContent(ResumeTemplate template) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Nome Completo',
          style: TextStyle(
            fontSize: template.fontSize + 4,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text('Objetivo', style: TextStyle(fontWeight: FontWeight.bold)),
        Text('Profissional com experiência em...'),
        const SizedBox(height: 16),
        Text('Experiência', style: TextStyle(fontWeight: FontWeight.bold)),
        Text('Empresa XYZ - Desenvolvedor Flutter'),
        const SizedBox(height: 16),
        Text('Educação', style: TextStyle(fontWeight: FontWeight.bold)),
        Text('Bacharel em Ciência da Computação - Universidade ABC'),
      ],
    );
  }
}
