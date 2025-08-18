import 'package:flutter/material.dart';
import 'package:intelliresume/web_app/widgets/clickable_feature_card.dart';
import 'package:intelliresume/web_app/widgets/feature_card.dart';

class FeaturesSection extends StatelessWidget {
  final GlobalKey featuresKey;
  final VoidCallback onSeeTemplates;

  const FeaturesSection({
    super.key,
    required this.featuresKey,
    required this.onSeeTemplates,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      key: featuresKey,
      color: Colors.grey[50], // Um fundo suave para diferenciar a seção
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
      child: Column(
        children: [
          Text(
            'Funcionalidades Inteligentes',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0D47A1),
                ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Tudo o que você precisa para criar um currículo de destaque em minutos.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: Colors.black54),
          ),
          const SizedBox(height: 40),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200), // Limita a largura do grid
              child: Wrap(
                spacing: 24,
                runSpacing: 24,
                alignment: WrapAlignment.center,
                children: [
                  const SizedBox(
                    width: 280,
                    child: FeatureCard(
                      icon: Icons.auto_awesome,
                      title: 'Avaliação com IA',
                      description: 'Receba sugestões para tornar seu currículo mais impactante e profissional.',
                    ),
                  ),
                  const SizedBox(
                    width: 280,
                    child: FeatureCard(
                      icon: Icons.translate,
                      title: 'Tradução Automática',
                      description: 'Adapte seu currículo para vagas internacionais com tradução para múltiplos idiomas.',
                    ),
                  ),
                  const SizedBox(
                    width: 280,
                    child: FeatureCard(
                      icon: Icons.spellcheck,
                      title: 'Correção Ortográfica',
                      description: 'Evite erros gramaticais que podem custar uma oportunidade. Nós revisamos para você.',
                    ),
                  ),
                  SizedBox(
                    width: 280,
                    child: ClickableFeatureCard(
                      onTap: onSeeTemplates,
                      icon: Icons.palette,
                      title: 'Modelos Profissionais',
                      description: 'Escolha entre dezenas de modelos gratuitos e premium, criados por especialistas.',
                    ),
                  ),
                  const SizedBox(
                    width: 280,
                    child: FeatureCard(
                      icon: Icons.edit,
                      title: 'Modo Estúdio (Pro)',
                      description: 'Personalize cores, fontes e layouts para criar um currículo verdadeiramente único.',
                    ),
                  ),
                  const SizedBox(
                    width: 280,
                    child: FeatureCard(
                      icon: Icons.picture_as_pdf,
                      title: 'Exportação Fácil',
                      description: 'Exporte seu currículo em formato PDF com alta qualidade, pronto para ser enviado.',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
