// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Hello!`
  String get hello {
    return Intl.message('Hello!', name: 'hello', desc: '', args: []);
  }

  /// `Login`
  String get login {
    return Intl.message('Login', name: 'login', desc: '', args: []);
  }

  /// `Verify OTP`
  String get verifyOtp {
    return Intl.message('Verify OTP', name: 'verifyOtp', desc: '', args: []);
  }

  /// `Shree Satyavish Variya Gol Prajapati Samaj`
  String get welcomeToApp {
    return Intl.message(
      'Shree Satyavish Variya Gol Prajapati Samaj',
      name: 'welcomeToApp',
      desc: '',
      args: [],
    );
  }

  /// `Change Language`
  String get changeLanguage {
    return Intl.message(
      'Change Language',
      name: 'changeLanguage',
      desc: '',
      args: [],
    );
  }

  /// `English`
  String get english {
    return Intl.message('English', name: 'english', desc: '', args: []);
  }

  /// `Gujarati`
  String get gujarati {
    return Intl.message('Gujarati', name: 'gujarati', desc: '', args: []);
  }

  /// `Hindi`
  String get hindi {
    return Intl.message('Hindi', name: 'hindi', desc: '', args: []);
  }

  /// `Login now!`
  String get loginNow {
    return Intl.message('Login now!', name: 'loginNow', desc: '', args: []);
  }

  /// `Phone Number`
  String get phoneNumber {
    return Intl.message(
      'Phone Number',
      name: 'phoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Continue`
  String get continueAction {
    return Intl.message('Continue', name: 'continueAction', desc: '', args: []);
  }

  /// `Or`
  String get or {
    return Intl.message('Or', name: 'or', desc: '', args: []);
  }

  /// `Finish signing up`
  String get finishSigningUp {
    return Intl.message(
      'Finish signing up',
      name: 'finishSigningUp',
      desc: '',
      args: [],
    );
  }

  /// `First name on ID`
  String get firstNameOnId {
    return Intl.message(
      'First name on ID',
      name: 'firstNameOnId',
      desc: '',
      args: [],
    );
  }

  /// `Last name on ID`
  String get lastNameOnId {
    return Intl.message(
      'Last name on ID',
      name: 'lastNameOnId',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message('Email', name: 'email', desc: '', args: []);
  }

  /// `Date of birth`
  String get dateOfBirth {
    return Intl.message(
      'Date of birth',
      name: 'dateOfBirth',
      desc: '',
      args: [],
    );
  }

  /// `I read and agreed to User Agreement and privacy policy`
  String get iReadAndAgreed {
    return Intl.message(
      'I read and agreed to User Agreement and privacy policy',
      name: 'iReadAndAgreed',
      desc: '',
      args: [],
    );
  }

  /// `Sign Up`
  String get signUp {
    return Intl.message('Sign Up', name: 'signUp', desc: '', args: []);
  }

  /// `Enter OTP`
  String get enterOtp {
    return Intl.message('Enter OTP', name: 'enterOtp', desc: '', args: []);
  }

  /// `Resend OTP`
  String get resendOtp {
    return Intl.message('Resend OTP', name: 'resendOtp', desc: '', args: []);
  }

  /// `Profile`
  String get profile {
    return Intl.message('Profile', name: 'profile', desc: '', args: []);
  }

  /// `Hey {name}`
  String hey(Object name) {
    return Intl.message('Hey $name', name: 'hey', desc: '', args: [name]);
  }

  /// `Home`
  String get home {
    return Intl.message('Home', name: 'home', desc: '', args: []);
  }

  /// `Community`
  String get community {
    return Intl.message('Community', name: 'community', desc: '', args: []);
  }

  /// `Messages`
  String get messages {
    return Intl.message('Messages', name: 'messages', desc: '', args: []);
  }

  /// `Settings`
  String get settings {
    return Intl.message('Settings', name: 'settings', desc: '', args: []);
  }

  /// `Get Started`
  String get getStarted {
    return Intl.message('Get Started', name: 'getStarted', desc: '', args: []);
  }

  /// `Advertise`
  String get advertise {
    return Intl.message('Advertise', name: 'advertise', desc: '', args: []);
  }

  /// `News`
  String get news {
    return Intl.message('News', name: 'news', desc: '', args: []);
  }

  /// `Gallery`
  String get gallery {
    return Intl.message('Gallery', name: 'gallery', desc: '', args: []);
  }

  /// `Upcoming Events`
  String get upcomingEvents {
    return Intl.message(
      'Upcoming Events',
      name: 'upcomingEvents',
      desc: '',
      args: [],
    );
  }

  /// `Please enter full name`
  String get pleaseEnterFullName {
    return Intl.message(
      'Please enter full name',
      name: 'pleaseEnterFullName',
      desc: '',
      args: [],
    );
  }

  /// `Please enter phone number`
  String get pleaseEnterPhoneNumber {
    return Intl.message(
      'Please enter phone number',
      name: 'pleaseEnterPhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Please enter valid phone number`
  String get pleaseEnterValidPhoneNumber {
    return Intl.message(
      'Please enter valid phone number',
      name: 'pleaseEnterValidPhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Please enter email`
  String get pleaseEnterEmail {
    return Intl.message(
      'Please enter email',
      name: 'pleaseEnterEmail',
      desc: '',
      args: [],
    );
  }

  /// `Please enter valid email`
  String get pleaseEnterValidEmail {
    return Intl.message(
      'Please enter valid email',
      name: 'pleaseEnterValidEmail',
      desc: '',
      args: [],
    );
  }

  /// `Please enter OTP`
  String get pleaseEnterOtp {
    return Intl.message(
      'Please enter OTP',
      name: 'pleaseEnterOtp',
      desc: '',
      args: [],
    );
  }

  /// `Please agree to terms and conditions`
  String get pleaseAgreeToTermsAndConditions {
    return Intl.message(
      'Please agree to terms and conditions',
      name: 'pleaseAgreeToTermsAndConditions',
      desc: '',
      args: [],
    );
  }

  /// `We'll call or text you to confirm your number`
  String get weWillTextYouToConfirmYourNumber {
    return Intl.message(
      'We\'ll call or text you to confirm your number',
      name: 'weWillTextYouToConfirmYourNumber',
      desc: '',
      args: [],
    );
  }

  /// `Pragati Mandal List`
  String get pragatiMandalList {
    return Intl.message(
      'Pragati Mandal List',
      name: 'pragatiMandalList',
      desc: '',
      args: [],
    );
  }

  /// `Shikshan Samiti List`
  String get shikshanSamitiList {
    return Intl.message(
      'Shikshan Samiti List',
      name: 'shikshanSamitiList',
      desc: '',
      args: [],
    );
  }

  /// `Samuh Lagna Samiti List`
  String get samuhLagnaSamitiList {
    return Intl.message(
      'Samuh Lagna Samiti List',
      name: 'samuhLagnaSamitiList',
      desc: '',
      args: [],
    );
  }

  /// `Mahila Mandal Samiti List`
  String get mahilaMandalSamitiList {
    return Intl.message(
      'Mahila Mandal Samiti List',
      name: 'mahilaMandalSamitiList',
      desc: '',
      args: [],
    );
  }

  /// `Village List`
  String get villageList {
    return Intl.message(
      'Village List',
      name: 'villageList',
      desc: '',
      args: [],
    );
  }

  /// `Error`
  String get error {
    return Intl.message('Error', name: 'error', desc: '', args: []);
  }

  /// `Add Member`
  String get addMember {
    return Intl.message('Add Member', name: 'addMember', desc: '', args: []);
  }

  /// `Edit Member`
  String get editMember {
    return Intl.message('Edit Member', name: 'editMember', desc: '', args: []);
  }

  /// `My Members`
  String get myMembers {
    return Intl.message('My Members', name: 'myMembers', desc: '', args: []);
  }

  /// `First Name`
  String get firstName {
    return Intl.message('First Name', name: 'firstName', desc: '', args: []);
  }

  /// `Enter first name`
  String get enterFirstName {
    return Intl.message(
      'Enter first name',
      name: 'enterFirstName',
      desc: '',
      args: [],
    );
  }

  /// `Middle Name`
  String get middleName {
    return Intl.message('Middle Name', name: 'middleName', desc: '', args: []);
  }

  /// `Enter middle name`
  String get enterMiddleName {
    return Intl.message(
      'Enter middle name',
      name: 'enterMiddleName',
      desc: '',
      args: [],
    );
  }

  /// `Surname`
  String get surname {
    return Intl.message('Surname', name: 'surname', desc: '', args: []);
  }

  /// `Enter surname`
  String get enterSurname {
    return Intl.message(
      'Enter surname',
      name: 'enterSurname',
      desc: '',
      args: [],
    );
  }

  /// `Required`
  String get requiredField {
    return Intl.message('Required', name: 'requiredField', desc: '', args: []);
  }

  /// `Gender`
  String get gender {
    return Intl.message('Gender', name: 'gender', desc: '', args: []);
  }

  /// `Village`
  String get village {
    return Intl.message('Village', name: 'village', desc: '', args: []);
  }

  /// `Doing Job?`
  String get doingJobQuestion {
    return Intl.message(
      'Doing Job?',
      name: 'doingJobQuestion',
      desc: '',
      args: [],
    );
  }

  /// `Job Type`
  String get jobType {
    return Intl.message('Job Type', name: 'jobType', desc: '', args: []);
  }

  /// `Private`
  String get privateJob {
    return Intl.message('Private', name: 'privateJob', desc: '', args: []);
  }

  /// `Government`
  String get governmentJob {
    return Intl.message(
      'Government',
      name: 'governmentJob',
      desc: '',
      args: [],
    );
  }

  /// `Education`
  String get education {
    return Intl.message('Education', name: 'education', desc: '', args: []);
  }

  /// `SSC School`
  String get sscSchool {
    return Intl.message('SSC School', name: 'sscSchool', desc: '', args: []);
  }

  /// `Enter SSC school`
  String get enterSscSchool {
    return Intl.message(
      'Enter SSC school',
      name: 'enterSscSchool',
      desc: '',
      args: [],
    );
  }

  /// `SSC Percentage`
  String get sscPercentage {
    return Intl.message(
      'SSC Percentage',
      name: 'sscPercentage',
      desc: '',
      args: [],
    );
  }

  /// `HSC School`
  String get hscSchool {
    return Intl.message('HSC School', name: 'hscSchool', desc: '', args: []);
  }

  /// `Enter HSC school`
  String get enterHscSchool {
    return Intl.message(
      'Enter HSC school',
      name: 'enterHscSchool',
      desc: '',
      args: [],
    );
  }

  /// `HSC Percentage`
  String get hscPercentage {
    return Intl.message(
      'HSC Percentage',
      name: 'hscPercentage',
      desc: '',
      args: [],
    );
  }

  /// `Bachelor Degree`
  String get bachelorDegree {
    return Intl.message(
      'Bachelor Degree',
      name: 'bachelorDegree',
      desc: '',
      args: [],
    );
  }

  /// `Enter bachelor degree`
  String get enterBachelorDegree {
    return Intl.message(
      'Enter bachelor degree',
      name: 'enterBachelorDegree',
      desc: '',
      args: [],
    );
  }

  /// `Bachelor Percentage`
  String get bachelorPercentage {
    return Intl.message(
      'Bachelor Percentage',
      name: 'bachelorPercentage',
      desc: '',
      args: [],
    );
  }

  /// `Master Degree`
  String get masterDegree {
    return Intl.message(
      'Master Degree',
      name: 'masterDegree',
      desc: '',
      args: [],
    );
  }

  /// `Enter master degree`
  String get enterMasterDegree {
    return Intl.message(
      'Enter master degree',
      name: 'enterMasterDegree',
      desc: '',
      args: [],
    );
  }

  /// `Master Percentage`
  String get masterPercentage {
    return Intl.message(
      'Master Percentage',
      name: 'masterPercentage',
      desc: '',
      args: [],
    );
  }

  /// `e.g. 72%`
  String get examplePercentage {
    return Intl.message(
      'e.g. 72%',
      name: 'examplePercentage',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message('Save', name: 'save', desc: '', args: []);
  }

  /// `Large image`
  String get largeImageWarningTitle {
    return Intl.message(
      'Large image',
      name: 'largeImageWarningTitle',
      desc: '',
      args: [],
    );
  }

  /// `The selected image is large and will be sent as base64 which may increase upload size. Continue?`
  String get largeImageWarningMessage {
    return Intl.message(
      'The selected image is large and will be sent as base64 which may increase upload size. Continue?',
      name: 'largeImageWarningMessage',
      desc: '',
      args: [],
    );
  }

  /// `Continue`
  String get continueText {
    return Intl.message('Continue', name: 'continueText', desc: '', args: []);
  }

  /// `Uploading...`
  String get uploading {
    return Intl.message('Uploading...', name: 'uploading', desc: '', args: []);
  }

  /// `Profile image (optional)`
  String get profileImageOptional {
    return Intl.message(
      'Profile image (optional)',
      name: 'profileImageOptional',
      desc: '',
      args: [],
    );
  }

  /// `Age`
  String get age {
    return Intl.message('Age', name: 'age', desc: '', args: []);
  }

  /// `Marital Status`
  String get maritalStatus {
    return Intl.message(
      'Marital Status',
      name: 'maritalStatus',
      desc: '',
      args: [],
    );
  }

  /// `Single`
  String get single {
    return Intl.message('Single', name: 'single', desc: '', args: []);
  }

  /// `Married`
  String get married {
    return Intl.message('Married', name: 'married', desc: '', args: []);
  }

  /// `Widowed`
  String get widowed {
    return Intl.message('Widowed', name: 'widowed', desc: '', args: []);
  }

  /// `Guest mode`
  String get guestMode {
    return Intl.message('Guest mode', name: 'guestMode', desc: '', args: []);
  }

  /// `Login required`
  String get loginPromptTitle {
    return Intl.message(
      'Login required',
      name: 'loginPromptTitle',
      desc: '',
      args: [],
    );
  }

  /// `You need to login to access this feature.`
  String get loginPromptMessage {
    return Intl.message(
      'You need to login to access this feature.',
      name: 'loginPromptMessage',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get loginPromptCancel {
    return Intl.message(
      'Cancel',
      name: 'loginPromptCancel',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get loginPromptOk {
    return Intl.message('Login', name: 'loginPromptOk', desc: '', args: []);
  }

  /// `Logout`
  String get logout {
    return Intl.message('Logout', name: 'logout', desc: '', args: []);
  }

  /// `Are you sure you want to logout?`
  String get areYouSureYouWantToLogout {
    return Intl.message(
      'Are you sure you want to logout?',
      name: 'areYouSureYouWantToLogout',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `Edit Profile`
  String get editProfile {
    return Intl.message(
      'Edit Profile',
      name: 'editProfile',
      desc: '',
      args: [],
    );
  }

  /// `Full name`
  String get fullName {
    return Intl.message('Full name', name: 'fullName', desc: '', args: []);
  }

  /// `Mobile`
  String get mobile {
    return Intl.message('Mobile', name: 'mobile', desc: '', args: []);
  }

  /// `(Optional)`
  String get optionalBrace {
    return Intl.message(
      '(Optional)',
      name: 'optionalBrace',
      desc: '',
      args: [],
    );
  }

  /// `Share App`
  String get shareApp {
    return Intl.message('Share App', name: 'shareApp', desc: '', args: []);
  }

  /// `Rate App`
  String get rateApp {
    return Intl.message('Rate App', name: 'rateApp', desc: '', args: []);
  }

  /// `Privacy Policy`
  String get privacyPolicy {
    return Intl.message(
      'Privacy Policy',
      name: 'privacyPolicy',
      desc: '',
      args: [],
    );
  }

  /// `Terms & Conditions`
  String get termsConditions {
    return Intl.message(
      'Terms & Conditions',
      name: 'termsConditions',
      desc: '',
      args: [],
    );
  }

  /// `Version {version} (Build {build})`
  String versionText(Object version, Object build) {
    return Intl.message(
      'Version $version (Build $build)',
      name: 'versionText',
      desc: '',
      args: [version, build],
    );
  }

  /// `© 2026 Samaj Community. All rights reserved.`
  String get copyrightText {
    return Intl.message(
      '© 2026 Samaj Community. All rights reserved.',
      name: 'copyrightText',
      desc: '',
      args: [],
    );
  }

  /// `Delete Account`
  String get deleteAccount {
    return Intl.message(
      'Delete Account',
      name: 'deleteAccount',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to permanently delete your account? This action cannot be undone, and your registered member profile will be deactivated.`
  String get deleteAccountConfirm {
    return Intl.message(
      'Are you sure you want to permanently delete your account? This action cannot be undone, and your registered member profile will be deactivated.',
      name: 'deleteAccountConfirm',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get deleteText {
    return Intl.message('Delete', name: 'deleteText', desc: '', args: []);
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'gu'),
      Locale.fromSubtags(languageCode: 'hi'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
