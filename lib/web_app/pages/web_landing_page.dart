import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intelliresume/core/providers/accessibility/accessibility_provider.dart';
import 'package:intelliresume/core/providers/languages/locale_provider.dart';
import 'package:intelliresume/generated/app_localizations.dart';
import 'package:intelliresume/presentation/widgets/ad_banner.dart';
import 'package:intelliresume/web_app/pages/sections/about_section.dart';
import 'package:intelliresume/web_app/pages/sections/contact_section.dart';
import 'package:intelliresume/web_app/pages/sections/features_section.dart';
import 'package:intelliresume/web_app/pages/sections/footer_section.dart';
import 'package:intelliresume/web_app/pages/sections/hero_section.dart';
import 'package:intelliresume/presentation/widgets/pricing/pricing_section_widget.dart';
import 'package:intelliresume/web_app/pages/sections/template_gallery_section.dart';
import 'package:intelliresume/web_app/pages/sections/demo_section.dart';
import 'package:intelliresume/web_app/pages/sections/testimonials_section.dart';
import 'package:intelliresume/web_app/pages/sections/cta_section.dart';
import 'package:url_launcher/url_launcher.dart';

class WebLandingPage extends ConsumerStatefulWidget {
  const WebLandingPage({super.key});

  @override
  ConsumerState<WebLandingPage> createState() => _WebLandingPageState();
}

class _WebLandingPageState extends ConsumerState<WebLandingPage> {
  static const Color _brandBlue = Color(0xFF0D47A1);
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _focusScopeNode = FocusScopeNode();

  final _aboutKey = GlobalKey();
  final _featuresKey = GlobalKey();
  final _pricingKey = GlobalKey();
  final _contactKey = GlobalKey();
  final _galleryKey = GlobalKey(); // Chave para a galeria

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
    final l10n = AppLocalizations.of(context)!;
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
            label: l10n.webLandingPage_logoSemanticLabel,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Intelli',
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(color: Colors.black),
                  ),
                  TextSpan(
                    text: 'Resume',
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(color: _brandBlue),
                  ),
                ],
              ),
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          actions: [
            Semantics(
              label: l10n.webLandingPage_openAccessibilityMenuSemanticLabel,
              button: true,
              child: IconButton(
                icon: const Icon(Icons.accessibility_new, color: _brandBlue),
                tooltip: l10n.webLandingPage_accessibilityTooltip,
                onPressed: () {
                  _scaffoldKey.currentState?.openDrawer();
                },
              ),
            ),
            const SizedBox(width: 16),
            _buildFocusableButton(
              l10n.webLandingPage_aboutButton,
              isLink: true,
              () => _scrollToSection(_aboutKey),
            ),
            _buildFocusableButton(
              l10n.webLandingPage_featuresButton,
              isLink: true,
              () => _scrollToSection(_featuresKey),
            ),
            _buildFocusableButton(
              l10n.webLandingPage_plansButton,
              isLink: true,
              () => _scrollToSection(_pricingKey),
            ),
            _buildFocusableButton(
              l10n.webLandingPage_contactButton,
              isLink: true,
              () => _scrollToSection(_contactKey),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: FocusableActionDetector(
                child: Semantics(
                  button: true,
                  label: l10n.webLandingPage_loginButtonSemanticLabel,
                  child: ElevatedButton.icon(
                    onPressed: () => context.goNamed('login'),
                    icon: const Icon(Icons.login),
                    label: Text(l10n.webLandingPage_loginButton),
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
                    HeroSection(
                      onCTAPressed: () => _scrollToSection(_pricingKey),
                    ),
                    AboutSection(aboutKey: _aboutKey),
                    FeaturesSection(
                      featuresKey: _featuresKey,
                      onSeeTemplates: () => _scrollToSection(_galleryKey),
                    ),
                    //const DemoSection(),
                    PricingSectionWidget(
                      buttonText: l10n.webLandingPage_signUpAndBuyButton,
                      onSelectPlan: (_) => context.go('/signup'),
                    ),
                    TemplateGallerySection(galleryKey: _galleryKey),
                    const TestimonialsSection(),
                    ContactSection(contactKey: _contactKey),
                    //const CtaSection(),
                    const Divider(height: 1),
                    const FooterSection(),
                    const AdBanner(),
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
    final l10n = AppLocalizations.of(context)!;
    return FocusableActionDetector(
      child: Semantics(
        button: true,
        label: l10n.webLandingPage_scrollToSectionSemanticLabel(label),
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

  Widget _buildAccessibilityDrawer(BuildContext context) {
    final settings = ref.watch(accessibilityProvider);
    final notifier = ref.read(accessibilityProvider.notifier);
    final currentLocale = ref.watch(localeProvider);
    final l10n = AppLocalizations.of(context)!;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: _brandBlue),
            child: Text(
              l10n.webLandingPage_accessibilityDrawerTitle,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(color: Colors.white),
            ),
          ),
          _DrawerSectionTitle(
            title: l10n.webLandingPage_visualAdjustmentsTitle,
          ),
          SwitchListTile(
            title: Text(l10n.webLandingPage_highContrast),
            value: settings.highContrast,
            onChanged: (bool value) => notifier.toggleHighContrast(value),
            secondary: const Icon(Icons.contrast, color: _brandBlue),
          ),
          SwitchListTile(
            title: Text(l10n.webLandingPage_boldText),
            value: settings.boldText,
            onChanged: (bool value) => notifier.toggleBoldText(value),
            secondary: const Icon(Icons.format_bold, color: _brandBlue),
          ),
          ListTile(
            leading: const Icon(Icons.format_size, color: _brandBlue),
            title: Text(l10n.webLandingPage_fontSize),
            subtitle: Text(
              l10n.webLandingPage_fontScale(
                settings.fontScale.toStringAsFixed(1),
              ),
            ),
          ),
          Slider(
            value: settings.fontScale,
            min: 0.8,
            max: 2.0,
            divisions: 12,
            label: settings.fontScale.toStringAsFixed(1),
            onChanged: (double value) => notifier.setFontScale(value),
          ),
          const Divider(),
          _DrawerSectionTitle(
            title: l10n.webLandingPage_languageAndRegionTitle,
          ),
          RadioListTile<Locale>(
            title: Text(l10n.webLandingPage_portuguese),
            value: const Locale('pt'),
            groupValue: currentLocale,
            onChanged: (Locale? value) {
              if (value != null) {
                ref.read(localeProvider.notifier).state = value;
              }
            },
          ),
          RadioListTile<Locale>(
            title: Text(l10n.webLandingPage_english),
            value: const Locale('en'),
            groupValue: currentLocale,
            onChanged: (Locale? value) {
              if (value != null) {
                ref.read(localeProvider.notifier).state = value;
              }
            },
          ),
          const Divider(),
          _DrawerSectionTitle(
            title: l10n.webLandingPage_additionalFeaturesTitle,
          ),
          ListTile(
            leading: const Icon(Icons.sign_language, color: _brandBlue),
            title: Text(l10n.webLandingPage_librasVersion),
            onTap: () {
              Navigator.pop(context);
              launchUrl(Uri.parse('assets/landing_page_vlibras.html'));
            },
          ),
        ],
      ),
    );
  }
}

class _DrawerSectionTitle extends StatelessWidget {
  final String title;
  const _DrawerSectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: _WebLandingPageState._brandBlue.withOpacity(0.8),
          letterSpacing: 1.1,
        ),
      ),
    );
  }
}
