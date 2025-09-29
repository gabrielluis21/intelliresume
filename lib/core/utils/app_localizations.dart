import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// Classe para gerenciar as strings de localização (i18n)
class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  // Método estático para facilitar o acesso ao AppLocalizations a partir do context
  static AppLocalizations of(BuildContext context) =>
      Localizations.of<AppLocalizations>(context, AppLocalizations)!;

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static List<Locale> get supportedLocales => [
    const Locale('en'),
    const Locale('pt'),
  ];

  static List<LocalizationsDelegate<dynamic>> get localizationsDelegates => [
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  // Mapa de strings traduzidas
  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'appTitle': 'IntelliResume',
      'plansTitle': 'Plans and Prices',
      'planFreeTitle': 'Free',
      'planFreeDetailsShort': 'Create your resume with basic templates.',
      'premiumPlan': 'Premium',
      'planPremiumDetailsShort': 'Access premium templates and AI features.',
      'contactTitle': 'Contact',
      'contactSubtitle':
          'Have questions, suggestions, or need support? Get in touch!',
      'emailLabel': 'Email',
      'chatSupportLabel': 'Chat Support',
      'chatSupportAvailability': 'Available Mon-Fri, 9am to 6pm',
      'noExperience': 'No Experience',
      'noObjectives': 'No Objectives',
      'noSkill': 'No Skills',
      'noSocialLink': 'No Social Links',
      'noEducations': 'No Educations',
      'socialLinks': 'Social Links',
      'experiences': 'Experiences',
      'educations': 'Educations',
      'skills': 'Skills',
      'objective': 'Objective',
      'certificates': 'Certificates',
      'projects': 'Projects',
      'passwordsDontMatch': 'Passwords do not match.',
      'fieldRequired': 'This field is required.',
      'invalidEmail': 'Invalid email address.',
      'passwordTooShort': 'Password must be at least 6 characters long.',
      'signup': 'Sign Up',
      'login': 'Sign In',
      'signOut': 'Sign Out',
      'email': 'E-mail',
      'password': 'Password',
      'confirmPass': 'Confirm Password',
      'noHistory': 'No History',
      'history': 'History',
      'formTitle': 'Fill the form',
      'forgetPassword': 'Forgot Password?',
      'save': 'Save',
      'cancel': 'Cancel',
      'aboutIntelliTitle': 'About IntelliResume',
      'aboutIntelliDescription':
          'IntelliResume was born from the need to simplify and optimize resume creation for an increasingly global and competitive job market.\n\nOur platform uses Artificial Intelligence to help you build an impactful resume, adapted to different countries and cultures, and professionally translated. We want you to stand out and land your dream job, wherever it may be.',
    },
    'pt': {
      'appTitle': 'IntelliResume',
      'plansTitle': 'Planos e Preços',
      'planFreeTitle': 'Gratuito',
      'planFreeDetailsShort': 'Crie seu currículo com modelos básicos.',
      'premiumPlan': 'Premium',
      'planPremiumDetailsShort': 'Acesse modelos premium e recursos de IA.',
      'contactTitle': 'Contato',
      'contactSubtitle':
          'Tem alguma dúvida, sugestão ou precisa de suporte? Entre em contato conosco!',
      'emailLabel': 'E-mail',
      'chatSupportLabel': 'Suporte via Chat',
      'chatSupportAvailability': 'Disponível de Seg. a Sex. das 9h às 18h',
      'noExperience': 'Nenhuma Experiência',
      'noObjectives': 'Nenhum Objetivo',
      'noSkill': 'Nenhuma Habilidade',
      'noSocialLink': 'Nenhum Link Social',
      'noEducations': 'Nenhuma Educação',
      'socialLinks': 'Links Sociais',
      'experiences': 'Experiências',
      'educations': 'Educações',
      'skills': 'Habilidades',
      'objective': 'Objetivo',
      'certificates': 'Certificados',
      'projects': 'Projetos',
      'passwordsDontMatch': 'As senhas não coincidem.',
      'fieldRequired': 'Este campo é obrigatório.',
      'invalidEmail': 'Endereço de e-mail inválido.',
      'passwordTooShort': 'A senha deve ter no mínimo 6 caracteres.',
      'signup': 'Cadastre-se',
      'login': 'Entrar',
      'signOut': 'Sair',
      'email': 'E-mail',
      'password': 'Senha',
      'confirmPass': 'Confirmar Senha',
      'noHistory': 'Sem Histórico',
      'history': 'Histórico',
      'formTitle': 'Preencha o formulário',
      'save': 'Salvar',
      'cancel': 'Cancelar',
      'forgetPassword': 'Esqueci minha senha',
      'aboutIntelliTitle': 'Sobre o IntelliResume',
      'aboutIntelliDescription':
          'O IntelliResume nasceu da necessidade de simplificar e otimizar a criação de currículos para um mercado de trabalho cada vez mais global e competitivo.\n\nNossa plataforma utiliza Inteligência Artificial para ajudar você a construir um currículo impactante, adaptado para diferentes países e culturas, e traduzido profissionalmente. Queremos que você se destaque e conquiste a vaga dos seus sonhos, onde quer que ela esteja.',
      'accessibilityInfo': 'Informações de Acessibilidade',
      'preview': 'Visualizar',
      'aiAssistant': 'Assistente de IA',
    },
  };

  // Getters para cada string, baseados no locale atual
  String get appTitle => _localizedValues[locale.languageCode]!['appTitle']!;
  String get plansTitle =>
      _localizedValues[locale.languageCode]!['plansTitle']!;
  String get planFreeTitle =>
      _localizedValues[locale.languageCode]!['planFreeTitle']!;
  String get planFreeDetailsShort =>
      _localizedValues[locale.languageCode]!['planFreeDetailsShort']!;
  String get premiumPlan =>
      _localizedValues[locale.languageCode]!['premiumPlan']!;
  String get planPremiumDetailsShort =>
      _localizedValues[locale.languageCode]!['planPremiumDetailsShort']!;
  String get contactTitle =>
      _localizedValues[locale.languageCode]!['contactTitle']!;
  String get contactSubtitle =>
      _localizedValues[locale.languageCode]!['contactSubtitle']!;
  String get emailLabel =>
      _localizedValues[locale.languageCode]!['emailLabel']!;
  String get chatSupportLabel =>
      _localizedValues[locale.languageCode]!['chatSupportLabel']!;
  String get chatSupportAvailability =>
      _localizedValues[locale.languageCode]!['chatSupportAvailability']!;
  String get noExperience =>
      _localizedValues[locale.languageCode]!['noExperience']!;
  String get noObjectives =>
      _localizedValues[locale.languageCode]!['noObjectives']!;
  String get noSkill => _localizedValues[locale.languageCode]!['noSkill']!;
  String get noSocialLink =>
      _localizedValues[locale.languageCode]!['noSocialLink']!;
  String get noEducations =>
      _localizedValues[locale.languageCode]!['noEducations']!;
  String get socialLinks =>
      _localizedValues[locale.languageCode]!['socialLinks']!;
  String get experiences =>
      _localizedValues[locale.languageCode]!['experiences']!;
  String get educations =>
      _localizedValues[locale.languageCode]!['educations']!;
  String get skills => _localizedValues[locale.languageCode]!['skills']!;
  String get objective => _localizedValues[locale.languageCode]!['objective']!;
  String get certificates =>
      _localizedValues[locale.languageCode]!['certificates']!;
  String get projects => _localizedValues[locale.languageCode]!['projects']!;
  String get passwordsDontMatch =>
      _localizedValues[locale.languageCode]!['passwordsDontMatch']!;
  String get fieldRequired =>
      _localizedValues[locale.languageCode]!['fieldRequired']!;
  String get invalidEmail =>
      _localizedValues[locale.languageCode]!['invalidEmail']!;
  String get passwordTooShort =>
      _localizedValues[locale.languageCode]!['passwordTooShort']!;
  String get signup => _localizedValues[locale.languageCode]!['signup']!;
  String get login => _localizedValues[locale.languageCode]!['login']!;
  String get signOut => _localizedValues[locale.languageCode]!['signOut']!;
  String get email => _localizedValues[locale.languageCode]!['email']!;
  String get password => _localizedValues[locale.languageCode]!['password']!;
  String get confirmPassword =>
      _localizedValues[locale.languageCode]!['confirmPass']!;
  String get noHistory => _localizedValues[locale.languageCode]!['noHistory']!;
  String get history => _localizedValues[locale.languageCode]!['history']!;
  String get formTitle => _localizedValues[locale.languageCode]!['formTitle']!;
  String get save => _localizedValues[locale.languageCode]!['save']!;
  String get cancel => _localizedValues[locale.languageCode]!['cancel']!;
  String get aboutIntelliTitle =>
      _localizedValues[locale.languageCode]!['aboutIntelliTitle']!;
  String get aboutIntelliDescription =>
      _localizedValues[locale.languageCode]!['aboutIntelliDescription']!;
  String get accessibilityInfo =>
      _localizedValues[locale.languageCode]!['accessibilityInfo']!;
  String get forgotPassword =>
      _localizedValues[locale.languageCode]!['forgetPassword']!;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'pt'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
