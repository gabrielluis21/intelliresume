import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pt'),
  ];

  /// No description provided for @aboutMe.
  ///
  /// In en, this message translates to:
  /// **'About Me'**
  String get aboutMe;

  /// No description provided for @aboutMeEmptyPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Write a brief summary about yourself...'**
  String get aboutMeEmptyPlaceholder;

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'IntelliResume'**
  String get appTitle;

  /// No description provided for @plansTitle.
  ///
  /// In en, this message translates to:
  /// **'Plans and Prices'**
  String get plansTitle;

  /// No description provided for @planFreeTitle.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get planFreeTitle;

  /// No description provided for @planFreeDetailsShort.
  ///
  /// In en, this message translates to:
  /// **'Create your resume with basic templates.'**
  String get planFreeDetailsShort;

  /// No description provided for @premiumPlan.
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get premiumPlan;

  /// No description provided for @planPremiumDetailsShort.
  ///
  /// In en, this message translates to:
  /// **'Access premium templates and AI features.'**
  String get planPremiumDetailsShort;

  /// No description provided for @contactTitle.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get contactTitle;

  /// No description provided for @contactSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Have questions, suggestions, or need support? Get in touch!'**
  String get contactSubtitle;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @chatSupportLabel.
  ///
  /// In en, this message translates to:
  /// **'Chat Support'**
  String get chatSupportLabel;

  /// No description provided for @chatSupportAvailability.
  ///
  /// In en, this message translates to:
  /// **'Available Mon-Fri, 9am to 6pm'**
  String get chatSupportAvailability;

  /// No description provided for @noExperience.
  ///
  /// In en, this message translates to:
  /// **'No Experience'**
  String get noExperience;

  /// No description provided for @noObjectives.
  ///
  /// In en, this message translates to:
  /// **'No Objectives'**
  String get noObjectives;

  /// No description provided for @noSkill.
  ///
  /// In en, this message translates to:
  /// **'No Skills'**
  String get noSkill;

  /// No description provided for @noSocialLink.
  ///
  /// In en, this message translates to:
  /// **'No Social Links'**
  String get noSocialLink;

  /// No description provided for @noEducations.
  ///
  /// In en, this message translates to:
  /// **'No Educations'**
  String get noEducations;

  /// No description provided for @socialLinks.
  ///
  /// In en, this message translates to:
  /// **'Social Links'**
  String get socialLinks;

  /// No description provided for @experiences.
  ///
  /// In en, this message translates to:
  /// **'Experiences'**
  String get experiences;

  /// No description provided for @educations.
  ///
  /// In en, this message translates to:
  /// **'Educations'**
  String get educations;

  /// No description provided for @skills.
  ///
  /// In en, this message translates to:
  /// **'Skills'**
  String get skills;

  /// No description provided for @objective.
  ///
  /// In en, this message translates to:
  /// **'Objective'**
  String get objective;

  /// No description provided for @certificates.
  ///
  /// In en, this message translates to:
  /// **'Certificates'**
  String get certificates;

  /// No description provided for @projects.
  ///
  /// In en, this message translates to:
  /// **'Projects'**
  String get projects;

  /// No description provided for @passwordsDontMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match.'**
  String get passwordsDontMatch;

  /// No description provided for @fieldRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required.'**
  String get fieldRequired;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid email address.'**
  String get invalidEmail;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters long.'**
  String get passwordTooShort;

  /// No description provided for @signup.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signup;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get login;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'E-mail'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @confirmPass.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPass;

  /// No description provided for @noHistory.
  ///
  /// In en, this message translates to:
  /// **'No History'**
  String get noHistory;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @formTitle.
  ///
  /// In en, this message translates to:
  /// **'Fill the form'**
  String get formTitle;

  /// No description provided for @forgetPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgetPassword;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @aboutIntelliTitle.
  ///
  /// In en, this message translates to:
  /// **'About IntelliResume'**
  String get aboutIntelliTitle;

  /// No description provided for @aboutIntelliDescription.
  ///
  /// In en, this message translates to:
  /// **'IntelliResume was born from the need to simplify and optimize resume creation for an increasingly global and competitive job market.\n\nOur platform uses Artificial Intelligence to help you build an impactful resume, adapted to different countries and cultures, and professionally translated. We want you to stand out and land your dream job, wherever it may be.'**
  String get aboutIntelliDescription;

  /// No description provided for @premiumSuccess.
  ///
  /// In en, this message translates to:
  /// **'Premium plan activated successfully!'**
  String get premiumSuccess;

  /// No description provided for @errorPrefix.
  ///
  /// In en, this message translates to:
  /// **'Error:'**
  String get errorPrefix;

  /// No description provided for @profileUpdateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully!'**
  String get profileUpdateSuccess;

  /// No description provided for @profileUpdateError.
  ///
  /// In en, this message translates to:
  /// **'Error updating profile:'**
  String get profileUpdateError;

  /// No description provided for @iAmPCD.
  ///
  /// In en, this message translates to:
  /// **'I wish to inform that I am a person with a disability'**
  String get iAmPCD;

  /// No description provided for @generateAndPreviewPDF.
  ///
  /// In en, this message translates to:
  /// **'Generate and Preview PDF'**
  String get generateAndPreviewPDF;

  /// No description provided for @pdfGenerationError.
  ///
  /// In en, this message translates to:
  /// **'Error generating PDF:'**
  String get pdfGenerationError;

  /// No description provided for @premiumTemplate.
  ///
  /// In en, this message translates to:
  /// **'Premium Template'**
  String get premiumTemplate;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @viewPlans.
  ///
  /// In en, this message translates to:
  /// **'View Plans'**
  String get viewPlans;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select a language...'**
  String get selectLanguage;

  /// No description provided for @pdfPreview.
  ///
  /// In en, this message translates to:
  /// **'PDF Preview'**
  String get pdfPreview;

  /// No description provided for @myResumes.
  ///
  /// In en, this message translates to:
  /// **'My Resumes'**
  String get myResumes;

  /// No description provided for @anErrorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred:'**
  String get anErrorOccurred;

  /// No description provided for @noSavedResumes.
  ///
  /// In en, this message translates to:
  /// **'No saved resumes.'**
  String get noSavedResumes;

  /// No description provided for @updatedOn.
  ///
  /// In en, this message translates to:
  /// **'Updated on:'**
  String get updatedOn;

  /// No description provided for @newResume.
  ///
  /// In en, this message translates to:
  /// **'New Resume'**
  String get newResume;

  /// No description provided for @hello.
  ///
  /// In en, this message translates to:
  /// **'Hello!'**
  String get hello;

  /// No description provided for @yourResumes.
  ///
  /// In en, this message translates to:
  /// **'Your Resumes'**
  String get yourResumes;

  /// No description provided for @couldNotLoadResumes.
  ///
  /// In en, this message translates to:
  /// **'Could not load resumes.'**
  String get couldNotLoadResumes;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// No description provided for @userNotFound.
  ///
  /// In en, this message translates to:
  /// **'User not found.'**
  String get userNotFound;

  /// No description provided for @upgrade.
  ///
  /// In en, this message translates to:
  /// **'Upgrade'**
  String get upgrade;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @viewResumeHistory.
  ///
  /// In en, this message translates to:
  /// **'View Resume History'**
  String get viewResumeHistory;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @resumeLoadError.
  ///
  /// In en, this message translates to:
  /// **'Failed to load resume:'**
  String get resumeLoadError;

  /// No description provided for @viewResume.
  ///
  /// In en, this message translates to:
  /// **'View Resume'**
  String get viewResume;

  /// No description provided for @resumeEditor.
  ///
  /// In en, this message translates to:
  /// **'Resume Editor'**
  String get resumeEditor;

  /// No description provided for @manageAccount.
  ///
  /// In en, this message translates to:
  /// **'Manage Account'**
  String get manageAccount;

  /// No description provided for @manageAccountSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Change your profile information'**
  String get manageAccountSubtitle;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @notImplemented.
  ///
  /// In en, this message translates to:
  /// **'Feature to be implemented.'**
  String get notImplemented;

  /// No description provided for @manageSubscription.
  ///
  /// In en, this message translates to:
  /// **'Manage Subscription'**
  String get manageSubscription;

  /// No description provided for @manageSubscriptionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'View your plan details'**
  String get manageSubscriptionSubtitle;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @helpCenter.
  ///
  /// In en, this message translates to:
  /// **'Help Center (FAQ)'**
  String get helpCenter;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @licenses.
  ///
  /// In en, this message translates to:
  /// **'Licenses'**
  String get licenses;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Sign Out (Logout)'**
  String get logout;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// No description provided for @selectTheme.
  ///
  /// In en, this message translates to:
  /// **'Select Theme'**
  String get selectTheme;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @systemDefault.
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get systemDefault;

  /// No description provided for @selectLanguageTitle.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguageTitle;

  /// No description provided for @portuguese.
  ///
  /// In en, this message translates to:
  /// **'🇧🇷 Portuguese (Brazil)'**
  String get portuguese;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'🇺🇸 English (US)'**
  String get english;

  /// No description provided for @highContrast.
  ///
  /// In en, this message translates to:
  /// **'High Contrast Mode'**
  String get highContrast;

  /// No description provided for @boldText.
  ///
  /// In en, this message translates to:
  /// **'Bold Text'**
  String get boldText;

  /// No description provided for @fontSize.
  ///
  /// In en, this message translates to:
  /// **'Font Size'**
  String get fontSize;

  /// No description provided for @scale.
  ///
  /// In en, this message translates to:
  /// **'Scale:'**
  String get scale;

  /// No description provided for @informAccessibility.
  ///
  /// In en, this message translates to:
  /// **'Provide accessibility information?'**
  String get informAccessibility;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @generateResume.
  ///
  /// In en, this message translates to:
  /// **'Generate resume'**
  String get generateResume;

  /// No description provided for @expand.
  ///
  /// In en, this message translates to:
  /// **'Expand'**
  String get expand;

  /// No description provided for @draft.
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get draft;

  /// No description provided for @print.
  ///
  /// In en, this message translates to:
  /// **'Print'**
  String get print;

  /// No description provided for @includePCDInfo.
  ///
  /// In en, this message translates to:
  /// **'Include disability info in the resume'**
  String get includePCDInfo;

  /// No description provided for @selectLanguagePrompt.
  ///
  /// In en, this message translates to:
  /// **'Select Language:'**
  String get selectLanguagePrompt;

  /// No description provided for @spanish.
  ///
  /// In en, this message translates to:
  /// **'🇪🇸 Spanish'**
  String get spanish;

  /// No description provided for @french.
  ///
  /// In en, this message translates to:
  /// **'🇫🇷 French'**
  String get french;

  /// No description provided for @german.
  ///
  /// In en, this message translates to:
  /// **'🇩🇪 German'**
  String get german;

  /// No description provided for @saveError.
  ///
  /// In en, this message translates to:
  /// **'Error: Could not save. Please try again later...'**
  String get saveError;

  /// No description provided for @saveSuccess.
  ///
  /// In en, this message translates to:
  /// **'Resume saved successfully!'**
  String get saveSuccess;

  /// No description provided for @saveErrorPrefix.
  ///
  /// In en, this message translates to:
  /// **'Error saving:'**
  String get saveErrorPrefix;

  /// No description provided for @saveDraft.
  ///
  /// In en, this message translates to:
  /// **'Save Draft'**
  String get saveDraft;

  /// No description provided for @saveAndFinalize.
  ///
  /// In en, this message translates to:
  /// **'Save and Finalize'**
  String get saveAndFinalize;

  /// No description provided for @noCertificates.
  ///
  /// In en, this message translates to:
  /// **'No certificates'**
  String get noCertificates;

  /// No description provided for @noEducation.
  ///
  /// In en, this message translates to:
  /// **'No education'**
  String get noEducation;

  /// No description provided for @noProjects.
  ///
  /// In en, this message translates to:
  /// **'No projects'**
  String get noProjects;

  /// No description provided for @couldNotOpenURL.
  ///
  /// In en, this message translates to:
  /// **'Could not open URL:'**
  String get couldNotOpenURL;

  /// No description provided for @previewPrint.
  ///
  /// In en, this message translates to:
  /// **'Preview/Print'**
  String get previewPrint;

  /// No description provided for @fillBeforePreview.
  ///
  /// In en, this message translates to:
  /// **'Fill the resume before printing/preview...'**
  String get fillBeforePreview;

  /// No description provided for @currentPlan.
  ///
  /// In en, this message translates to:
  /// **'Your Current Plan'**
  String get currentPlan;

  /// No description provided for @createNew.
  ///
  /// In en, this message translates to:
  /// **'Create New'**
  String get createNew;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome!'**
  String get welcome;

  /// No description provided for @loginOrCreateAccount.
  ///
  /// In en, this message translates to:
  /// **'Log in or sign up'**
  String get loginOrCreateAccount;

  /// No description provided for @templateLoadError.
  ///
  /// In en, this message translates to:
  /// **'Error loading templates'**
  String get templateLoadError;

  /// No description provided for @selectTemplate.
  ///
  /// In en, this message translates to:
  /// **'Select a template'**
  String get selectTemplate;

  /// No description provided for @pdfType.
  ///
  /// In en, this message translates to:
  /// **'PDF'**
  String get pdfType;

  /// No description provided for @noProjectsInserted.
  ///
  /// In en, this message translates to:
  /// **'No registered projects'**
  String get noProjectsInserted;

  /// No description provided for @erro.
  ///
  /// In en, this message translates to:
  /// **'Erro'**
  String get erro;

  /// No description provided for @noGraduationsInserted.
  ///
  /// In en, this message translates to:
  /// **'No registered graduations'**
  String get noGraduationsInserted;

  /// No description provided for @noSkillInserted.
  ///
  /// In en, this message translates to:
  /// **'No registered skills'**
  String get noSkillInserted;

  /// No description provided for @noExperiencesInserted.
  ///
  /// In en, this message translates to:
  /// **'No registered experiences'**
  String get noExperiencesInserted;

  /// No description provided for @noCertificatesinserted.
  ///
  /// In en, this message translates to:
  /// **'No registered certificates'**
  String get noCertificatesinserted;

  /// No description provided for @failToLoadUserProfile.
  ///
  /// In en, this message translates to:
  /// **'Failed to load user\'s profile'**
  String get failToLoadUserProfile;

  /// No description provided for @experimenteAgora.
  ///
  /// In en, this message translates to:
  /// **'Try it now!'**
  String get experimenteAgora;

  /// No description provided for @muteAndDeafMode.
  ///
  /// In en, this message translates to:
  /// **'Deaf/Mute Version (Sign language)'**
  String get muteAndDeafMode;

  /// No description provided for @experiencesEmptyPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Yours experiencies will be here.'**
  String get experiencesEmptyPlaceholder;

  /// No description provided for @educationsEmptyPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Yours graduations will be here.'**
  String get educationsEmptyPlaceholder;

  /// No description provided for @skillsEmptyPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Yours skills will be here.'**
  String get skillsEmptyPlaceholder;

  /// No description provided for @socialLinksEmptyPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Yours socials will be here.'**
  String get socialLinksEmptyPlaceholder;

  /// No description provided for @certificatesEmptyPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Yours certificates will be here.'**
  String get certificatesEmptyPlaceholder;

  /// No description provided for @appearanceAndBehavior.
  ///
  /// In en, this message translates to:
  /// **'Appearance and Behavior'**
  String get appearanceAndBehavior;

  /// No description provided for @accessibility.
  ///
  /// In en, this message translates to:
  /// **'Accessibility'**
  String get accessibility;

  /// No description provided for @aboutAndSupport.
  ///
  /// In en, this message translates to:
  /// **'About and Support'**
  String get aboutAndSupport;

  /// No description provided for @preview.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get preview;

  /// No description provided for @objectivesEmptyPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Your professional objectives will appear here.'**
  String get objectivesEmptyPlaceholder;

  /// No description provided for @projectsEmptyPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Your projects will appear here.'**
  String get projectsEmptyPlaceholder;

  /// No description provided for @login_invalidEmailForReset.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email to reset your password.'**
  String get login_invalidEmailForReset;

  /// No description provided for @login_resetEmailSent.
  ///
  /// In en, this message translates to:
  /// **'A reset email has been sent to {email}.'**
  String login_resetEmailSent(Object email);

  /// No description provided for @login_logoSemanticLabel.
  ///
  /// In en, this message translates to:
  /// **'IntelliResume Logo'**
  String get login_logoSemanticLabel;

  /// No description provided for @login_welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back! Please log in.'**
  String get login_welcomeBack;

  /// No description provided for @login_showPasswordTooltip.
  ///
  /// In en, this message translates to:
  /// **'Show password'**
  String get login_showPasswordTooltip;

  /// No description provided for @login_hidePasswordTooltip.
  ///
  /// In en, this message translates to:
  /// **'Hide password'**
  String get login_hidePasswordTooltip;

  /// No description provided for @login_noAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get login_noAccount;

  /// No description provided for @sideBarMenu_welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome!'**
  String get sideBarMenu_welcome;

  /// No description provided for @sideBarMenu_loginOrCreateAccount.
  ///
  /// In en, this message translates to:
  /// **'Log in or sign up'**
  String get sideBarMenu_loginOrCreateAccount;

  /// No description provided for @sideBarMenu_errorLoadingProfile.
  ///
  /// In en, this message translates to:
  /// **'Error loading profile'**
  String get sideBarMenu_errorLoadingProfile;

  /// No description provided for @sideBarMenu_home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get sideBarMenu_home;

  /// No description provided for @sideBarMenu_profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get sideBarMenu_profile;

  /// No description provided for @sideBarMenu_history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get sideBarMenu_history;

  /// No description provided for @sideBarMenu_newCV.
  ///
  /// In en, this message translates to:
  /// **'New CV'**
  String get sideBarMenu_newCV;

  /// No description provided for @sideBarMenu_settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get sideBarMenu_settings;

  /// No description provided for @sideBarMenu_logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get sideBarMenu_logout;

  /// No description provided for @home_greeting.
  ///
  /// In en, this message translates to:
  /// **'Hello, {name}!'**
  String home_greeting(Object name);

  /// No description provided for @home_greetingFallback.
  ///
  /// In en, this message translates to:
  /// **'Hello!'**
  String get home_greetingFallback;

  /// No description provided for @home_welcomeBackPrompt.
  ///
  /// In en, this message translates to:
  /// **'Welcome back. Ready to conquer your next job?'**
  String get home_welcomeBackPrompt;

  /// No description provided for @home_yourResumes.
  ///
  /// In en, this message translates to:
  /// **'Your Resumes'**
  String get home_yourResumes;

  /// No description provided for @home_couldNotLoadResumes.
  ///
  /// In en, this message translates to:
  /// **'Could not load resumes.'**
  String get home_couldNotLoadResumes;

  /// No description provided for @home_quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get home_quickActions;

  /// No description provided for @home_viewFullHistory.
  ///
  /// In en, this message translates to:
  /// **'View Full History'**
  String get home_viewFullHistory;

  /// No description provided for @home_historyIconSemanticLabel.
  ///
  /// In en, this message translates to:
  /// **'History icon'**
  String get home_historyIconSemanticLabel;

  /// No description provided for @home_exploreTemplates.
  ///
  /// In en, this message translates to:
  /// **'Explore Templates'**
  String get home_exploreTemplates;

  /// No description provided for @home_paletteIconSemanticLabel.
  ///
  /// In en, this message translates to:
  /// **'Color palette icon'**
  String get home_paletteIconSemanticLabel;

  /// No description provided for @home_mySubscription.
  ///
  /// In en, this message translates to:
  /// **'My Subscription'**
  String get home_mySubscription;

  /// No description provided for @home_premiumIconSemanticLabel.
  ///
  /// In en, this message translates to:
  /// **'Premium subscription icon'**
  String get home_premiumIconSemanticLabel;

  /// No description provided for @home_settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get home_settings;

  /// No description provided for @home_settingsIconSemanticLabel.
  ///
  /// In en, this message translates to:
  /// **'Settings icon'**
  String get home_settingsIconSemanticLabel;

  /// No description provided for @signup_createAccountPrompt.
  ///
  /// In en, this message translates to:
  /// **'Create your account to get started.'**
  String get signup_createAccountPrompt;

  /// No description provided for @signup_fullNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get signup_fullNameLabel;

  /// No description provided for @signup_disabilityInfoSemanticLabel.
  ///
  /// In en, this message translates to:
  /// **'Option to provide accessibility or disability information.'**
  String get signup_disabilityInfoSemanticLabel;

  /// No description provided for @signup_informDisabilityQuestion.
  ///
  /// In en, this message translates to:
  /// **'Provide accessibility information?'**
  String get signup_informDisabilityQuestion;

  /// No description provided for @signup_disabilityDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Description (optional)'**
  String get signup_disabilityDescriptionLabel;

  /// No description provided for @signup_disabilityDescriptionHelper.
  ///
  /// In en, this message translates to:
  /// **'Ex: I need a Libras interpreter.'**
  String get signup_disabilityDescriptionHelper;

  /// No description provided for @resumeForm_unauthenticatedUser.
  ///
  /// In en, this message translates to:
  /// **'Unauthenticated user.'**
  String get resumeForm_unauthenticatedUser;

  /// No description provided for @resumeForm_failedToLoadResume.
  ///
  /// In en, this message translates to:
  /// **'Failed to load resume: {error}'**
  String resumeForm_failedToLoadResume(Object error);

  /// No description provided for @resumeForm_eyeIconSemanticLabel.
  ///
  /// In en, this message translates to:
  /// **'Eye icon'**
  String get resumeForm_eyeIconSemanticLabel;

  /// No description provided for @exportButtons_print.
  ///
  /// In en, this message translates to:
  /// **'Print'**
  String get exportButtons_print;

  /// No description provided for @template_projects.
  ///
  /// In en, this message translates to:
  /// **'Projects'**
  String get template_projects;

  /// No description provided for @template_noProjects.
  ///
  /// In en, this message translates to:
  /// **'No projects added.'**
  String get template_noProjects;

  /// No description provided for @template_current.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get template_current;

  /// No description provided for @template_certificates.
  ///
  /// In en, this message translates to:
  /// **'Certificates'**
  String get template_certificates;

  /// No description provided for @template_noCertificates.
  ///
  /// In en, this message translates to:
  /// **'No certificates added.'**
  String get template_noCertificates;

  /// No description provided for @template_workload.
  ///
  /// In en, this message translates to:
  /// **'Workload:'**
  String get template_workload;

  /// No description provided for @template_defaultIntelliResume.
  ///
  /// In en, this message translates to:
  /// **'IntelliResume Default'**
  String get template_defaultIntelliResume;

  /// No description provided for @template_downloadFailed.
  ///
  /// In en, this message translates to:
  /// **'Download failed'**
  String get template_downloadFailed;

  /// No description provided for @template_socialLinks.
  ///
  /// In en, this message translates to:
  /// **'Links and Social Networks'**
  String get template_socialLinks;

  /// No description provided for @template_additionalInfo.
  ///
  /// In en, this message translates to:
  /// **'Additional Information'**
  String get template_additionalInfo;

  /// No description provided for @template_classicMinimalist.
  ///
  /// In en, this message translates to:
  /// **'Classic Minimalist'**
  String get template_classicMinimalist;

  /// No description provided for @template_objective.
  ///
  /// In en, this message translates to:
  /// **'Objective'**
  String get template_objective;

  /// No description provided for @template_noExperienceRegistered.
  ///
  /// In en, this message translates to:
  /// **'No experience registered'**
  String get template_noExperienceRegistered;

  /// No description provided for @template_graduation.
  ///
  /// In en, this message translates to:
  /// **'Graduation'**
  String get template_graduation;

  /// No description provided for @template_noGraduationsRegistered.
  ///
  /// In en, this message translates to:
  /// **'No graduations registered'**
  String get template_noGraduationsRegistered;

  /// No description provided for @template_skills.
  ///
  /// In en, this message translates to:
  /// **'Skills'**
  String get template_skills;

  /// No description provided for @template_noSkillsRegistered.
  ///
  /// In en, this message translates to:
  /// **'No skills registered'**
  String get template_noSkillsRegistered;

  /// No description provided for @template_modernSidebar.
  ///
  /// In en, this message translates to:
  /// **'Modern with Sidebar'**
  String get template_modernSidebar;

  /// No description provided for @template_yourName.
  ///
  /// In en, this message translates to:
  /// **'YOUR NAME'**
  String get template_yourName;

  /// No description provided for @template_profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get template_profile;

  /// No description provided for @template_experience.
  ///
  /// In en, this message translates to:
  /// **'Experience'**
  String get template_experience;

  /// No description provided for @template_jobTitle.
  ///
  /// In en, this message translates to:
  /// **'JOB TITLE'**
  String get template_jobTitle;

  /// No description provided for @template_company.
  ///
  /// In en, this message translates to:
  /// **'Company'**
  String get template_company;

  /// No description provided for @template_present.
  ///
  /// In en, this message translates to:
  /// **'Present'**
  String get template_present;

  /// No description provided for @template_education.
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get template_education;

  /// No description provided for @template_degreeCourse.
  ///
  /// In en, this message translates to:
  /// **'DEGREE / COURSE'**
  String get template_degreeCourse;

  /// No description provided for @template_institution.
  ///
  /// In en, this message translates to:
  /// **'Institution'**
  String get template_institution;

  /// No description provided for @template_projectName.
  ///
  /// In en, this message translates to:
  /// **'PROJECT NAME'**
  String get template_projectName;

  /// No description provided for @template_certificateName.
  ///
  /// In en, this message translates to:
  /// **'CERTIFICATE NAME'**
  String get template_certificateName;

  /// No description provided for @template_timeline.
  ///
  /// In en, this message translates to:
  /// **'Timeline'**
  String get template_timeline;

  /// No description provided for @template_visualInfographic.
  ///
  /// In en, this message translates to:
  /// **'Visual Infographic'**
  String get template_visualInfographic;

  /// No description provided for @template_contact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get template_contact;

  /// No description provided for @template_summary.
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get template_summary;

  /// No description provided for @template_professionalExperience.
  ///
  /// In en, this message translates to:
  /// **'Professional Experience'**
  String get template_professionalExperience;

  /// No description provided for @template_academicBackground.
  ///
  /// In en, this message translates to:
  /// **'Academic Background'**
  String get template_academicBackground;

  /// No description provided for @template_ongoing.
  ///
  /// In en, this message translates to:
  /// **'ongoing'**
  String get template_ongoing;

  /// No description provided for @template_beginner.
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get template_beginner;

  /// No description provided for @template_basic.
  ///
  /// In en, this message translates to:
  /// **'Basic'**
  String get template_basic;

  /// No description provided for @template_intermediate.
  ///
  /// In en, this message translates to:
  /// **'Intermediate'**
  String get template_intermediate;

  /// No description provided for @template_advanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get template_advanced;

  /// No description provided for @template_fluent.
  ///
  /// In en, this message translates to:
  /// **'Fluent'**
  String get template_fluent;

  /// No description provided for @template_elegantCorporate.
  ///
  /// In en, this message translates to:
  /// **'Elegant Corporate'**
  String get template_elegantCorporate;

  /// No description provided for @template_professionalSummary.
  ///
  /// In en, this message translates to:
  /// **'Professional Summary'**
  String get template_professionalSummary;

  /// No description provided for @template_stacksTechnologies.
  ///
  /// In en, this message translates to:
  /// **'Stacks & Technologies'**
  String get template_stacksTechnologies;

  /// No description provided for @template_noSkillAdded.
  ///
  /// In en, this message translates to:
  /// **'No Skill added'**
  String get template_noSkillAdded;

  /// No description provided for @template_developer.
  ///
  /// In en, this message translates to:
  /// **'Developer'**
  String get template_developer;

  /// No description provided for @template_nameNotFound.
  ///
  /// In en, this message translates to:
  /// **'Name not found'**
  String get template_nameNotFound;

  /// No description provided for @template_softwareEngineeringStudent.
  ///
  /// In en, this message translates to:
  /// **'Software Engineering Student'**
  String get template_softwareEngineeringStudent;

  /// No description provided for @template_noExperience.
  ///
  /// In en, this message translates to:
  /// **'No registered experiences'**
  String get template_noExperience;

  /// No description provided for @template_courses.
  ///
  /// In en, this message translates to:
  /// **'Courses'**
  String get template_courses;

  /// No description provided for @template_noCertificatesRegistered.
  ///
  /// In en, this message translates to:
  /// **'No registered certificates'**
  String get template_noCertificatesRegistered;

  /// No description provided for @template_noSkills.
  ///
  /// In en, this message translates to:
  /// **'No registered skills'**
  String get template_noSkills;

  /// No description provided for @template_noProjectsRegistered.
  ///
  /// In en, this message translates to:
  /// **'No registered projects'**
  String get template_noProjectsRegistered;

  /// No description provided for @template_aboutMe.
  ///
  /// In en, this message translates to:
  /// **'About Me'**
  String get template_aboutMe;

  /// No description provided for @template_aboutMeDefault.
  ///
  /// In en, this message translates to:
  /// **'Software Engineering student with a solid academic background and practical experience in developing web and mobile applications.'**
  String get template_aboutMeDefault;

  /// No description provided for @template_firstJob.
  ///
  /// In en, this message translates to:
  /// **'First Job'**
  String get template_firstJob;

  /// No description provided for @template_workExperience.
  ///
  /// In en, this message translates to:
  /// **'Work Experience'**
  String get template_workExperience;

  /// No description provided for @template_languages.
  ///
  /// In en, this message translates to:
  /// **'Languages'**
  String get template_languages;

  /// No description provided for @template_international.
  ///
  /// In en, this message translates to:
  /// **'International'**
  String get template_international;

  /// No description provided for @preview_noCertificates.
  ///
  /// In en, this message translates to:
  /// **'No certificates'**
  String get preview_noCertificates;

  /// No description provided for @preview_certificateSemanticLabel.
  ///
  /// In en, this message translates to:
  /// **'Certificate {index}: {courseName}. Tap to edit.'**
  String preview_certificateSemanticLabel(Object courseName, Object index);

  /// No description provided for @preview_current.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get preview_current;

  /// No description provided for @preview_noEducation.
  ///
  /// In en, this message translates to:
  /// **'No education'**
  String get preview_noEducation;

  /// No description provided for @preview_educationSemanticLabel.
  ///
  /// In en, this message translates to:
  /// **'Education {index}: {degree} in {school}. Tap to edit.'**
  String preview_educationSemanticLabel(
    Object degree,
    Object index,
    Object school,
  );

  /// No description provided for @preview_noExperience.
  ///
  /// In en, this message translates to:
  /// **'No experience'**
  String get preview_noExperience;

  /// No description provided for @preview_experienceSemanticLabel.
  ///
  /// In en, this message translates to:
  /// **'Experience {index}: {company} in {position}. Tap to edit.'**
  String preview_experienceSemanticLabel(
    Object company,
    Object index,
    Object position,
  );

  /// No description provided for @preview_noProjects.
  ///
  /// In en, this message translates to:
  /// **'No projects'**
  String get preview_noProjects;

  /// No description provided for @preview_projectSemanticLabel.
  ///
  /// In en, this message translates to:
  /// **'Project {index}: {name}. Tap to edit.'**
  String preview_projectSemanticLabel(Object index, Object name);

  /// No description provided for @preview_socialLinkSemanticLabel.
  ///
  /// In en, this message translates to:
  /// **'Open {platform} profile. Link to {url}'**
  String preview_socialLinkSemanticLabel(Object platform, Object url);

  /// No description provided for @preview_couldNotOpenURL.
  ///
  /// In en, this message translates to:
  /// **'Could not open URL: {url}'**
  String preview_couldNotOpenURL(Object url);

  /// No description provided for @recentResume_semanticLabel.
  ///
  /// In en, this message translates to:
  /// **'Resume: {title}, tap to edit'**
  String recentResume_semanticLabel(Object title);

  /// No description provided for @recentResume_iconSemanticLabel.
  ///
  /// In en, this message translates to:
  /// **'Resume icon'**
  String get recentResume_iconSemanticLabel;

  /// No description provided for @recentResume_untitled.
  ///
  /// In en, this message translates to:
  /// **'Untitled Resume'**
  String get recentResume_untitled;

  /// No description provided for @recentResume_draft.
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get recentResume_draft;

  /// No description provided for @recentResume_finalized.
  ///
  /// In en, this message translates to:
  /// **'Finalized'**
  String get recentResume_finalized;

  /// No description provided for @recentResume_editedOn.
  ///
  /// In en, this message translates to:
  /// **'Edited on: {date}'**
  String recentResume_editedOn(Object date);

  /// No description provided for @addNewResume_semanticLabel.
  ///
  /// In en, this message translates to:
  /// **'Create New Resume, tap to start'**
  String get addNewResume_semanticLabel;

  /// No description provided for @addNewResume_iconSemanticLabel.
  ///
  /// In en, this message translates to:
  /// **'Add new resume icon'**
  String get addNewResume_iconSemanticLabel;

  /// No description provided for @addNewResume_create.
  ///
  /// In en, this message translates to:
  /// **'Create New'**
  String get addNewResume_create;

  /// No description provided for @templateSelector_errorLoadingTemplates.
  ///
  /// In en, this message translates to:
  /// **'Error loading templates'**
  String get templateSelector_errorLoadingTemplates;

  /// No description provided for @templateSelector_selectTemplate.
  ///
  /// In en, this message translates to:
  /// **'Select a template'**
  String get templateSelector_selectTemplate;

  /// No description provided for @contactSection_title.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get contactSection_title;

  /// No description provided for @contactSection_description.
  ///
  /// In en, this message translates to:
  /// **'Have questions, suggestions, or need support? Get in touch!'**
  String get contactSection_description;

  /// No description provided for @contactSection_emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get contactSection_emailLabel;

  /// No description provided for @contactSection_emailSemanticLabel.
  ///
  /// In en, this message translates to:
  /// **'Contact email: support@intelliresume.com'**
  String get contactSection_emailSemanticLabel;

  /// No description provided for @contactSection_chatSupportLabel.
  ///
  /// In en, this message translates to:
  /// **'Chat Support'**
  String get contactSection_chatSupportLabel;

  /// No description provided for @contactSection_chatSupportAvailability.
  ///
  /// In en, this message translates to:
  /// **'Available Mon-Fri, 9am to 6pm'**
  String get contactSection_chatSupportAvailability;

  /// No description provided for @buyPage_premiumSuccess.
  ///
  /// In en, this message translates to:
  /// **'Premium plan activated successfully!'**
  String get buyPage_premiumSuccess;

  /// No description provided for @buyPage_genericError.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String buyPage_genericError(Object error);

  /// No description provided for @editProfile_userProfileNotFound.
  ///
  /// In en, this message translates to:
  /// **'User profile not found.'**
  String get editProfile_userProfileNotFound;

  /// No description provided for @editProfile_uidNotFoundForImageUpload.
  ///
  /// In en, this message translates to:
  /// **'User UID not found for image upload.'**
  String get editProfile_uidNotFoundForImageUpload;

  /// No description provided for @editProfile_profileUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully!'**
  String get editProfile_profileUpdatedSuccessfully;

  /// No description provided for @editProfile_errorUpdatingProfile.
  ///
  /// In en, this message translates to:
  /// **'Error updating profile: {error}'**
  String editProfile_errorUpdatingProfile(Object error);

  /// No description provided for @editProfile_editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile_editProfile;

  /// No description provided for @editProfile_name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get editProfile_name;

  /// No description provided for @editProfile_phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get editProfile_phone;

  /// No description provided for @editProfile_fieldRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get editProfile_fieldRequired;

  /// No description provided for @editProfile_accessibilityAndInclusion.
  ///
  /// In en, this message translates to:
  /// **'Accessibility and Inclusion'**
  String get editProfile_accessibilityAndInclusion;

  /// No description provided for @editProfile_informPCD.
  ///
  /// In en, this message translates to:
  /// **'I wish to inform that I am a person with a disability'**
  String get editProfile_informPCD;

  /// No description provided for @editProfile_pcdInfoOptional.
  ///
  /// In en, this message translates to:
  /// **'This information is optional and will be used for affirmative action vacancies.'**
  String get editProfile_pcdInfoOptional;

  /// No description provided for @editProfile_disabilityTypes.
  ///
  /// In en, this message translates to:
  /// **'Disability Types (select one or more)'**
  String get editProfile_disabilityTypes;

  /// No description provided for @editProfile_physicalDisability.
  ///
  /// In en, this message translates to:
  /// **'Physical'**
  String get editProfile_physicalDisability;

  /// No description provided for @editProfile_auditoryDisability.
  ///
  /// In en, this message translates to:
  /// **'Auditory'**
  String get editProfile_auditoryDisability;

  /// No description provided for @editProfile_visualDisability.
  ///
  /// In en, this message translates to:
  /// **'Visual'**
  String get editProfile_visualDisability;

  /// No description provided for @editProfile_mentalDisability.
  ///
  /// In en, this message translates to:
  /// **'Mental'**
  String get editProfile_mentalDisability;

  /// No description provided for @editProfile_intellectualDisability.
  ///
  /// In en, this message translates to:
  /// **'Intellectual'**
  String get editProfile_intellectualDisability;

  /// No description provided for @editProfile_multipleDisabilities.
  ///
  /// In en, this message translates to:
  /// **'Multiple'**
  String get editProfile_multipleDisabilities;

  /// No description provided for @editProfile_descriptionOrCIDOptional.
  ///
  /// In en, this message translates to:
  /// **'Description or CID (optional)'**
  String get editProfile_descriptionOrCIDOptional;

  /// No description provided for @editProfile_selectProfilePicture.
  ///
  /// In en, this message translates to:
  /// **'Select profile picture'**
  String get editProfile_selectProfilePicture;

  /// No description provided for @editProfile_saving.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get editProfile_saving;

  /// No description provided for @editProfile_saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get editProfile_saveChanges;

  /// No description provided for @exportPage_chooseTemplate.
  ///
  /// In en, this message translates to:
  /// **'1. Choose Template'**
  String get exportPage_chooseTemplate;

  /// No description provided for @exportPage_defaultTemplateDescription.
  ///
  /// In en, this message translates to:
  /// **'Our standard, balanced and professional template.'**
  String get exportPage_defaultTemplateDescription;

  /// No description provided for @exportPage_classicTemplateDescription.
  ///
  /// In en, this message translates to:
  /// **'A clean and classic design, focused on content.'**
  String get exportPage_classicTemplateDescription;

  /// No description provided for @exportPage_studentFirstJobTemplateDescription.
  ///
  /// In en, this message translates to:
  /// **'Ideal for students and first jobs.'**
  String get exportPage_studentFirstJobTemplateDescription;

  /// No description provided for @exportPage_modernSideTemplateDescription.
  ///
  /// In en, this message translates to:
  /// **'A modern layout with an elegant sidebar.'**
  String get exportPage_modernSideTemplateDescription;

  /// No description provided for @exportPage_internationalTemplateDescription.
  ///
  /// In en, this message translates to:
  /// **'Universal format, ready for translation.'**
  String get exportPage_internationalTemplateDescription;

  /// No description provided for @exportPage_devTecTemplateDescription.
  ///
  /// In en, this message translates to:
  /// **'Made for developers, highlighting skills and projects.'**
  String get exportPage_devTecTemplateDescription;

  /// No description provided for @exportPage_professionalTemplateDescription.
  ///
  /// In en, this message translates to:
  /// **'A professional template for your resume.'**
  String get exportPage_professionalTemplateDescription;

  /// No description provided for @exportPage_customizeOptional.
  ///
  /// In en, this message translates to:
  /// **'2. Customize (Optional)'**
  String get exportPage_customizeOptional;

  /// No description provided for @exportPage_generateAndPreviewPDF.
  ///
  /// In en, this message translates to:
  /// **'Generate and Preview PDF'**
  String get exportPage_generateAndPreviewPDF;

  /// No description provided for @exportPage_generateAndPreviewPDFTooltip.
  ///
  /// In en, this message translates to:
  /// **'Generate and preview the resume in PDF format'**
  String get exportPage_generateAndPreviewPDFTooltip;

  /// No description provided for @exportPage_errorGeneratingPDF.
  ///
  /// In en, this message translates to:
  /// **'Error generating PDF: {error}'**
  String exportPage_errorGeneratingPDF(Object error);

  /// No description provided for @exportPage_premiumTemplate.
  ///
  /// In en, this message translates to:
  /// **'Premium Template'**
  String get exportPage_premiumTemplate;

  /// No description provided for @exportPage_premiumTemplateMessage.
  ///
  /// In en, this message translates to:
  /// **'This template is only available on Premium or Pro plans. Upgrade to use this and many other features!'**
  String get exportPage_premiumTemplateMessage;

  /// No description provided for @exportPage_close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get exportPage_close;

  /// No description provided for @exportPage_viewPlans.
  ///
  /// In en, this message translates to:
  /// **'View Plans'**
  String get exportPage_viewPlans;

  /// No description provided for @exportPage_error.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String exportPage_error(Object error);

  /// No description provided for @exportPage_free.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get exportPage_free;

  /// No description provided for @exportPage_premium.
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get exportPage_premium;

  /// No description provided for @exportPage_selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select a language...'**
  String get exportPage_selectLanguage;

  /// No description provided for @exportPage_english.
  ///
  /// In en, this message translates to:
  /// **'English (English)'**
  String get exportPage_english;

  /// No description provided for @exportPage_spanish.
  ///
  /// In en, this message translates to:
  /// **'Spanish (Español)'**
  String get exportPage_spanish;

  /// No description provided for @exportPage_french.
  ///
  /// In en, this message translates to:
  /// **'French (Français)'**
  String get exportPage_french;

  /// No description provided for @exportPage_translateResume.
  ///
  /// In en, this message translates to:
  /// **'Translate resume'**
  String get exportPage_translateResume;

  /// No description provided for @exportPage_contentWillBeTranslated.
  ///
  /// In en, this message translates to:
  /// **'The content will be translated.'**
  String get exportPage_contentWillBeTranslated;

  /// No description provided for @exportPage_availableOnlyInternational.
  ///
  /// In en, this message translates to:
  /// **'Available only for the International template.'**
  String get exportPage_availableOnlyInternational;

  /// No description provided for @exportPdfPage_previewPdf.
  ///
  /// In en, this message translates to:
  /// **'Preview PDF'**
  String get exportPdfPage_previewPdf;

  /// No description provided for @exportPdfPage_print.
  ///
  /// In en, this message translates to:
  /// **'Print'**
  String get exportPdfPage_print;

  /// No description provided for @exportPdfPage_download.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get exportPdfPage_download;

  /// No description provided for @historyPage_myResumes.
  ///
  /// In en, this message translates to:
  /// **'My Resumes'**
  String get historyPage_myResumes;

  /// No description provided for @historyPage_anErrorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred: {error}'**
  String historyPage_anErrorOccurred(Object error);

  /// No description provided for @historyPage_noSavedResumes.
  ///
  /// In en, this message translates to:
  /// **'No saved resumes.'**
  String get historyPage_noSavedResumes;

  /// No description provided for @historyPage_createNewResumeToStart.
  ///
  /// In en, this message translates to:
  /// **'Create a new resume to start.'**
  String get historyPage_createNewResumeToStart;

  /// No description provided for @historyPage_untitledResume.
  ///
  /// In en, this message translates to:
  /// **'Untitled Resume'**
  String get historyPage_untitledResume;

  /// No description provided for @historyPage_updatedOn.
  ///
  /// In en, this message translates to:
  /// **'Updated on: {date}'**
  String historyPage_updatedOn(Object date);

  /// No description provided for @historyPage_newResume.
  ///
  /// In en, this message translates to:
  /// **'New Resume'**
  String get historyPage_newResume;

  /// No description provided for @profilePage_userNotFound.
  ///
  /// In en, this message translates to:
  /// **'User not found.'**
  String get profilePage_userNotFound;

  /// No description provided for @profilePage_errorLoadingProfile.
  ///
  /// In en, this message translates to:
  /// **'Error loading profile: {error}'**
  String profilePage_errorLoadingProfile(Object error);

  /// No description provided for @profilePage_profilePictureSemanticLabel.
  ///
  /// In en, this message translates to:
  /// **'Profile picture of {userName}'**
  String profilePage_profilePictureSemanticLabel(Object userName);

  /// No description provided for @profilePage_avatarSemanticLabel.
  ///
  /// In en, this message translates to:
  /// **'Avatar with initial of name {userName}'**
  String profilePage_avatarSemanticLabel(Object userName);

  /// No description provided for @profilePage_defaultUserName.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get profilePage_defaultUserName;

  /// No description provided for @profilePage_defaultEmail.
  ///
  /// In en, this message translates to:
  /// **'email@example.com'**
  String get profilePage_defaultEmail;

  /// No description provided for @profilePage_mySubscription.
  ///
  /// In en, this message translates to:
  /// **'My Subscription'**
  String get profilePage_mySubscription;

  /// No description provided for @profilePage_premiumPlanStarIconSemanticLabel.
  ///
  /// In en, this message translates to:
  /// **'Star icon for Premium plan'**
  String get profilePage_premiumPlanStarIconSemanticLabel;

  /// No description provided for @profilePage_freePlanCheckIconSemanticLabel.
  ///
  /// In en, this message translates to:
  /// **'Check icon for Free plan'**
  String get profilePage_freePlanCheckIconSemanticLabel;

  /// No description provided for @profilePage_premiumPlan.
  ///
  /// In en, this message translates to:
  /// **'Premium Plan'**
  String get profilePage_premiumPlan;

  /// No description provided for @profilePage_freePlan.
  ///
  /// In en, this message translates to:
  /// **'Free Plan'**
  String get profilePage_freePlan;

  /// No description provided for @profilePage_premiumPlanDescription.
  ///
  /// In en, this message translates to:
  /// **'You have access to all features.'**
  String get profilePage_premiumPlanDescription;

  /// No description provided for @profilePage_freePlanDescription.
  ///
  /// In en, this message translates to:
  /// **'Access more features by upgrading.'**
  String get profilePage_freePlanDescription;

  /// No description provided for @profilePage_upgrade.
  ///
  /// In en, this message translates to:
  /// **'Upgrade'**
  String get profilePage_upgrade;

  /// No description provided for @profilePage_quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get profilePage_quickActions;

  /// No description provided for @profilePage_editIconSemanticLabel.
  ///
  /// In en, this message translates to:
  /// **'Pencil icon'**
  String get profilePage_editIconSemanticLabel;

  /// No description provided for @profilePage_editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get profilePage_editProfile;

  /// No description provided for @profilePage_historyIconSemanticLabel.
  ///
  /// In en, this message translates to:
  /// **'Clock icon'**
  String get profilePage_historyIconSemanticLabel;

  /// No description provided for @profilePage_viewResumeHistory.
  ///
  /// In en, this message translates to:
  /// **'View Resume History'**
  String get profilePage_viewResumeHistory;

  /// No description provided for @profilePage_settingsIconSemanticLabel.
  ///
  /// In en, this message translates to:
  /// **'Gear icon'**
  String get profilePage_settingsIconSemanticLabel;

  /// No description provided for @profilePage_settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get profilePage_settings;

  /// No description provided for @aiAssistant_freePlanLimitReached.
  ///
  /// In en, this message translates to:
  /// **'AI interaction limit reached on free plan.'**
  String get aiAssistant_freePlanLimitReached;

  /// No description provided for @aiAssistant_emptyResumeWarning.
  ///
  /// In en, this message translates to:
  /// **'Your resume is empty. Add content to use AI.'**
  String get aiAssistant_emptyResumeWarning;

  /// No description provided for @aiAssistant_recruitmentExpertPrompt.
  ///
  /// In en, this message translates to:
  /// **'You are a recruitment expert. Analyze the following resume:\n\n{resumeContent}'**
  String aiAssistant_recruitmentExpertPrompt(Object resumeContent);

  /// No description provided for @aiAssistant_errorContactingAI.
  ///
  /// In en, this message translates to:
  /// **'An error occurred contacting AI: {error}'**
  String aiAssistant_errorContactingAI(Object error);

  /// No description provided for @aiAssistant_translate.
  ///
  /// In en, this message translates to:
  /// **'Translate'**
  String get aiAssistant_translate;

  /// No description provided for @aiAssistant_strengthsAndWeaknesses.
  ///
  /// In en, this message translates to:
  /// **'Strengths and Weaknesses'**
  String get aiAssistant_strengthsAndWeaknesses;

  /// No description provided for @aiAssistant_spellCheck.
  ///
  /// In en, this message translates to:
  /// **'Spell Check'**
  String get aiAssistant_spellCheck;

  /// No description provided for @aiAssistant_generateResume.
  ///
  /// In en, this message translates to:
  /// **'Generate resume'**
  String get aiAssistant_generateResume;

  /// No description provided for @aiAssistant_expand.
  ///
  /// In en, this message translates to:
  /// **'Expand'**
  String get aiAssistant_expand;

  /// No description provided for @aiAssistant_emptyResumePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Your resume is empty. Add sections and content to see it here.'**
  String get aiAssistant_emptyResumePlaceholder;

  /// No description provided for @cvCard_draft.
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get cvCard_draft;

  /// No description provided for @cvCard_editResume.
  ///
  /// In en, this message translates to:
  /// **'Edit resume'**
  String get cvCard_editResume;

  /// No description provided for @cvCard_deleteResume.
  ///
  /// In en, this message translates to:
  /// **'Delete resume'**
  String get cvCard_deleteResume;

  /// No description provided for @cvCard_createdOn.
  ///
  /// In en, this message translates to:
  /// **'Created on: {date}'**
  String cvCard_createdOn(Object date);

  /// No description provided for @cvCard_evaluation.
  ///
  /// In en, this message translates to:
  /// **'Evaluation: {evaluation}'**
  String cvCard_evaluation(Object evaluation);

  /// No description provided for @cvCard_translation.
  ///
  /// In en, this message translates to:
  /// **'Translation: {translation}'**
  String cvCard_translation(Object translation);

  /// No description provided for @cvCard_corrections.
  ///
  /// In en, this message translates to:
  /// **'Corrections: {count}'**
  String cvCard_corrections(Object count);

  /// No description provided for @resumeForm_aboutMeTab.
  ///
  /// In en, this message translates to:
  /// **'About Me'**
  String get resumeForm_aboutMeTab;

  /// No description provided for @resumeForm_objectiveTab.
  ///
  /// In en, this message translates to:
  /// **'Objective'**
  String get resumeForm_objectiveTab;

  /// No description provided for @resumeForm_experienceTab.
  ///
  /// In en, this message translates to:
  /// **'Experience'**
  String get resumeForm_experienceTab;

  /// No description provided for @resumeForm_educationTab.
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get resumeForm_educationTab;

  /// No description provided for @resumeForm_skillsTab.
  ///
  /// In en, this message translates to:
  /// **'Skills'**
  String get resumeForm_skillsTab;

  /// No description provided for @resumeForm_socialTab.
  ///
  /// In en, this message translates to:
  /// **'Social'**
  String get resumeForm_socialTab;

  /// No description provided for @resumeForm_projectsTab.
  ///
  /// In en, this message translates to:
  /// **'Projects'**
  String get resumeForm_projectsTab;

  /// No description provided for @resumeForm_certificatesTab.
  ///
  /// In en, this message translates to:
  /// **'Certificates'**
  String get resumeForm_certificatesTab;

  /// No description provided for @resumeForm_accessibilityTab.
  ///
  /// In en, this message translates to:
  /// **'Accessibility'**
  String get resumeForm_accessibilityTab;

  /// No description provided for @resumeForm_previous.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get resumeForm_previous;

  /// No description provided for @resumeForm_next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get resumeForm_next;

  /// No description provided for @resumeForm_itemCount.
  ///
  /// In en, this message translates to:
  /// **'{itemLabel} {currentIndex} of {totalItems}'**
  String resumeForm_itemCount(
    Object currentIndex,
    Object itemLabel,
    Object totalItems,
  );

  /// No description provided for @resumeForm_professionalObjective.
  ///
  /// In en, this message translates to:
  /// **'Professional Objective'**
  String get resumeForm_professionalObjective;

  /// No description provided for @resumeForm_training.
  ///
  /// In en, this message translates to:
  /// **'Training'**
  String get resumeForm_training;

  /// No description provided for @resumeForm_skill.
  ///
  /// In en, this message translates to:
  /// **'Skill'**
  String get resumeForm_skill;

  /// No description provided for @resumeForm_socialLink.
  ///
  /// In en, this message translates to:
  /// **'Social Link'**
  String get resumeForm_socialLink;

  /// No description provided for @resumeForm_project.
  ///
  /// In en, this message translates to:
  /// **'Project'**
  String get resumeForm_project;

  /// No description provided for @resumeForm_certificate.
  ///
  /// In en, this message translates to:
  /// **'Certificate'**
  String get resumeForm_certificate;

  /// No description provided for @resumeForm_accessibilitySettings.
  ///
  /// In en, this message translates to:
  /// **'Accessibility Settings'**
  String get resumeForm_accessibilitySettings;

  /// No description provided for @resumeForm_includePCDInfo.
  ///
  /// In en, this message translates to:
  /// **'Include disability info in the resume'**
  String get resumeForm_includePCDInfo;

  /// No description provided for @resumeForm_includePCDInfoSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Select to include disability information from your profile in the resume.'**
  String get resumeForm_includePCDInfoSubtitle;

  /// No description provided for @resumeForm_fillYourResume.
  ///
  /// In en, this message translates to:
  /// **'Fill your resume'**
  String get resumeForm_fillYourResume;

  /// No description provided for @resumeForm_noItemAdded.
  ///
  /// In en, this message translates to:
  /// **'No {itemLabel} added.'**
  String resumeForm_noItemAdded(Object itemLabel);

  /// No description provided for @resumeForm_add.
  ///
  /// In en, this message translates to:
  /// **'Add New {itemLabel}'**
  String resumeForm_add(Object itemLabel);

  /// No description provided for @resumeForm_removeCurrent.
  ///
  /// In en, this message translates to:
  /// **'Remove Current {itemLabel}'**
  String resumeForm_removeCurrent(Object itemLabel);

  /// No description provided for @languageSelector_selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language:'**
  String get languageSelector_selectLanguage;

  /// No description provided for @languageSelector_english.
  ///
  /// In en, this message translates to:
  /// **'🇺🇸 English'**
  String get languageSelector_english;

  /// No description provided for @languageSelector_spanish.
  ///
  /// In en, this message translates to:
  /// **'🇪🇸 Spanish'**
  String get languageSelector_spanish;

  /// No description provided for @languageSelector_french.
  ///
  /// In en, this message translates to:
  /// **'🇫🇷 French'**
  String get languageSelector_french;

  /// No description provided for @languageSelector_german.
  ///
  /// In en, this message translates to:
  /// **'🇩🇪 German'**
  String get languageSelector_german;

  /// No description provided for @layoutTemplate_appTitle.
  ///
  /// In en, this message translates to:
  /// **'IntelliResume'**
  String get layoutTemplate_appTitle;

  /// No description provided for @layoutTemplate_openNavigationMenu.
  ///
  /// In en, this message translates to:
  /// **'Open navigation menu'**
  String get layoutTemplate_openNavigationMenu;

  /// No description provided for @aboutMeForm_save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get aboutMeForm_save;

  /// No description provided for @aboutMeForm_removeAboutMe.
  ///
  /// In en, this message translates to:
  /// **'Remove About Me'**
  String get aboutMeForm_removeAboutMe;

  /// No description provided for @heroTitle.
  ///
  /// In en, this message translates to:
  /// **'Build your resume with intelligence!'**
  String get heroTitle;

  /// No description provided for @heroSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Use AI to build, translate, and improve your resume based on the desired country.'**
  String get heroSubtitle;

  /// No description provided for @heroCTA.
  ///
  /// In en, this message translates to:
  /// **'Try it now'**
  String get heroCTA;

  /// No description provided for @heroLogoSemanticLabel.
  ///
  /// In en, this message translates to:
  /// **'IntelliResume Logo'**
  String get heroLogoSemanticLabel;

  /// No description provided for @webLandingPage_logoSemanticLabel.
  ///
  /// In en, this message translates to:
  /// **'IntelliResume Logo'**
  String get webLandingPage_logoSemanticLabel;

  /// No description provided for @webLandingPage_openAccessibilityMenuSemanticLabel.
  ///
  /// In en, this message translates to:
  /// **'Open accessibility and settings menu'**
  String get webLandingPage_openAccessibilityMenuSemanticLabel;

  /// No description provided for @webLandingPage_accessibilityTooltip.
  ///
  /// In en, this message translates to:
  /// **'Settings and Accessibility'**
  String get webLandingPage_accessibilityTooltip;

  /// No description provided for @webLandingPage_aboutButton.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get webLandingPage_aboutButton;

  /// No description provided for @webLandingPage_featuresButton.
  ///
  /// In en, this message translates to:
  /// **'Features'**
  String get webLandingPage_featuresButton;

  /// No description provided for @webLandingPage_plansButton.
  ///
  /// In en, this message translates to:
  /// **'Plans'**
  String get webLandingPage_plansButton;

  /// No description provided for @webLandingPage_contactButton.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get webLandingPage_contactButton;

  /// No description provided for @webLandingPage_loginButtonSemanticLabel.
  ///
  /// In en, this message translates to:
  /// **'Go to login page'**
  String get webLandingPage_loginButtonSemanticLabel;

  /// No description provided for @webLandingPage_loginButton.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get webLandingPage_loginButton;

  /// No description provided for @webLandingPage_signUpAndBuyButton.
  ///
  /// In en, this message translates to:
  /// **'Sign Up and Buy'**
  String get webLandingPage_signUpAndBuyButton;

  /// No description provided for @webLandingPage_scrollToSectionSemanticLabel.
  ///
  /// In en, this message translates to:
  /// **'Go to section {label}'**
  String webLandingPage_scrollToSectionSemanticLabel(Object label);

  /// No description provided for @webLandingPage_accessibilityDrawerTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings and Accessibility'**
  String get webLandingPage_accessibilityDrawerTitle;

  /// No description provided for @webLandingPage_visualAdjustmentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Visual Adjustments'**
  String get webLandingPage_visualAdjustmentsTitle;

  /// No description provided for @webLandingPage_highContrast.
  ///
  /// In en, this message translates to:
  /// **'High Contrast'**
  String get webLandingPage_highContrast;

  /// No description provided for @webLandingPage_boldText.
  ///
  /// In en, this message translates to:
  /// **'Bold Text'**
  String get webLandingPage_boldText;

  /// No description provided for @webLandingPage_fontSize.
  ///
  /// In en, this message translates to:
  /// **'Font Size'**
  String get webLandingPage_fontSize;

  /// No description provided for @webLandingPage_fontScale.
  ///
  /// In en, this message translates to:
  /// **'Scale: {scale}x'**
  String webLandingPage_fontScale(Object scale);

  /// No description provided for @webLandingPage_languageAndRegionTitle.
  ///
  /// In en, this message translates to:
  /// **'Language and Region'**
  String get webLandingPage_languageAndRegionTitle;

  /// No description provided for @webLandingPage_portuguese.
  ///
  /// In en, this message translates to:
  /// **'🇧🇷 Portuguese (Brazil)'**
  String get webLandingPage_portuguese;

  /// No description provided for @webLandingPage_english.
  ///
  /// In en, this message translates to:
  /// **'🇺🇸 English'**
  String get webLandingPage_english;

  /// No description provided for @webLandingPage_additionalFeaturesTitle.
  ///
  /// In en, this message translates to:
  /// **'Additional Features'**
  String get webLandingPage_additionalFeaturesTitle;

  /// No description provided for @webLandingPage_librasVersion.
  ///
  /// In en, this message translates to:
  /// **'Libras Version (VLibras)'**
  String get webLandingPage_librasVersion;

  /// No description provided for @pricing_featureIncluded.
  ///
  /// In en, this message translates to:
  /// **'Feature included'**
  String get pricing_featureIncluded;

  /// No description provided for @pricing_yourCurrentPlan.
  ///
  /// In en, this message translates to:
  /// **'Your Current Plan'**
  String get pricing_yourCurrentPlan;

  /// No description provided for @pricing_upgrade.
  ///
  /// In en, this message translates to:
  /// **'Upgrade'**
  String get pricing_upgrade;

  /// No description provided for @pricing_notAvailable.
  ///
  /// In en, this message translates to:
  /// **'Not Available'**
  String get pricing_notAvailable;

  /// No description provided for @demoSection_title.
  ///
  /// In en, this message translates to:
  /// **'See IntelliResume in Action'**
  String get demoSection_title;

  /// No description provided for @demoSection_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Discover how our platform can transform your resume.'**
  String get demoSection_subtitle;

  /// No description provided for @demoSection_text.
  ///
  /// In en, this message translates to:
  /// **'Watch a quick demonstration of IntelliResume\'s powerful features. From AI-powered suggestions to professional templates, see how easy it is to create a standout resume.'**
  String get demoSection_text;

  /// No description provided for @demoSection_cta.
  ///
  /// In en, this message translates to:
  /// **'Watch Demo'**
  String get demoSection_cta;

  /// No description provided for @demoSection_ctaSemanticLabel.
  ///
  /// In en, this message translates to:
  /// **'Watch a demonstration video of IntelliResume'**
  String get demoSection_ctaSemanticLabel;

  /// No description provided for @demoSection_mockupPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'App Mockup Placeholder'**
  String get demoSection_mockupPlaceholder;

  /// No description provided for @testimonialsSection_title.
  ///
  /// In en, this message translates to:
  /// **'What Our Users Say'**
  String get testimonialsSection_title;

  /// No description provided for @testimonialsSection_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Success stories that inspire us.'**
  String get testimonialsSection_subtitle;

  /// No description provided for @ctaSection_title.
  ///
  /// In en, this message translates to:
  /// **'Stand out in the market with a real resume.'**
  String get ctaSection_title;

  /// No description provided for @ctaSection_button.
  ///
  /// In en, this message translates to:
  /// **'Create My Resume Now'**
  String get ctaSection_button;

  /// No description provided for @ctaSection_buttonSemanticLabel.
  ///
  /// In en, this message translates to:
  /// **'Create your resume now button'**
  String get ctaSection_buttonSemanticLabel;

  /// No description provided for @featuresSection_title.
  ///
  /// In en, this message translates to:
  /// **'Intelligent Features'**
  String get featuresSection_title;

  /// No description provided for @featuresSection_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Everything you need to create a standout resume in minutes.'**
  String get featuresSection_subtitle;

  /// No description provided for @feature_aiEvaluation_title.
  ///
  /// In en, this message translates to:
  /// **'AI-Powered Evaluation'**
  String get feature_aiEvaluation_title;

  /// No description provided for @feature_aiEvaluation_description.
  ///
  /// In en, this message translates to:
  /// **'Get suggestions to make your resume more impactful and professional.'**
  String get feature_aiEvaluation_description;

  /// No description provided for @feature_autoTranslation_title.
  ///
  /// In en, this message translates to:
  /// **'Automatic Translation'**
  String get feature_autoTranslation_title;

  /// No description provided for @feature_autoTranslation_description.
  ///
  /// In en, this message translates to:
  /// **'Adapt your resume for international jobs with translation into multiple languages.'**
  String get feature_autoTranslation_description;

  /// No description provided for @feature_spellCheck_title.
  ///
  /// In en, this message translates to:
  /// **'Spell Check'**
  String get feature_spellCheck_title;

  /// No description provided for @feature_spellCheck_description.
  ///
  /// In en, this message translates to:
  /// **'Avoid grammatical errors that could cost you an opportunity. We review it for you.'**
  String get feature_spellCheck_description;

  /// No description provided for @feature_professionalTemplates_title.
  ///
  /// In en, this message translates to:
  /// **'Professional Templates'**
  String get feature_professionalTemplates_title;

  /// No description provided for @feature_professionalTemplates_description.
  ///
  /// In en, this message translates to:
  /// **'Choose from dozens of free and premium templates created by experts.'**
  String get feature_professionalTemplates_description;

  /// No description provided for @feature_studioMode_title.
  ///
  /// In en, this message translates to:
  /// **'Studio Mode (Pro)'**
  String get feature_studioMode_title;

  /// No description provided for @feature_studioMode_description.
  ///
  /// In en, this message translates to:
  /// **'Customize colors, fonts, and layouts to create a truly unique resume.'**
  String get feature_studioMode_description;

  /// No description provided for @feature_easyExport_title.
  ///
  /// In en, this message translates to:
  /// **'Easy Export'**
  String get feature_easyExport_title;

  /// No description provided for @feature_easyExport_description.
  ///
  /// In en, this message translates to:
  /// **'Export your resume in high-quality PDF format, ready to be sent.'**
  String get feature_easyExport_description;

  /// No description provided for @headerSection_nameNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Name not available'**
  String get headerSection_nameNotAvailable;

  /// No description provided for @headerSection_contactNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Email not available | Phone not available'**
  String get headerSection_contactNotAvailable;

  /// No description provided for @headerSection_profilePictureSemanticLabel.
  ///
  /// In en, this message translates to:
  /// **'Profile picture of {userName}'**
  String headerSection_profilePictureSemanticLabel(Object userName);

  /// No description provided for @resumePreview_defaultResumeTitle.
  ///
  /// In en, this message translates to:
  /// **'Resume of {userName}'**
  String resumePreview_defaultResumeTitle(Object userName);

  /// No description provided for @resumePreview_sectionEditSemanticLabel.
  ///
  /// In en, this message translates to:
  /// **'Section of {sectionTitle}, tap to edit the content of this section'**
  String resumePreview_sectionEditSemanticLabel(Object sectionTitle);

  /// No description provided for @resumePreview_skillEditSemanticLabel.
  ///
  /// In en, this message translates to:
  /// **'Skill: {skillName}, level {skillLevel}. Tap to edit.'**
  String resumePreview_skillEditSemanticLabel(
    Object skillLevel,
    Object skillName,
  );

  /// No description provided for @resumePreview_socialLinkEditSemanticLabel.
  ///
  /// In en, this message translates to:
  /// **'Social link: {platform}. Tap to edit.'**
  String resumePreview_socialLinkEditSemanticLabel(Object platform);

  /// No description provided for @error_data_source.
  ///
  /// In en, this message translates to:
  /// **'A data source error occurred.'**
  String get error_data_source;

  /// No description provided for @error_not_found.
  ///
  /// In en, this message translates to:
  /// **'The requested item was not found.'**
  String get error_not_found;

  /// No description provided for @error_resume_not_found.
  ///
  /// In en, this message translates to:
  /// **'Resume with ID {resumeId} not found.'**
  String error_resume_not_found(Object resumeId);

  /// No description provided for @error_auth_user_not_found.
  ///
  /// In en, this message translates to:
  /// **'No user found for that email.'**
  String get error_auth_user_not_found;

  /// No description provided for @error_auth_wrong_password.
  ///
  /// In en, this message translates to:
  /// **'Wrong password provided for that user.'**
  String get error_auth_wrong_password;

  /// No description provided for @error_auth_invalid_email.
  ///
  /// In en, this message translates to:
  /// **'The email address is badly formatted.'**
  String get error_auth_invalid_email;

  /// No description provided for @error_auth_generic.
  ///
  /// In en, this message translates to:
  /// **'An authentication error occurred.'**
  String get error_auth_generic;

  /// No description provided for @error_signup_failed.
  ///
  /// In en, this message translates to:
  /// **'Failed to create user account.'**
  String get error_signup_failed;

  /// No description provided for @error_ai_service.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while communicating with the AI service.'**
  String get error_ai_service;

  /// No description provided for @error_ai_translation.
  ///
  /// In en, this message translates to:
  /// **'Failed to translate content.'**
  String get error_ai_translation;

  /// No description provided for @error_ai_correction.
  ///
  /// In en, this message translates to:
  /// **'Failed to correct content.'**
  String get error_ai_correction;

  /// No description provided for @error_ai_evaluation.
  ///
  /// In en, this message translates to:
  /// **'Failed to evaluate content.'**
  String get error_ai_evaluation;

  /// No description provided for @error_image_upload.
  ///
  /// In en, this message translates to:
  /// **'Failed to upload image.'**
  String get error_image_upload;

  /// No description provided for @error_payment_unauthenticated.
  ///
  /// In en, this message translates to:
  /// **'User not authenticated. Please log in to continue.'**
  String get error_payment_unauthenticated;

  /// No description provided for @error_payment_generic.
  ///
  /// In en, this message translates to:
  /// **'An error occurred while processing the payment.'**
  String get error_payment_generic;

  /// No description provided for @error_payment_data_fetch.
  ///
  /// In en, this message translates to:
  /// **'Failed to get payment data from the server.'**
  String get error_payment_data_fetch;

  /// No description provided for @error_payment_url.
  ///
  /// In en, this message translates to:
  /// **'Could not get payment URL.'**
  String get error_payment_url;

  /// No description provided for @error_payment_launch_url.
  ///
  /// In en, this message translates to:
  /// **'Could not open payment URL.'**
  String get error_payment_launch_url;

  /// No description provided for @error_payment_server.
  ///
  /// In en, this message translates to:
  /// **'A server error occurred during payment.'**
  String get error_payment_server;

  /// No description provided for @error_payment_cancelled.
  ///
  /// In en, this message translates to:
  /// **'Payment was cancelled by the user.'**
  String get error_payment_cancelled;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
