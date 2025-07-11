/* import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intelliresume/routes/app_routes.dart';

class WebLandingPage extends ConsumerStatefulWidget {
  const WebLandingPage({super.key});

  @override
  ConsumerState<WebLandingPage> createState() => _WebLandingPageState();
}

class _WebLandingPageState extends ConsumerState<WebLandingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildHeader(context),
                  _buildHeroSection(context),
                  _buildPricingSection(context),
                  _buildFooter(context),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'IntelliResume',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          ElevatedButton(
            onPressed: () => ref.watch(routerProvider).goNamed('login'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            child: const Text('Entrar'),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.blue.shade50, Colors.white],
        ),
      ),
      child: Column(
        children: [
          Text(
            'Crie currículos inteligentes com IA',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade800,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'Transforme sua carreira com currículos otimizados por inteligência artificial',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: Colors.grey.shade700),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPricingSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 16),
      child: Column(
        children: [
          Text(
            'Planos e Preços',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Escolha o plano ideal para suas necessidades',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 40),
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 900) {
                return _buildMobilePricingCards();
              } else {
                return _buildDesktopPricingCards();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopPricingCards() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPricingCard(
          title: 'Free',
          price: 'Grátis',
          features: const [
            '3 currículos básicos',
            'Modelos limitados',
            'Exportação em PDF',
            'Suporte por email',
          ],
        ),
        const SizedBox(width: 24),
        _buildPricingCard(
          title: 'Premium Mensal',
          price: 'R\$ 19,90/mês',
          features: const [
            'Currículos ilimitados',
            'Todos os modelos premium',
            'Exportação PDF/Word',
            'Análise de IA avançada',
            'Suporte prioritário 24h',
          ],
          isFeatured: true,
        ),
        const SizedBox(width: 24),
        _buildPricingCard(
          title: 'Premium Único',
          price: 'R\$ 199,90',
          features: const [
            'Acesso vitalício',
            'Todos os recursos premium',
            'Atualizações futuras grátis',
            'Domínio personalizado',
            'Suporte dedicado',
          ],
        ),
      ],
    );
  }

  Widget _buildMobilePricingCards() {
    return Column(
      children: [
        _buildPricingCard(
          title: 'Free',
          price: 'Grátis',
          features: const [
            '3 currículos básicos',
            'Modelos limitados',
            'Exportação em PDF',
            'Suporte por email',
          ],
        ),
        const SizedBox(height: 24),
        _buildPricingCard(
          title: 'Premium Mensal',
          price: 'R\$ 19,90/mês',
          features: const [
            'Currículos ilimitados',
            'Todos os modelos premium',
            'Exportação PDF/Word',
            'Análise de IA avançada',
            'Suporte prioritário 24h',
          ],
          isFeatured: true,
        ),
        const SizedBox(height: 24),
        _buildPricingCard(
          title: 'Premium Único',
          price: 'R\$ 199,90',
          features: const [
            'Acesso vitalício',
            'Todos os recursos premium',
            'Atualizações futuras grátis',
            'Domínio personalizado',
            'Suporte dedicado',
          ],
        ),
      ],
    );
  }

  Widget _buildPricingCard({
    required String title,
    required String price,
    required List<String> features,
    bool isFeatured = false,
  }) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: 280,
        maxWidth: 320,
        minHeight: 500,
        maxHeight: 540,
      ),
      child: Card(
        elevation: isFeatured ? 8 : 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            border:
                isFeatured ? Border.all(color: Colors.blue, width: 2) : null,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isFeatured ? Colors.blue : Colors.black,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                price,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 24),
              ...features.map(
                (feature) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          feature,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => ref.watch(routerProvider).goNamed('login'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isFeatured ? Colors.blue : null,
                    foregroundColor: isFeatured ? Colors.white : null,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    isFeatured ? 'Comece agora' : 'Experimente',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      color: Colors.blue.shade50,
      child: Column(
        children: [
          Text(
            'Pronto para transformar seu currículo?',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade800,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => ref.watch(routerProvider).goNamed('login'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 20),
              textStyle: const TextStyle(fontSize: 18),
            ),
            child: const Text('Criar meu currículo agora'),
          ),
          const SizedBox(height: 48),
          const Text(
            '© 2023 IntelliResume. Todos os direitos reservados.',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
 */

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intelliresume/presentation/widgets/ad_banner.dart';
import 'package:intelliresume/routes/app_routes.dart';

class WebLandingPage extends ConsumerStatefulWidget {
  const WebLandingPage({super.key});

  @override
  ConsumerState<WebLandingPage> createState() => _WebLandingPageState();
}

class _WebLandingPageState extends ConsumerState<WebLandingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeader(context),
                  const Divider(height: 1),
                  _buildHeroSection(context),
                  _buildExamplesSection(context),
                  _buildPricingSection(context),
                  const Divider(height: 1),
                  _buildFooter(context),
                  AdBanner(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Semantics(
      label: 'Cabeçalho da página com logo e botão de login',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'IntelliResume',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            ElevatedButton.icon(
              onPressed: () => ref.watch(routerProvider).goNamed('login'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
              icon: const Icon(Icons.login),
              label: const Text('Entrar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Flex(
        direction: isMobile ? Axis.vertical : Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: isMobile ? 0 : 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SelectableText(
                  'Monte seu currículo com inteligência!',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                SelectableText(
                  'Use IA para montar, traduzir e melhorar seu currículo com base no país desejado.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
          const SizedBox(width: 40, height: 40),
          Expanded(
            flex: isMobile ? 0 : 1,
            child: Image.asset(
              'images/logo.png',
              fit: BoxFit.contain,
              height: 120,
              semanticLabel: 'Logo do IntelliResume',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExamplesSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Exemplos de Currículos',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _buildCVExampleCard(
                context,
                title: 'Intelli Resume',
                imagePath: 'images/cv/cv_intelliresume_pattern_mock.png',
                isPremium: false,
              ),
              _buildCVExampleCard(
                context,
                title: 'Modelo Clássico',
                imagePath: 'images/cv/cv_classic_mock.png',
                isPremium: false,
              ),
              _buildCVExampleCard(
                context,
                title: 'Estudante - Primeiro Emprego',
                imagePath: 'images/cv/cv_studant_first_job_mock.png',
                isPremium: false,
              ),
              _buildCVExampleCard(
                context,
                title: 'Modelo Moderno com sidebar',
                imagePath: 'images/cv/cv_modern_with_sidebar_mock.png',
                isPremium: true,
              ),
              _buildCVExampleCard(
                context,
                title: 'Modelo Timeline(Linha do tempo)',
                imagePath: 'images/cv/cv_timeline_mock.png',
                isPremium: true,
              ),
              _buildCVExampleCard(
                context,
                title: 'Infografico',
                imagePath: 'images/cv/cv_infographic_mock.png',
                isPremium: true,
              ),
              _buildCVExampleCard(
                context,
                title: 'Dev Tec',
                imagePath: 'images/cv/cv_dev_tec_mock.png',
                isPremium: true,
              ),
              _buildCVExampleCard(
                context,
                title: 'Internacional',
                imagePath: 'images/cv/cv_internacional_mock.png',
                isPremium: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCVExampleCard(
    BuildContext context, {
    required String title,
    required String imagePath,
    required bool isPremium,
  }) {
    return Semantics(
      label: 'Exemplo de currículo $title',
      child: SizedBox(
        width: 200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    imagePath,
                    height: 260,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    semanticLabel: 'Exemplo visual do currículo $title',
                  ),
                ),
                if (isPremium)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.amber.shade700,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'Premium',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(title, style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
      ),
    );
  }

  Widget _buildPricingSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Text(
            'Planos',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children: [
              _buildPlanCard(
                context,
                title: 'Gratuito',
                description: 'Acesso básico com 3 modelos de currículo.',
                price: 'R\$0,00',
              ),
              _buildPlanCard(
                context,
                title: 'Premium',
                description: 'Acesso a todos os modelos e recursos de IA.',
                price: 'R\$14,90/mês',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCard(
    BuildContext context, {
    required String title,
    required String description,
    required String price,
  }) {
    return Semantics(
      button: true,
      label: 'Plano $title, preço $price',
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          width: 280,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(description),
              const SizedBox(height: 12),
              Text(
                price,
                style: Theme.of(
                  context,
                ).textTheme.headlineSmall?.copyWith(color: Colors.blueAccent),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      color: Colors.blueGrey.shade50,
      child: Center(
        child: Text(
          '© IntelliResume 2025 - Todos os direitos reservados.',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ),
    );
  }
}
