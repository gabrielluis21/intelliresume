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
      'appTitle': 'ItelliResume',
      'appSubtitle': 'Create your resume in seconds',
      'homeTitle': 'Home',
      'homeWelcomeMessage': 'Welcome to ItelliResume',
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
      'educations': 'Educations',
      'skills': 'Skills',
      'socialLinks': 'Social Links',
      'add': 'Add',
      'fieldRequired': 'This field is required',
      'freePlan': 'Free Plan',
      'freePlanDesc': 'Limited IA, 5 exports/day, ads',
      'premiumPlan': 'Premium Plan',
      'premiumDesc': 'Unlimited IA & exports, no ads',
      'current': 'Current',
      'upgrade': 'Upgrade',
      'payment': 'Checkout',
      'premiumSuccess': 'You are now Premium!',
      'paymentError': 'Payment failed, try again.',
      'socialName': 'Social Network',
      'socialUrl': 'Social Link',
      // ... outras chaves
    },
    'pt': {
      'appTitle': 'Currículo Online',
      'homeTitle': 'Início',
      'homeWelcomeMessage': 'Bem-vindo ao Currículo Online',
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
      'paymentError': 'Pagamento falhou, tente novamente.',
      'socialName': 'Rede Social',
      'socialUrl': 'Link da Rede Social',
      // ... outras chaves
    },
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ??
        _localizedValues['en']![key] ??
        key;
  }

  // Helpers para uso mais conveniente:
  String get appTitle => translate('appTitle');
  String get homeTitle => translate('homeTitle');
  String get homeWelcomeMessage => translate('homeWelcomeMessage');
  String get appSubtitle => translate('appSubtitle');
  String get login => translate('login');
  String get signup => translate('signup');
  String get email => translate('email');
  String get password => translate('pasword');
  String get confirmPassword => translate('confirmPassword');
  String get logout => translate('logout');
  String get profile => translate('profile');
  String get forgotPassword => translate('forgotPassword');
  String get save => translate('save');
  String get previewPdf => translate('previewPdf');
  String get exportDocx => translate('exportDocx');
  String get aboutMe => translate('aboutMe');
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
  //String get kay => translate('key');
  // ... e assim por diante para cada chave

  // Delegates e SupportedLocales
  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = [
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];
  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('pt', 'BR'),
  ];
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
