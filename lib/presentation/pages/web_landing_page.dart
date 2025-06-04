import 'package:flutter/material.dart';
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
          const SizedBox(height: 40),
          Image.asset(
            'images/resume_example.png',
            width: MediaQuery.of(context).size.width * 0.7,
            height: 300,
            fit: BoxFit.contain,
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
