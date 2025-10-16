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
      'premiumSuccess': 'Premium plan activated successfully!',
      'errorPrefix': 'Error:',
      'profileUpdateSuccess': 'Profile updated successfully!',
      'profileUpdateError': 'Error updating profile:',
      'iAmPCD': 'I wish to inform that I am a person with a disability',
      'generateAndPreviewPDF': 'Generate and Preview PDF',
      'pdfGenerationError': 'Error generating PDF:',
      'premiumTemplate': 'Premium Template',
      'close': 'Close',
      'viewPlans': 'View Plans',
      'selectLanguage': 'Select a language...',
      'pdfPreview': 'PDF Preview',
      'myResumes': 'My Resumes',
      'anErrorOccurred': 'An error occurred:',
      'noSavedResumes': 'No saved resumes.',
      'updatedOn': 'Updated on:',
      'newResume': 'New Resume',
      'hello': 'Hello!',
      'yourResumes': 'Your Resumes',
      'couldNotLoadResumes': 'Could not load resumes.',
      'quickActions': 'Quick Actions',
      'userNotFound': 'User not found.',
      'upgrade': 'Upgrade',
      'editProfile': 'Edit Profile',
      'viewResumeHistory': 'View Resume History',
      'settings': 'Settings',
      'resumeLoadError': 'Failed to load resume:',
      'viewResume': 'View Resume',
      'resumeEditor': 'Resume Editor',
      'manageAccount': 'Manage Account',
      'manageAccountSubtitle': 'Change your profile information',
      'changePassword': 'Change Password',
      'notImplemented': 'Feature to be implemented.',
      'manageSubscription': 'Manage Subscription',
      'manageSubscriptionSubtitle': 'View your plan details',
      'theme': 'Theme',
      'language': 'Language',
      'helpCenter': 'Help Center (FAQ)',
      'termsOfService': 'Terms of Service',
      'privacyPolicy': 'Privacy Policy',
      'licenses': 'Licenses',
      'logout': 'Sign Out (Logout)',
      'deleteAccount': 'Delete Account',
      'selectTheme': 'Select Theme',
      'light': 'Light',
      'dark': 'Dark',
      'systemDefault': 'System Default',
      'selectLanguageTitle': 'Select Language',
      'portuguese': '🇧🇷 Portuguese (Brazil)',
      'english': '🇺🇸 English (US)',
      'highContrast': 'High Contrast Mode',
      'boldText': 'Bold Text',
      'fontSize': 'Font Size',
      'scale': 'Scale:',
      'informAccessibility': 'Provide accessibility information?',
      'alreadyHaveAccount': 'Already have an account?',
      'generateResume': 'Generate resume',
      'expand': 'Expand',
      'draft': 'Draft',
      'print': 'Print',
      'includePCDInfo': 'Include disability info in the resume',
      'selectLanguagePrompt': 'Select Language:',
      'spanish': '🇪🇸 Spanish',
      'french': '🇫🇷 French',
      'german': '🇩🇪 German',
      'saveError': 'Error: Could not save. Please try again later...',
      'saveSuccess': 'Resume saved successfully!',
      'saveErrorPrefix': 'Error saving:',
      'saveDraft': 'Save Draft',
      'saveAndFinalize': 'Save and Finalize',
      'noCertificates': 'No certificates',
      'noEducation': 'No education',
      'noExperience': 'No experience',
      'noProjects': 'No projects',
      'couldNotOpenURL': 'Could not open URL:',
      'previewPrint': 'Preview/Print',
      'fillBeforePreview': 'Fill the resume before printing/preview...',
      'currentPlan': 'Your Current Plan',
      'createNew': 'Create New',
      'welcome': 'Welcome!',
      'loginOrCreateAccount': 'Log in or sign up',
      'templateLoadError': 'Error loading templates',
      'selectTemplate': 'Select a template',
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
      'premiumSuccess': 'Plano Premium ativado com sucesso!',
      'errorPrefix': 'Erro:',
      'profileUpdateSuccess': 'Perfil atualizado com sucesso!',
      'profileUpdateError': 'Erro ao atualizar perfil:',
      'iAmPCD': 'Desejo informar que sou PCD',
      'generateAndPreviewPDF': 'Gerar e Visualizar PDF',
      'pdfGenerationError': 'Erro ao gerar PDF:',
      'premiumTemplate': 'Template Premium',
      'close': 'Fechar',
      'viewPlans': 'Ver Planos',
      'selectLanguage': 'Selecione um idioma...',
      'pdfPreview': 'Preview PDF',
      'myResumes': 'Meus Currículos',
      'anErrorOccurred': 'Ocorreu um erro:',
      'noSavedResumes': 'Nenhum currículo salvo.',
      'updatedOn': 'Atualizado em:',
      'newResume': 'Novo Currículo',
      'hello': 'Olá!',
      'yourResumes': 'Seus Currículos',
      'couldNotLoadResumes': 'Não foi possível carregar os currículos.',
      'quickActions': 'Ações Rápidas',
      'userNotFound': 'Usuário não encontrado.',
      'upgrade': 'Fazer Upgrade',
      'editProfile': 'Editar Perfil',
      'viewResumeHistory': 'Ver Histórico de Currículos',
      'settings': 'Configurações',
      'resumeLoadError': 'Falha ao carregar o currículo:',
      'viewResume': 'Visualizar Currículo',
      'resumeEditor': 'Editor de Currículo',
      'manageAccount': 'Gerenciar Conta',
      'manageAccountSubtitle': 'Altere suas informações de perfil',
      'changePassword': 'Alterar Senha',
      'notImplemented': 'Funcionalidade a ser implementada.',
      'manageSubscription': 'Gerenciar Assinatura',
      'manageSubscriptionSubtitle': 'Veja os detalhes do seu plano',
      'theme': 'Tema',
      'language': 'Idioma',
      'helpCenter': 'Central de Ajuda (FAQ)',
      'termsOfService': 'Termos de Serviço',
      'privacyPolicy': 'Política de Privacidade',
      'licenses': 'Licenças',
      'logout': 'Sair (Logout)',
      'deleteAccount': 'Excluir Conta',
      'selectTheme': 'Selecionar Tema',
      'light': 'Claro',
      'dark': 'Escuro',
      'systemDefault': 'Padrão do Sistema',
      'selectLanguageTitle': 'Selecionar Idioma',
      'portuguese': '🇧🇷 Português (Brasil)',
      'english': '🇺🇸 Inglês (EUA)',
      'highContrast': 'Modo de Alto Contraste',
      'boldText': 'Texto em Negrito',
      'fontSize': 'Tamanho da Fonte',
      'scale': 'Escala:',
      'informAccessibility': 'Informar dados de acessibilidade?',
      'alreadyHaveAccount': 'Já tem uma conta?',
      'generateResume': 'Gerar currículo',
      'expand': 'Expandir',
      'draft': 'Rascunho',
      'print': 'Imprimir',
      'includePCDInfo': 'Incluir informações de PCD no currículo',
      'selectLanguagePrompt': 'Selecione o Idioma:',
      'spanish': '🇪🇸 Espanhol',
      'french': '🇫🇷 Fracês',
      'german': '🇩🇪 Alemão',
      'saveError': 'Erro: Não foi possível salvar. Tente mais tarde...',
      'saveSuccess': 'Currículo salvo com sucesso!',
      'saveErrorPrefix': 'Erro ao salvar:',
      'saveDraft': 'Salvar Rascunho',
      'saveAndFinalize': 'Salvar e Finalizar',
      'noCertificates': 'Nenhum certificado',
      'noEducation': 'Nenhuma formação',
      'noProjects': 'Nenhum projeto',
      'couldNotOpenURL': 'Could not open URL:',
      'previewPrint': 'Preview/Imprimir',
      'fillBeforePreview': 'Preencha o CV antes de imprimir/pré-visualizar...',
      'currentPlan': 'Seu Plano Atual',
      'createNew': 'Criar Novo',
      'welcome': 'Bem-vindo!',
      'loginOrCreateAccount': 'Faça login ou cadastre-se',
      'templateLoadError': 'Erro ao carregar templates',
      'selectTemplate': 'Selecione um template',
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
  String get premiumSuccess =>
      _localizedValues[locale.languageCode]!['premiumSuccess']!;
  String get errorPrefix =>
      _localizedValues[locale.languageCode]!['errorPrefix']!;
  String get profileUpdateSuccess =>
      _localizedValues[locale.languageCode]!['profileUpdateSuccess']!;
  String get profileUpdateError =>
      _localizedValues[locale.languageCode]!['profileUpdateError']!;
  String get iAmPCD => _localizedValues[locale.languageCode]!['iAmPCD']!;
  String get generateAndPreviewPDF =>
      _localizedValues[locale.languageCode]!['generateAndPreviewPDF']!;
  String get pdfGenerationError =>
      _localizedValues[locale.languageCode]!['pdfGenerationError']!;
  String get premiumTemplate =>
      _localizedValues[locale.languageCode]!['premiumTemplate']!;
  String get close => _localizedValues[locale.languageCode]!['close']!;
  String get viewPlans => _localizedValues[locale.languageCode]!['viewPlans']!;
  String get selectLanguage =>
      _localizedValues[locale.languageCode]!['selectLanguage']!;
  String get pdfPreview =>
      _localizedValues[locale.languageCode]!['pdfPreview']!;
  String get myResumes => _localizedValues[locale.languageCode]!['myResumes']!;
  String get anErrorOccurred =>
      _localizedValues[locale.languageCode]!['anErrorOccurred']!;
  String get noSavedResumes =>
      _localizedValues[locale.languageCode]!['noSavedResumes']!;
  String get updatedOn => _localizedValues[locale.languageCode]!['updatedOn']!;
  String get newResume => _localizedValues[locale.languageCode]!['newResume']!;
  String get hello => _localizedValues[locale.languageCode]!['hello']!;
  String get yourResumes =>
      _localizedValues[locale.languageCode]!['yourResumes']!;
  String get couldNotLoadResumes =>
      _localizedValues[locale.languageCode]!['couldNotLoadResumes']!;
  String get quickActions =>
      _localizedValues[locale.languageCode]!['quickActions']!;
  String get userNotFound =>
      _localizedValues[locale.languageCode]!['userNotFound']!;
  String get profileLoadError =>
      _localizedValues[locale.languageCode]!['profileLoadError']!;
  String get upgrade => _localizedValues[locale.languageCode]!['upgrade']!;
  String get editProfile =>
      _localizedValues[locale.languageCode]!['editProfile']!;
  String get viewResumeHistory =>
      _localizedValues[locale.languageCode]!['viewResumeHistory']!;
  String get settings => _localizedValues[locale.languageCode]!['settings']!;
  String get resumeLoadError =>
      _localizedValues[locale.languageCode]!['resumeLoadError']!;
  String get viewResume =>
      _localizedValues[locale.languageCode]!['viewResume']!;
  String get resumeEditor =>
      _localizedValues[locale.languageCode]!['resumeEditor']!;
  String get manageAccount =>
      _localizedValues[locale.languageCode]!['manageAccount']!;
  String get manageAccountSubtitle =>
      _localizedValues[locale.languageCode]!['manageAccountSubtitle']!;
  String get changePassword =>
      _localizedValues[locale.languageCode]!['changePassword']!;
  String get notImplemented =>
      _localizedValues[locale.languageCode]!['notImplemented']!;
  String get manageSubscription =>
      _localizedValues[locale.languageCode]!['manageSubscription']!;
  String get manageSubscriptionSubtitle =>
      _localizedValues[locale.languageCode]!['manageSubscriptionSubtitle']!;
  String get theme => _localizedValues[locale.languageCode]!['theme']!;
  String get language => _localizedValues[locale.languageCode]!['language']!;
  String get helpCenter =>
      _localizedValues[locale.languageCode]!['helpCenter']!;
  String get termsOfService =>
      _localizedValues[locale.languageCode]!['termsOfService']!;
  String get privacyPolicy =>
      _localizedValues[locale.languageCode]!['privacyPolicy']!;
  String get licenses => _localizedValues[locale.languageCode]!['licenses']!;
  String get logout => _localizedValues[locale.languageCode]!['logout']!;
  String get deleteAccount =>
      _localizedValues[locale.languageCode]!['deleteAccount']!;
  String get selectTheme =>
      _localizedValues[locale.languageCode]!['selectTheme']!;
  String get light => _localizedValues[locale.languageCode]!['light']!;
  String get dark => _localizedValues[locale.languageCode]!['dark']!;
  String get systemDefault =>
      _localizedValues[locale.languageCode]!['systemDefault']!;
  String get selectLanguageTitle =>
      _localizedValues[locale.languageCode]!['selectLanguageTitle']!;
  String get portuguese =>
      _localizedValues[locale.languageCode]!['portuguese']!;
  String get english => _localizedValues[locale.languageCode]!['english']!;
  String get highContrast =>
      _localizedValues[locale.languageCode]!['highContrast']!;
  String get boldText => _localizedValues[locale.languageCode]!['boldText']!;
  String get fontSize => _localizedValues[locale.languageCode]!['fontSize']!;
  String get scale => _localizedValues[locale.languageCode]!['scale']!;
  String get informAccessibility =>
      _localizedValues[locale.languageCode]!['informAccessibility']!;
  String get alreadyHaveAccount =>
      _localizedValues[locale.languageCode]!['alreadyHaveAccount']!;
  String get generateResume =>
      _localizedValues[locale.languageCode]!['generateResume']!;
  String get expand => _localizedValues[locale.languageCode]!['expand']!;
  String get draft => _localizedValues[locale.languageCode]!['draft']!;
  String get print => _localizedValues[locale.languageCode]!['print']!;
  String get includePCDInfo =>
      _localizedValues[locale.languageCode]!['includePCDInfo']!;
  String get selectLanguagePrompt =>
      _localizedValues[locale.languageCode]!['selectLanguagePrompt']!;
  String get spanish => _localizedValues[locale.languageCode]!['spanish']!;
  String get french => _localizedValues[locale.languageCode]!['french']!;
  String get german => _localizedValues[locale.languageCode]!['german']!;
  String get saveError => _localizedValues[locale.languageCode]!['saveError']!;
  String get saveSuccess =>
      _localizedValues[locale.languageCode]!['saveSuccess']!;
  String get saveErrorPrefix =>
      _localizedValues[locale.languageCode]!['saveErrorPrefix']!;
  String get saveDraft => _localizedValues[locale.languageCode]!['saveDraft']!;
  String get saveAndFinalize =>
      _localizedValues[locale.languageCode]!['saveAndFinalize']!;
  String get noCertificates =>
      _localizedValues[locale.languageCode]!['noCertificates']!;
  String get noEducation =>
      _localizedValues[locale.languageCode]!['noEducation']!;
  String get noProjects =>
      _localizedValues[locale.languageCode]!['noProjects']!;
  String get couldNotOpenURL =>
      _localizedValues[locale.languageCode]!['couldNotOpenURL']!;
  String get previewPrint =>
      _localizedValues[locale.languageCode]!['previewPrint']!;
  String get fillBeforePreview =>
      _localizedValues[locale.languageCode]!['fillBeforePreview']!;
  String get currentPlan =>
      _localizedValues[locale.languageCode]!['currentPlan']!;
  String get createNew => _localizedValues[locale.languageCode]!['createNew']!;
  String get welcome => _localizedValues[locale.languageCode]!['welcome']!;
  String get loginOrCreateAccount =>
      _localizedValues[locale.languageCode]!['loginOrCreateAccount']!;
  String get templateLoadError =>
      _localizedValues[locale.languageCode]!['templateLoadError']!;
  String get selectTemplate =>
      _localizedValues[locale.languageCode]!['selectTemplate']!;
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
  bool shouldReload(_AppLocalizationsDelegate old) => true;
}
