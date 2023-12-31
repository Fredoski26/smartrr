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
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
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
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `User`
  String get user {
    return Intl.message(
      'User',
      name: 'user',
      desc: '',
      args: [],
    );
  }

  /// `Organization`
  String get organization {
    return Intl.message(
      'Organization',
      name: 'organization',
      desc: '',
      args: [],
    );
  }

  /// `Don't have an account?`
  String get dontHaveAccount {
    return Intl.message(
      'Don\'t have an account?',
      name: 'dontHaveAccount',
      desc: '',
      args: [],
    );
  }

  /// `SignUp`
  String get signUp {
    return Intl.message(
      'SignUp',
      name: 'signUp',
      desc: '',
      args: [],
    );
  }

  /// `Forgot password?`
  String get forgotPassword {
    return Intl.message(
      'Forgot password?',
      name: 'forgotPassword',
      desc: '',
      args: [],
    );
  }

  /// `Enter the email address associated with your Smart RR account and we will send a reset password link`
  String get forgotPasswordDescription {
    return Intl.message(
      'Enter the email address associated with your Smart RR account and we will send a reset password link',
      name: 'forgotPasswordDescription',
      desc: '',
      args: [],
    );
  }

  /// `Reset Password`
  String get resetPassword {
    return Intl.message(
      'Reset Password',
      name: 'resetPassword',
      desc: '',
      args: [],
    );
  }

  /// `Send reset link`
  String get sendResetLink {
    return Intl.message(
      'Send reset link',
      name: 'sendResetLink',
      desc: '',
      args: [],
    );
  }

  /// `Reset Here`
  String get resetHere {
    return Intl.message(
      'Reset Here',
      name: 'resetHere',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get logIn {
    return Intl.message(
      'Login',
      name: 'logIn',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message(
      'Name',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `Date of birth`
  String get dob {
    return Intl.message(
      'Date of birth',
      name: 'dob',
      desc: '',
      args: [],
    );
  }

  /// `Age`
  String get age {
    return Intl.message(
      'Age',
      name: 'age',
      desc: '',
      args: [],
    );
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

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Location`
  String get location {
    return Intl.message(
      'Location',
      name: 'location',
      desc: '',
      args: [],
    );
  }

  /// `Gender`
  String get gender {
    return Intl.message(
      'Gender',
      name: 'gender',
      desc: '',
      args: [],
    );
  }

  /// `Male`
  String get male {
    return Intl.message(
      'Male',
      name: 'male',
      desc: '',
      args: [],
    );
  }

  /// `Female`
  String get female {
    return Intl.message(
      'Female',
      name: 'female',
      desc: '',
      args: [],
    );
  }

  /// `Already have an account?`
  String get alreadyHaveAnAccount {
    return Intl.message(
      'Already have an account?',
      name: 'alreadyHaveAnAccount',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get language {
    return Intl.message(
      'Language',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// `Report a case`
  String get reportACase {
    return Intl.message(
      'Report a case',
      name: 'reportACase',
      desc: '',
      args: [],
    );
  }

  /// `SRH/FGM`
  String get allAboutSRHR {
    return Intl.message(
      'SRH/FGM',
      name: 'allAboutSRHR',
      desc: '',
      args: [],
    );
  }

  /// `Impact of Smart RR`
  String get impactOfSmartRR {
    return Intl.message(
      'Impact of Smart RR',
      name: 'impactOfSmartRR',
      desc: '',
      args: [],
    );
  }

  /// `About Smart RR`
  String get aboutSmartRR {
    return Intl.message(
      'About Smart RR',
      name: 'aboutSmartRR',
      desc: '',
      args: [],
    );
  }

  /// `History`
  String get history {
    return Intl.message(
      'History',
      name: 'history',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `Log Out`
  String get logOut {
    return Intl.message(
      'Log Out',
      name: 'logOut',
      desc: '',
      args: [],
    );
  }

  /// `Country`
  String get country {
    return Intl.message(
      'Country',
      name: 'country',
      desc: '',
      args: [],
    );
  }

  /// `Change Password`
  String get changePassword {
    return Intl.message(
      'Change Password',
      name: 'changePassword',
      desc: '',
      args: [],
    );
  }

  /// `Confirm password`
  String get confirmPassword {
    return Intl.message(
      'Confirm password',
      name: 'confirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `Report for`
  String get reportFor {
    return Intl.message(
      'Report for',
      name: 'reportFor',
      desc: '',
      args: [],
    );
  }

  /// `For Yourself`
  String get yourself {
    return Intl.message(
      'For Yourself',
      name: 'yourself',
      desc: '',
      args: [],
    );
  }

  /// `For Someone Else`
  String get someoneElse {
    return Intl.message(
      'For Someone Else',
      name: 'someoneElse',
      desc: '',
      args: [],
    );
  }

  /// `Select Service Type`
  String get selectService {
    return Intl.message(
      'Select Service Type',
      name: 'selectService',
      desc: '',
      args: [],
    );
  }

  /// `Select Custom Location`
  String get selectCustomLocation {
    return Intl.message(
      'Select Custom Location',
      name: 'selectCustomLocation',
      desc: '',
      args: [],
    );
  }

  /// `Select State`
  String get selectState {
    return Intl.message(
      'Select State',
      name: 'selectState',
      desc: '',
      args: [],
    );
  }

  /// `Select Location`
  String get selectLocation {
    return Intl.message(
      'Select Location',
      name: 'selectLocation',
      desc: '',
      args: [],
    );
  }

  /// `Select Service Provider`
  String get selectServiceProvider {
    return Intl.message(
      'Select Service Provider',
      name: 'selectServiceProvider',
      desc: '',
      args: [],
    );
  }

  /// `Select Case Description`
  String get selectCaseDescription {
    return Intl.message(
      'Select Case Description',
      name: 'selectCaseDescription',
      desc: '',
      args: [],
    );
  }

  /// `Female Genital Mutilation`
  String get fgm {
    return Intl.message(
      'Female Genital Mutilation',
      name: 'fgm',
      desc: '',
      args: [],
    );
  }

  /// `Rape`
  String get rape {
    return Intl.message(
      'Rape',
      name: 'rape',
      desc: '',
      args: [],
    );
  }

  /// `Sexual Abuse`
  String get sexualAbuse {
    return Intl.message(
      'Sexual Abuse',
      name: 'sexualAbuse',
      desc: '',
      args: [],
    );
  }

  /// `Emotional Abuse`
  String get psychologicalOrEmotionalAbuse {
    return Intl.message(
      'Emotional Abuse',
      name: 'psychologicalOrEmotionalAbuse',
      desc: '',
      args: [],
    );
  }

  /// `Forced / Child Marriage `
  String get forcedMarriage {
    return Intl.message(
      'Forced / Child Marriage ',
      name: 'forcedMarriage',
      desc: '',
      args: [],
    );
  }

  /// `Denial of Resources`
  String get denialOfResources {
    return Intl.message(
      'Denial of Resources',
      name: 'denialOfResources',
      desc: '',
      args: [],
    );
  }

  /// `Sexual Reproductive Kits`
  String get sexualReproductiveKits {
    return Intl.message(
      'Sexual Reproductive Kits',
      name: 'sexualReproductiveKits',
      desc: '',
      args: [],
    );
  }

  /// `Submit Report`
  String get submitReport {
    return Intl.message(
      'Submit Report',
      name: 'submitReport',
      desc: '',
      args: [],
    );
  }

  /// `Physical Abuse`
  String get physicalAbuse {
    return Intl.message(
      'Physical Abuse',
      name: 'physicalAbuse',
      desc: '',
      args: [],
    );
  }

  /// `Case Registered Successfully`
  String get caseRegisteredSuccesfully {
    return Intl.message(
      'Case Registered Successfully',
      name: 'caseRegisteredSuccesfully',
      desc: '',
      args: [],
    );
  }

  /// `Please check your internet connection`
  String get badInternet {
    return Intl.message(
      'Please check your internet connection',
      name: 'badInternet',
      desc: '',
      args: [],
    );
  }

  /// `Please select a description`
  String get selectDescription {
    return Intl.message(
      'Please select a description',
      name: 'selectDescription',
      desc: '',
      args: [],
    );
  }

  /// `Select One`
  String get selectOne {
    return Intl.message(
      'Select One',
      name: 'selectOne',
      desc: '',
      args: [],
    );
  }

  /// `Case Type`
  String get caseType {
    return Intl.message(
      'Case Type',
      name: 'caseType',
      desc: '',
      args: [],
    );
  }

  /// `Consent Form`
  String get consentForm {
    return Intl.message(
      'Consent Form',
      name: 'consentForm',
      desc: '',
      args: [],
    );
  }

  /// `Proceed`
  String get proceed {
    return Intl.message(
      'Proceed',
      name: 'proceed',
      desc: '',
      args: [],
    );
  }

  /// `I Accept`
  String get accept {
    return Intl.message(
      'I Accept',
      name: 'accept',
      desc: '',
      args: [],
    );
  }

  /// `I accept all terms & conditions`
  String get acceptTerms {
    return Intl.message(
      'I accept all terms & conditions',
      name: 'acceptTerms',
      desc: '',
      args: [],
    );
  }

  /// `Please accept Terms & Conditions`
  String get pleaseAcceptTerms {
    return Intl.message(
      'Please accept Terms & Conditions',
      name: 'pleaseAcceptTerms',
      desc: '',
      args: [],
    );
  }

  /// `Read more`
  String get readMore {
    return Intl.message(
      'Read more',
      name: 'readMore',
      desc: '',
      args: [],
    );
  }

  /// `More`
  String get more {
    return Intl.message(
      'More',
      name: 'more',
      desc: '',
      args: [],
    );
  }

  /// `Dark mode`
  String get darkMode {
    return Intl.message(
      'Dark mode',
      name: 'darkMode',
      desc: '',
      args: [],
    );
  }

  /// `Update`
  String get update {
    return Intl.message(
      'Update',
      name: 'update',
      desc: '',
      args: [],
    );
  }

  /// `Select country`
  String get selectCountry {
    return Intl.message(
      'Select country',
      name: 'selectCountry',
      desc: '',
      args: [],
    );
  }

  /// `Interview with`
  String get interviewWith {
    return Intl.message(
      'Interview with',
      name: 'interviewWith',
      desc: '',
      args: [],
    );
  }

  /// `Click to read`
  String get clickToRead {
    return Intl.message(
      'Click to read',
      name: 'clickToRead',
      desc: '',
      args: [],
    );
  }

  /// `Shop`
  String get shop {
    return Intl.message(
      'Shop',
      name: 'shop',
      desc: '',
      args: [],
    );
  }

  /// `coming soon`
  String get comingSoon {
    return Intl.message(
      'coming soon',
      name: 'comingSoon',
      desc: '',
      args: [],
    );
  }

  /// `Period Tacker & Calendar`
  String get periodTracker {
    return Intl.message(
      'Period Tacker & Calendar',
      name: 'periodTracker',
      desc: '',
      args: [],
    );
  }

  /// `Request OTP`
  String get requestOTP {
    return Intl.message(
      'Request OTP',
      name: 'requestOTP',
      desc: '',
      args: [],
    );
  }

  /// `Smart Reporting and Referral (SMART RR) is a technology based mobile application that allows survivors, social workers and service providers to report and refer cases/incidents of GBV from their smart and basic phones. The tool was developed by Big Family 360 Foundation, a national non-governmental organisation in Nigeria.\n\nSmart RR application is a technology based mobile application which enables survivors, social workers and service providers to report and refer GBV incidents to relevant service providers and authorities, conducts service mapping, automatically updates referral directory, collects and analyses referral data. This idea was built on the existing referral mechanism of the GBV Sub Sector which is done manually.`
  String get aboutSmartrrData {
    return Intl.message(
      'Smart Reporting and Referral (SMART RR) is a technology based mobile application that allows survivors, social workers and service providers to report and refer cases/incidents of GBV from their smart and basic phones. The tool was developed by Big Family 360 Foundation, a national non-governmental organisation in Nigeria.\n\nSmart RR application is a technology based mobile application which enables survivors, social workers and service providers to report and refer GBV incidents to relevant service providers and authorities, conducts service mapping, automatically updates referral directory, collects and analyses referral data. This idea was built on the existing referral mechanism of the GBV Sub Sector which is done manually.',
      name: 'aboutSmartrrData',
      desc: '',
      args: [],
    );
  }

  /// `I understand that in giving  my  authorization below,  I  am giving  permission to  share  the  specific  case  information from  my  incident report with the  service  provider(s)  I  have indicated, so  that I  can  receive  help  with safety,  health, psychosocial, and/or  legal  needs. I understand that shared information will  be  treated with confidentiality  and respect, and shared  only as  needed to  provide  the  assistance  I  request. I  understand that releasing  this  information means  that a  person from  the  agency  or  service  selected below may  come  to  talk to  me.   At any  point, I  have  the  right to  change  my  mind about sharing information with the  designated agency/focal  point listed below.`
  String get consentFormData {
    return Intl.message(
      'I understand that in giving  my  authorization below,  I  am giving  permission to  share  the  specific  case  information from  my  incident report with the  service  provider(s)  I  have indicated, so  that I  can  receive  help  with safety,  health, psychosocial, and/or  legal  needs. I understand that shared information will  be  treated with confidentiality  and respect, and shared  only as  needed to  provide  the  assistance  I  request. I  understand that releasing  this  information means  that a  person from  the  agency  or  service  selected below may  come  to  talk to  me.   At any  point, I  have  the  right to  change  my  mind about sharing information with the  designated agency/focal  point listed below.',
      name: 'consentFormData',
      desc: '',
      args: [],
    );
  }

  /// `Sexual Reproductive Health and Rights (SRHR) Contents.`
  String get srhrHeading1 {
    return Intl.message(
      'Sexual Reproductive Health and Rights (SRHR) Contents.',
      name: 'srhrHeading1',
      desc: '',
      args: [],
    );
  }

  /// `Young girls and women  are viewed as too youthful to even think about approaching sexuality schooling and family planning or in any event, discussing it, yet in many spots and around us they are getting hitched, getting pregnant, conceiving an offspring and are moms.`
  String get srhrParagraph1 {
    return Intl.message(
      'Young girls and women  are viewed as too youthful to even think about approaching sexuality schooling and family planning or in any event, discussing it, yet in many spots and around us they are getting hitched, getting pregnant, conceiving an offspring and are moms.',
      name: 'srhrParagraph1',
      desc: '',
      args: [],
    );
  }

  /// `Key definitions of Sexual Reproductive Health and Rights components.`
  String get srhrHeading2 {
    return Intl.message(
      'Key definitions of Sexual Reproductive Health and Rights components.',
      name: 'srhrHeading2',
      desc: '',
      args: [],
    );
  }

  /// `key messages.`
  String get srhrHeading3 {
    return Intl.message(
      'key messages.',
      name: 'srhrHeading3',
      desc: '',
      args: [],
    );
  }

  /// `Access to modern contraception and reproductive health, including access to safe abortion, is an essential aspect of gender equality, economic development, humanitarian response and progress for all.`
  String get srhrParagraph2 {
    return Intl.message(
      'Access to modern contraception and reproductive health, including access to safe abortion, is an essential aspect of gender equality, economic development, humanitarian response and progress for all.',
      name: 'srhrParagraph2',
      desc: '',
      args: [],
    );
  }

  /// `For a girl or a woman to reach their greatest potential, they must have control over their sexual and reproductive lives.`
  String get srhrParagraph3 {
    return Intl.message(
      'For a girl or a woman to reach their greatest potential, they must have control over their sexual and reproductive lives.',
      name: 'srhrParagraph3',
      desc: '',
      args: [],
    );
  }

  /// `Gender equality can be achieved when women and girls  sexual health and rights are respected,protected, and accessed.`
  String get srhrParagraph4 {
    return Intl.message(
      'Gender equality can be achieved when women and girls  sexual health and rights are respected,protected, and accessed.',
      name: 'srhrParagraph4',
      desc: '',
      args: [],
    );
  }

  /// `A world without fear, stigma, or discrimination drives equality and progress for all.`
  String get srhrParagraph5 {
    return Intl.message(
      'A world without fear, stigma, or discrimination drives equality and progress for all.',
      name: 'srhrParagraph5',
      desc: '',
      args: [],
    );
  }

  /// `To fulfill women and girls Sexual Reproductive Health and Rights (SRHR), adolescents and women in reproductive age must have the knowledge, skills, and tools needed to make safe and informed decisions.`
  String get srhrParagraph6 {
    return Intl.message(
      'To fulfill women and girls Sexual Reproductive Health and Rights (SRHR), adolescents and women in reproductive age must have the knowledge, skills, and tools needed to make safe and informed decisions.',
      name: 'srhrParagraph6',
      desc: '',
      args: [],
    );
  }

  /// `Sexual Reproductive Health and Rights Definitions.`
  String get srhrHeading4 {
    return Intl.message(
      'Sexual Reproductive Health and Rights Definitions.',
      name: 'srhrHeading4',
      desc: '',
      args: [],
    );
  }

  /// `Sexual Health (SH):`
  String get srhrDefinition1Title {
    return Intl.message(
      'Sexual Health (SH):',
      name: 'srhrDefinition1Title',
      desc: '',
      args: [],
    );
  }

  /// `Is a state of physical, emotional,  mental, and social wellbeing in relation to sexual feelings, considerations, attractions and practices towards others Sexuality. It encompasses the possibility of pleasurable and safe sexual experiences, free of coercion, discrimination and violence. For sexual health to be attained and maintained, the sexual rights of all persons must be respected, protected, and fulfilled.`
  String get srhrDefinition1Body {
    return Intl.message(
      'Is a state of physical, emotional,  mental, and social wellbeing in relation to sexual feelings, considerations, attractions and practices towards others Sexuality. It encompasses the possibility of pleasurable and safe sexual experiences, free of coercion, discrimination and violence. For sexual health to be attained and maintained, the sexual rights of all persons must be respected, protected, and fulfilled.',
      name: 'srhrDefinition1Body',
      desc: '',
      args: [],
    );
  }

  /// `Sexual health include:`
  String get srhrDefinition1SubList1Title {
    return Intl.message(
      'Sexual health include:',
      name: 'srhrDefinition1SubList1Title',
      desc: '',
      args: [],
    );
  }

  /// `Counselling and care related to sexuality, sexual identity, and sexual relationships.`
  String get srhrDefinition1SubList1Item1 {
    return Intl.message(
      'Counselling and care related to sexuality, sexual identity, and sexual relationships.',
      name: 'srhrDefinition1SubList1Item1',
      desc: '',
      args: [],
    );
  }

  /// `Prevention and management of sexually transmitted infections (STIs).`
  String get srhrDefinition1SubList1Item2 {
    return Intl.message(
      'Prevention and management of sexually transmitted infections (STIs).',
      name: 'srhrDefinition1SubList1Item2',
      desc: '',
      args: [],
    );
  }

  /// `Psychosexual counselling, and treatment for sexual dysfunction and disorders.`
  String get srhrDefinition1SubList1Item3 {
    return Intl.message(
      'Psychosexual counselling, and treatment for sexual dysfunction and disorders.',
      name: 'srhrDefinition1SubList1Item3',
      desc: '',
      args: [],
    );
  }

  /// `Sexuality:`
  String get srhrDefinition2Title {
    return Intl.message(
      'Sexuality:',
      name: 'srhrDefinition2Title',
      desc: '',
      args: [],
    );
  }

  /// `sexual feelings, considerations, attractions and practices towards others Sexuality.`
  String get srhrDefinition2Body {
    return Intl.message(
      'sexual feelings, considerations, attractions and practices towards others Sexuality.',
      name: 'srhrDefinition2Body',
      desc: '',
      args: [],
    );
  }

  /// `Reproductive Health(RH):`
  String get srhrDefinition3Title {
    return Intl.message(
      'Reproductive Health(RH):',
      name: 'srhrDefinition3Title',
      desc: '',
      args: [],
    );
  }

  /// `Reproductive health is a state of complete physical, mental, and social wellbeing, and not merely the absence of disease or infirmity, in all matters relating to the reproductive system and to its functions and processes.\n\nReproductive health means  people are able to have a satisfying and safe sex life, and that they have the capability to reproduce and the freedom to decide if, when, and how often to do so.`
  String get srhrDefinition3Body {
    return Intl.message(
      'Reproductive health is a state of complete physical, mental, and social wellbeing, and not merely the absence of disease or infirmity, in all matters relating to the reproductive system and to its functions and processes.\n\nReproductive health means  people are able to have a satisfying and safe sex life, and that they have the capability to reproduce and the freedom to decide if, when, and how often to do so.',
      name: 'srhrDefinition3Body',
      desc: '',
      args: [],
    );
  }

  /// `Watch`
  String get watch {
    return Intl.message(
      'Watch',
      name: 'watch',
      desc: '',
      args: [],
    );
  }

  /// `Read`
  String get read {
    return Intl.message(
      'Read',
      name: 'read',
      desc: '',
      args: [],
    );
  }

  /// `new`
  String get new_ {
    return Intl.message(
      'new',
      name: 'new_',
      desc: '',
      args: [],
    );
  }

  /// `Buy Products`
  String get buyPoducts {
    return Intl.message(
      'Buy Products',
      name: 'buyPoducts',
      desc: '',
      args: [],
    );
  }

  /// `Orders`
  String get orders {
    return Intl.message(
      'Orders',
      name: 'orders',
      desc: '',
      args: [],
    );
  }

  /// `Welcome`
  String get welcome {
    return Intl.message(
      'Welcome',
      name: 'welcome',
      desc: '',
      args: [],
    );
  }

  /// `How may we help you today`
  String get howMayWeHelpYouToday {
    return Intl.message(
      'How may we help you today',
      name: 'howMayWeHelpYouToday',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ha'),
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
