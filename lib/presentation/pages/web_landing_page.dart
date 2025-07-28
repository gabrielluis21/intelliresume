import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intelliresume/core/providers/locale_provider.dart';
import 'package:intelliresume/core/providers/purchase_provider.dart';
import 'package:intelliresume/core/utils/app_localizations.dart';
import 'package:intelliresume/presentation/widgets/ad_banner.dart';
import 'package:url_launcher/url_launcher.dart';

class WebLandingPage extends ConsumerStatefulWidget {
  const WebLandingPage({super.key});

  @override
  ConsumerState<WebLandingPage> createState() => _WebLandingPageState();
}

class _WebLandingPageState extends ConsumerState<WebLandingPage> {
  // Cor primária da marca para consistência visual.
  // Altere este valor para ajustar a cor em todo o site.
  static const Color _brandBlue = Color(0xFF0D47A1);

  // Chave para controlar o Scaffold (abrir o Drawer)
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isPurchasing = false;
  // Nó de foco para gerenciamento de foco via teclado
  final _focusScopeNode = FocusScopeNode();

  // Chaves para rolagem para as seções
  final _aboutKey = GlobalKey();
  final _featuresKey = GlobalKey();
  final _pricingKey = GlobalKey();
  final _contactKey = GlobalKey();

  @override
  void dispose() {
    _focusScopeNode.dispose();
    super.dispose();
  }

  void _scrollToSection(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FocusScope(
      node: _focusScopeNode,
      autofocus: true,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Semantics(
            label: 'Logo IntelliResume',
            child: const Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Intelli',
                    style: TextStyle(color: Colors.black),
                  ),
                  TextSpan(text: 'Resume', style: TextStyle(color: _brandBlue)),
                ],
              ),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.accessibility_new, color: _brandBlue),
              tooltip: 'Opções de Acessibilidade',
              onPressed: () {
                _scaffoldKey.currentState?.openDrawer();
              },
            ),
            const SizedBox(width: 16),
            _buildFocusableButton(
              'Sobre',
              isLink: true,
              () => _scrollToSection(_aboutKey),
            ),
            _buildFocusableButton(
              'Recursos',
              isLink: true,
              () => _scrollToSection(_featuresKey),
            ),
            _buildFocusableButton(
              'Planos',
              isLink: true,
              () => _scrollToSection(_pricingKey),
            ),
            _buildFocusableButton(
              'Contato',
              isLink: true,
              () => _scrollToSection(_contactKey),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: FocusableActionDetector(
                child: Semantics(
                  button: true,
                  label: 'Botão Entrar',
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.login),
                    label: const Text('Entrar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _brandBlue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Divider(height: 1),
                    _buildHeroSection(context),
                    _buildAboutSection(context),
                    _buildFeaturesSection(context),
                    _buildPricingSection(context),
                    _buildContactSection(context),
                    const Divider(height: 1),
                    _buildFooter(context),
                    AdBanner(),
                  ],
                ),
              ),
            );
          },
        ),
        drawer: _buildAccessibilityDrawer(context),
      ),
    );
  }

  Widget _buildFocusableButton(
    String label,
    VoidCallback onPressed, {
    bool isCTA = false,
    bool isLink = false,
  }) {
    return FocusableActionDetector(
      child: Semantics(
        button: true,
        label: 'Botão $label',
        child:
            isLink
                ? TextButton(onPressed: onPressed, child: Text(label))
                : ElevatedButton(
                  onPressed: onPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isCTA ? _brandBlue : Colors.grey.shade100,
                    foregroundColor: isCTA ? Colors.white : Colors.black,
                  ),
                  child: Text(label),
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
                const SizedBox(height: 24),
                Semantics(
                  button: true,
                  label: 'Experimente agora',
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _brandBlue,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Experimente agora'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 40, height: 40),
          Expanded(
            flex: isMobile ? 0 : 1,
            child: Image.asset(
              'images/logo-transparente.png',
              fit: BoxFit.contain,
              height: 250,
              width: 360,
              semanticLabel: 'Logo do IntelliResume',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection(BuildContext context) {
    return Container(
      key: _aboutKey,
      color: _brandBlue.withOpacity(0.05),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sobre o IntelliResume',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          SelectableText(
            'O IntelliResume nasceu da necessidade de simplificar e otimizar a criação de currículos para um mercado de trabalho cada vez mais global e competitivo.\n\nNossa plataforma utiliza Inteligência Artificial para ajudar você a construir um currículo impactante, adaptado para diferentes países e culturas, e traduzido profissionalmente. Queremos que você se destaque e conquiste a vaga dos seus sonhos, onde quer que ela esteja.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5),
            textAlign: TextAlign.start,
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesSection(BuildContext context) {
    return Padding(
      key: _featuresKey,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recursos e Modelos',
            semanticsLabel:
                'Seção com exemplos de currículos disponíveis no aplicativo',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            runAlignment: WrapAlignment.center,
            direction: Axis.horizontal,
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
      explicitChildNodes: true,
      label: 'Exemplo de currículo $title',
      child: FocusableActionDetector(
        child: Container(
          width: 360,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Stack(
                alignment: Alignment.topLeft,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(11),
                    ),
                    child: Image.asset(
                      imagePath,
                      semanticLabel: 'Exemplo visual do currículo $title',
                    ),
                  ),
                  if (isPremium)
                    Container(
                      margin: const EdgeInsets.all(8),
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
                ],
              ),
              const SizedBox(height: 8),
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPricingSection(BuildContext context) {
    return Container(
      key: _pricingKey,
      color: _brandBlue.withOpacity(0.05),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
      child: Column(
        children: [
          Semantics(
            header: true,
            child: Text(
              AppLocalizations.of(context).plansTitle,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 24),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children: [
              _buildPlanCard(
                AppLocalizations.of(context).planFreeTitle,
                'R\$0,00',
                AppLocalizations.of(context).planFreeDetailsShort,
                showButton: false,
              ),
              _buildPlanCard(
                AppLocalizations.of(context).premiumPlan,
                'R\$14,90/mês',
                AppLocalizations.of(context).planPremiumDetailsShort,
                showButton: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCard(
    String title,
    String price,
    String description, {
    required bool showButton,
  }) {
    return Semantics(
      label: 'Plano $title por $price. $description',
      child: FocusableActionDetector(
        child: Container(
          width: 260,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                price,
                style: const TextStyle(fontSize: 18, color: Colors.black87),
              ),
              const SizedBox(height: 8),
              Text(description),
              if (showButton) ...[
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed:
                      _isPurchasing
                          ? null
                          : () => _initiatePurchase(context, ref),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(40),
                  ),
                  child: Text(
                    _isPurchasing ? 'Processando...' : 'Assinar Agora',
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _initiatePurchase(BuildContext context, WidgetRef ref) async {
    setState(() {
      _isPurchasing = true;
    });

    final purchaseController = ref.read(purchaseControllerProvider.notifier);
    final success = await purchaseController.initiatePurchase(
      primaryUrl: 'https://buy.stripe.com/test_abc123456', // URL de produção
      fallbackUrl: 'https://mpago.la/123ABC', // URL de produção
      showFallbackDialog:
          (title, content) => showDialog<bool>(
            context: context,
            builder:
                (ctx) => AlertDialog(
                  title: Text(title),
                  content: Text(content),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: const Text('Não, obrigado'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      child: const Text('Sim, tentar'),
                    ),
                  ],
                ),
          ),
    );

    if (success) {
      // A verificação do status da compra deve ser feita por um backend.
      // Este delay é apenas uma simulação para fins de demonstração.
      await Future.delayed(const Duration(seconds: 5));
      await purchaseController.verifyPurchaseStatus();
      final isPremium = ref.read(purchaseControllerProvider).isPremium;
      if (isPremium && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Plano Premium ativado com sucesso!')),
        );
      }
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível iniciar a compra.')),
      );
    }

    if (mounted) {
      setState(() {
        _isPurchasing = false;
      });
    }
  }

  Widget _buildContactSection(BuildContext context) {
    return Container(
      key: _contactKey,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Contato',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          SelectableText(
            'Tem alguma dúvida, sugestão ou precisa de suporte? Entre em contato conosco!',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),
          ListTile(
            leading: const Icon(Icons.email_outlined, color: _brandBlue),
            title: const Text('E-mail'),
            subtitle: const SelectableText('suporte@intelliresume.com'),
            onTap:
                () => launchUrl(Uri.parse('mailto:suporte@intelliresume.com')),
          ),
          ListTile(
            leading: Icon(Icons.support_agent_outlined, color: _brandBlue),
            title: const Text('Suporte via Chat'),
            subtitle: const Text('Disponível de Seg. a Sex. das 9h às 18h'),
            onTap: () {
              // Lógica para abrir um chat, ex: Tawk.to, Crisp, etc.
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      color: Colors.blueGrey.shade50,
      child: Center(
        child: Semantics(
          hint:
              "Copy Right - © IntelliResume 2025 - Todos os direitos reservados.",
          child: Text(
            '© IntelliResume 2025 - Todos os direitos reservados.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ),
    );
  }

  Widget _buildAccessibilityDrawer(BuildContext context) {
    // Ouve o provider para saber qual o idioma atual e reconstruir o widget se mudar.
    final currentLocale = ref.watch(localeProvider);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: _brandBlue),
            child: Text(
              'Acessibilidade',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.sign_language, color: _brandBlue),
            title: const Text('Versão em Libras (VLibras)'),
            onTap: () {
              Navigator.pop(context); // Fecha o drawer
              launchUrl(Uri.parse('assets/landing_page_vlibras.html'));
            },
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              'Idioma do Site',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
          ),
          RadioListTile<Locale>(
            title: const Text('Português (Brasil)'),
            value: const Locale('pt'),
            groupValue: currentLocale,
            onChanged: (Locale? value) {
              if (value != null) {
                // Atualiza o estado do provider com o novo idioma
                ref.read(localeProvider.notifier).state = value;
                Navigator.pop(context); // Fecha o drawer
              }
            },
          ),
          RadioListTile<Locale>(
            title: const Text('English'),
            value: const Locale('en'),
            groupValue: currentLocale,
            onChanged: (Locale? value) {
              if (value != null) {
                ref.read(localeProvider.notifier).state = const Locale('en');

                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }
}
