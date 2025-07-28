// lib/core/utils/app_localizations.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class AppLocalizations {
  final Locale locale;
  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) =>
      Localizations.of<AppLocalizations>(context, AppLocalizations)!;

  // Chave‐valor de todas as strings
  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'appTitle': 'IntelliResume',
      'appSubtitle': 'Create your resume in seconds',
      'homeTitle': 'Home',
      'homeWelcomeMessage': 'Welcome to IntelliResume',
      'login': 'Login',
      'signup': 'Sign Up',
      'email': 'Email',
      'password': 'Password',
      'confirmPassword': 'Confirm Password',
      'logout': 'Logout',
      'profile': 'Profile',
      'forgotPassword': 'Forgot Password?',
      'save': 'Save',
      'history': 'History',
      'settings': 'Settings',
      'delete': 'Delete',
      'deleteConfirm': 'Are you sure you want to delete this item?',
      'deleteSuccess': 'Item deleted successfully',
      'noHistory': 'No history available',
      'noHistoryDesc': 'You have not created any resumes yet.',
      'resumePreview': 'Resume Preview',
      'resumeForm': 'Resume Form',
      'previewPdf': 'Preview PDF',
      'exportDocx': 'Export DOCX',
      'aboutMe': 'About me',
      'experiences': 'Experiences',
      'company': 'Company',
      'job': 'Job Title',
      'institution': 'Institution',
      'degree': 'Degree',
      'startDate': 'Start Date',
      'endDate': 'End Date',
      'passwordsDontMatch': "Passwords don't match",
      'invalidEmail': 'Invalid email',
      'passwordTooShort': 'Password must be at least 6 characters',
      'educations': 'Educations',
      'skills': 'Skills',
      'socialLinks': 'Social Links',
      'add': 'Add',
      'fieldRequired': 'This field is required',
      'freePlan': 'Free Plan',
      'freePlanDesc': 'Limited IA, 5 exports/day, ads',
      'premiumDesc': 'Unlimited IA & exports, no ads',
      'current': 'Current',
      'upgrade': 'Upgrade',
      'payment': 'Checkout',
      'premiumSuccess': 'You are now Premium!',
      'paymentSuccess': 'Payment successful!',
      'paymentError': 'Payment failed, try again.',
      'socialName': 'Social Network',
      'socialUrl': 'Social Link',
      'objective': 'Objective',
      'contactInfo': 'Contact',
      'accessibleVersionTitle': 'Accessible Version - IntelliResume',
      'accessibleVersionInfo':
          'This is the accessible version of the site for use with the VLibras plugin.',
      'noObjectives': 'No objective defined',
      'noSocialLinks': 'No social links added',
      'noSkills': 'No skills added',
      'noExperiences': 'No experiences added',
      'noEducations': 'No educations added',
      'noProjects': 'No projects added',
      'landingPageHeadline': 'Build your resume with intelligence!',
      'landingPageSubhead':
          'Use artificial intelligence to build, translate, and improve your resume based on the desired country.',
      'templatesTitle': 'Resume Templates',
      'templateStudent': 'Template 1: Student',
      'templateDeveloper': 'Template 2: Developer',
      'templateEuropass': 'Template 3: International Europass',
      'plansTitle': 'Available Plans',
      'planPro': 'Pro',
      'planFreeDetails':
          'Free: 5 resumes, 3 AI interactions per day, basic templates.',
      'planPremiumDetails':
          'Premium: Unlimited resumes and AI, all premium templates.',
      'planProDetails':
          'Everything from Premium + Studio Mode for advanced template editing.',
      'accessibilityOptionsTooltip': 'Accessibility Options',
      'navAbout': 'About',
      'navFeatures': 'Features',
      'navPlans': 'Plans',
      'navContact': 'Contact',
      'tryNow': 'Try Now',
      'logoSemanticLabel': 'IntelliResume Logo',
      'aboutTitle': 'About IntelliResume',
      'aboutText':
          'IntelliResume was born from the need to simplify and optimize resume creation for an increasingly global and competitive job market.\n\nOur platform uses Artificial Intelligence to help you build an impactful resume, adapted for different countries and cultures, and professionally translated. We want you to stand out and win your dream job, wherever it may be.',
      'featuresTitle': 'Features and Templates',
      'featuresSectionSemanticLabel':
          'Section with examples of resumes available in the application',
      'templateIntelliResume': 'Intelli Resume',
      'templateClassic': 'Classic Model',
      'templateStudentFirstJob': 'Student - First Job',
      'templateModernSidebar': 'Modern Model with sidebar',
      'templateTimeline': 'Timeline Model',
      'templateInfographic': 'Infographic',
      'templateDevTec': 'Dev Tec',
      'templateInternational': 'International',
      'planFreeTitle': 'Free',
      'planFreeDetailsShort': 'Basic access with 3 resume templates.',
      'planPremiumDetailsShort': 'Access to all templates and AI features.',
      'premiumPlan': 'Premium',
      'processing': 'Processing...',
      'subscribeNow': 'Subscribe Now',
      'premiumPlanActivated': 'Premium plan activated successfully!',
      'purchaseCouldNotStart': 'Could not initiate purchase.',
      'noThanks': 'No, thanks',
      'yesTry': 'Yes, try',
      'contactIntro':
          'Have any questions, suggestions, or need support? Get in touch with us!',
      'chatSupport': 'Chat Support',
      'chatSupportHours': 'Available Mon to Fri from 9am to 6pm',
      'footerCopyright': '© IntelliResume 2025 - All rights reserved.',
      'accessibility': 'Accessibility',
      'vLibrasVersion': 'Version in Libras (VLibras)',
      'siteLanguage': 'Site Language',
      'langPortuguese': 'Português (Brasil)',
      'langEnglish': 'English',
    },
    'pt': {
      'company': 'Empresa',
      'job': 'Cargo',
      'institution': 'Instituição',
      'startDate': 'Data de Início',
      'endDate': 'Data de Término',
      'noObjectives': 'Nenhum objetivo definido',
      "passwordsDontMatch": "As senhas não coincidem",
      "invalidEmail": "Email inválido",
      "passwordTooShort": "Senha deve ter pelo menos 6 caracteres",
      'appTitle': 'IntelliResume',
      'homeTitle': 'Início',
      'homeWelcomeMessage': 'Bem-vindo ao IntelliResume',
      'login': 'Login',
      'signup': 'Cadastrar',
      'email': 'Email',
      'password': 'Senha',
      'confirmPassword': 'Confirmar Senha',
      'logout': 'Sair',
      'appSubtitle': 'Crie seu currículo em segundos',
      'history': 'Histórico',
      'settings': 'Configurações',
      'delete': 'Excluir',
      'deleteConfirm': 'Tem certeza que deseja excluir este item?',
      'deleteSuccess': 'Item excluído com sucesso',
      'noHistory': 'Nenhum histórico',
      'noHistoryDesc': 'Você ainda não criou nenhum currículo.',
      'resumeForm': 'Formulário de Currículo',
      'resumePreview': 'Visualizar Currículo',
      'profile': 'Perfil',
      'forgotPassword': 'Esqueceu a senha?',
      'save': 'Salvar',
      'previewPdf': 'Visualizar PDF',
      'exportDocx': 'Exportar DOCX',
      'aboutMe': 'Sobre mim',
      'experiences': 'Experiências',
      'educations': 'Formações',
      'degree': 'Grau',
      'skills': 'Habilidades',
      'socialLinks': 'Redes Sociais',
      'add': 'Adicionar',
      'fieldRequired': 'Campo obrigatório',
      'freePlan': 'Plano Grátis',
      'freePlanDesc': 'IA limitada, 5 exportações/dia, anúncios',
      'premiumPlan': 'Plano Premium',
      'premiumDesc': 'IA ilimitada, sem anúncios',
      'current': 'Atual',
      'upgrade': 'Assinar',
      'payment': 'Pagamento',
      'premiumSuccess': 'Você agora é Premium!',
      'paymentSuccess': 'Pagamento realizado com sucesso!',
      'paymentError': 'Pagamento falhou, tente novamente.',
      'socialName': 'Rede Social',
      'socialUrl': 'Link da Rede Social',
      'objective': 'Objetivo',
      'contactInfo': 'Contato',
      'noSocialLinks': 'Nenhum link social adicionado',
      'noSkills': 'Nenhuma habilidade adicionada',
      'noExperiences': 'Nenhuma experiência adicionada',
      'noEducations': 'Nenhuma formação adicionada',
      'noProjects': 'Nenhum projeto adicionado',
      'accessibleVersionTitle': 'Versão Acessível - IntelliResume',
      'accessibleVersionInfo':
          'Esta é a versão acessível do site para uso com o plugin VLibras.',
      'landingPageHeadline': 'Monte seu currículo com inteligência!',
      'landingPageSubhead':
          'Use inteligência artificial para montar, traduzir e melhorar seu currículo com base no país desejado.',
      'templatesTitle': 'Modelos de Currículos',
      'templateStudent': 'Modelo 1: Estudante',
      'templateDeveloper': 'Modelo 2: Desenvolvedor',
      'templateEuropass': 'Modelo 3: Europass Internacional',
      'plansTitle': 'Planos Disponíveis',
      'planPro': 'Pro',
      'planFreeDetails':
          'Free: 5 currículos, 3 interações com IA por dia, modelos básicos.',
      'planPremiumDetails':
          'Premium: Currículos e IA ilimitados, todos os modelos premium.',
      'planProDetails':
          'Tudo do Premium + Modo Estúdio para edição avançada dos modelos.',
      'login': 'Entrar',
      'plansTitle': 'Planos Disponíveis',
      'accessibilityOptionsTooltip': 'Opções de Acessibilidade',
      'navAbout': 'Sobre',
      'navFeatures': 'Recursos',
      'navPlans': 'Planos',
      'navContact': 'Contato',
      'tryNow': 'Experimente agora',
      'logoSemanticLabel': 'Logo do IntelliResume',
      'aboutTitle': 'Sobre o IntelliResume',
      'resumePreview': 'Prévia do Currículo',
      'aboutText':
          'O IntelliResume nasceu da necessidade de simplificar e otimizar a criação de currículos para um mercado de trabalho cada vez mais global e competitivo.\n\nNossa plataforma utiliza Inteligência Artificial para ajudar você a construir um currículo impactante, adaptado para diferentes países e culturas, e traduzido profissionalmente. Queremos que você se destaque e conquiste a vaga dos seus sonhos, onde quer que ela esteja.',
      'featuresTitle': 'Recursos e Modelos',
      'featuresSectionSemanticLabel':
          'Seção com exemplos de currículos disponíveis no aplicativo',
      'templateIntelliResume': 'Intelli Resume',
      'templateClassic': 'Modelo Clássico',
      'templateStudentFirstJob': 'Estudante - Primeiro Emprego',
      'templateModernSidebar': 'Modelo Moderno com sidebar',
      'templateTimeline': 'Modelo Timeline(Linha do tempo)',
      'templateInfographic': 'Infográfico',
      'templateDevTec': 'Dev Tec',
      'templateInternational': 'Internacional',
      'tagPremium': 'Premium',
      'planFreeTitle': 'Gratuito',
      'planFreeDetailsShort': 'Acesso básico com 3 modelos de currículo.',
      'planPremiumDetailsShort': 'Acesso a todos os modelos e recursos de IA.',
      'premiumPlan': 'Premium',
      'processing': 'Processando...',
      'subscribeNow': 'Assinar Agora',
      'premiumPlanActivated': 'Plano Premium ativado com sucesso!',
      'purchaseCouldNotStart': 'Não foi possível iniciar a compra.',
      'noThanks': 'Não, obrigado',
      'yesTry': 'Sim, tentar',
      'contactIntro':
          'Tem alguma dúvida, sugestão ou precisa de suporte? Entre em contato conosco!',
      'chatSupport': 'Suporte via Chat',
      'chatSupportHours': 'Disponível de Seg. a Sex. das 9h às 18h',
      'footerCopyright': '© IntelliResume 2025 - Todos os direitos reservados.',
      'accessibility': 'Acessibilidade',
      'vLibrasVersion': 'Versão em Libras (VLibras)',
      'siteLanguage': 'Idioma do Site',
      'langPortuguese': 'Português (Brasil)',
      'langEnglish': 'English',
    },
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ??
        _localizedValues['en']![key] ??
        key;
  }

  // Helpers para uso mais conveniente:
  String get appTitle => translate('appTitle');
  String get company => translate('company');
  String get job => translate('job');
  String get degree => translate('degree');
  String get institution => translate('institution');
  String get startDate => translate('startDate');
  String get endDate => translate('endDate');
  String get homeTitle => translate('homeTitle');
  String get homeWelcomeMessage => translate('homeWelcomeMessage');
  String get appSubtitle => translate('appSubtitle');
  String get login => translate('login');
  String get signup => translate('signup');
  String get email => translate('email');
  String get password => translate('password');
  String get confirmPassword => translate('confirmPassword');
  String get logout => translate('logout');
  String get profile => translate('profile');
  String get forgotPassword => translate('forgotPassword');
  String get save => translate('save');
  String get previewPdf => translate('previewPdf');
  String get exportDocx => translate('exportDocx');
  String get aboutMe => translate('aboutMe');
  String get objective => translate('objective');
  String get contactInfo => translate('contactInfo');
  String get experiences => translate('experiences');
  String get educations => translate('educations');
  String get skills => translate('skills');
  String get socialLinks => translate('socialLinks');
  String get add => translate('add');
  String get fieldRequired => translate('fieldRequired');
  String get freePlan => translate('freePlan');
  String get freePlanDesc => translate('freePlanDesc');
  String get premiumPlan => translate('premiumPlan');
  String get premiumPlanDesc => translate('premiumPlanDesc');
  String get current => translate('current');
  String get upgrade => translate('upgrade');
  String get payment => translate('payment');
  String get premiumSuccess => translate('premiumSuccess');
  String get paymentError => translate('paymentError');
  String get paymentSuccess => translate('paymentSuccess');
  String get history => translate('history');
  String get delete => translate('delete');
  String get noHistory => translate('noHistory');
  String get socialName => translate('socialName');
  String get socialUrl => translate('socialUrl');
  String get deleteConfirm => translate('deleteConfirm');
  String get deleteSuccess => translate('deleteSuccess');
  String get noHistoryDesc => translate('noHistoryDesc');
  String get resumeForm => translate('resumeForm');
  String get resumePreview => translate('resumePreview');
  String get settings => translate('settings');
  String get invalidEmail => translate('invalidEmail');
  String get passwordsDontMatch => translate('passwordsDontMatch');
  String get passwordTooShort => translate('passwordTooShort');
  String get noObjectives => translate('noObjectives');
  String get noSocialLinks => translate('noSocialLinks');
  String get noSkills => translate('noSkills');
  String get noExperiences => translate('noExperiences');
  String get noEducations => translate('noEducations');
  String get noProjects => translate('noProjects');
  String get accessibleVersionTitle => translate('accessibleVersionTitle');
  String get accessibleVersionInfo => translate('accessibleVersionInfo');
  String get landingPageHeadline => translate('landingPageHeadline');
  String get landingPageSubhead => translate('landingPageSubhead');
  String get templatesTitle => translate('templatesTitle');
  String get templateStudent => translate('templateStudent');
  String get templateDeveloper => translate('templateDeveloper');
  String get templateEuropass => translate('templateEuropass');
  String get plansTitle => translate('plansTitle');
  String get planPro => translate('planPro');
  String get planFreeDetails => translate('planFreeDetails');
  String get planPremiumDetails => translate('planPremiumDetails');
  String get planProDetails => translate('planProDetails');
  String get accessibilityOptionsTooltip =>
      translate('accessibilityOptionsTooltip');
  String get navAbout => translate('navAbout');
  String get navFeatures => translate('navFeatures');
  String get navPlans => translate('navPlans');
  String get navContact => translate('navContact');
  String get tryNow => translate('tryNow');
  String get logoSemanticLabel => translate('logoSemanticLabel');
  String get aboutTitle => translate('aboutTitle');
  String get aboutText => translate('aboutText');
  String get featuresTitle => translate('featuresTitle');
  String get featuresSectionSemanticLabel =>
      translate('featuresSectionSemanticLabel');
  String get templateIntelliResume => translate('templateIntelliResume');
  String get templateClassic => translate('templateClassic');
  String get templateStudentFirstJob => translate('templateStudentFirstJob');
  String get templateModernSidebar => translate('templateModernSidebar');
  String get templateTimeline => translate('templateTimeline');
  String get templateInfographic => translate('templateInfographic');
  String get templateDevTec => translate('templateDevTec');
  String get templateInternational => translate('templateInternational');
  String get tagPremium => translate('tagPremium');
  String get planFreeTitle => translate('planFreeTitle');
  String get planFreeDetailsShort => translate('planFreeDetailsShort');
  String get planPremiumDetailsShort => translate('planPremiumDetailsShort');
  String get processing => translate('processing');
  String get subscribeNow => translate('subscribeNow');
  String get premiumPlanActivated => translate('premiumPlanActivated');
  String get purchaseCouldNotStart => translate('purchaseCouldNotStart');
  String get noThanks => translate('noThanks');
  String get yesTry => translate('yesTry');
  String get contactIntro => translate('contactIntro');
  String get chatSupport => translate('chatSupport');
  String get chatSupportHours => translate('chatSupportHours');
  String get footerCopyright => translate('footerCopyright');
  String get accessibility => translate('accessibility');
  String get vLibrasVersion => translate('vLibrasVersion');
  String get siteLanguage => translate('siteLanguage');
  String get langPortuguese => translate('langPortuguese');
  String get langEnglish => translate('langEnglish');

  // Delegates e SupportedLocales
  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = [
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];
  static const List<Locale> supportedLocales = [Locale('en'), Locale('pt')];
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return AppLocalizations._localizedValues.keys.contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) {
    // Carregamento síncrono
    return SynchronousFuture(AppLocalizations(locale));
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
