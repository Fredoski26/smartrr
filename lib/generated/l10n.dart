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
// ignore_for_file: avoid_redundant_argument_values

class S {
  S();
  
  static S current;
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name); 
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      S.current = S();
      
      return S.current;
    });
  } 

  static S of(BuildContext context) {
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
      desc: 'Enter the email address associated with your Amrt RR account aand we will send a reset password link',
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

  /// `DOB`
  String get dob {
    return Intl.message(
      'DOB',
      name: 'dob',
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

  /// `All About SRHR`
  String get allAboutSRHR {
    return Intl.message(
      'All About SRHR',
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

  /// `Report for`
  String get reportFor {
    return Intl.message(
      'Report for',
      name: 'reportFor',
      desc: '',
      args: [],
    );
  }

  /// `Yourself`
  String get yourself {
    return Intl.message(
      'Yourself',
      name: 'yourself',
      desc: '',
      args: [],
    );
  }

  /// `Someone Else`
  String get someoneElse {
    return Intl.message(
      'Someone Else',
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

  /// `Select LGA`
  String get selectLGA {
    return Intl.message(
      'Select LGA',
      name: 'selectLGA',
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

  /// `Sexual Exploitation`
  String get sexualExploitation {
    return Intl.message(
      'Sexual Exploitation',
      name: 'sexualExploitation',
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

  /// `Accept Terms & Conditions`
  String get acceptTerms {
    return Intl.message(
      'Accept Terms & Conditions',
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

  /// `Smart Reporting and Referral (SMART RR) is a technology based mobile application that allows survivors, social workers and service providers to report and refer cases/incidents of GBV from their smart and basic phones. The tool was developed by Big Family 360 Foundation, a national non-governmental organisation in Nigeria.\n\nSmart RR application is a technology based mobile application which enables survivors, social workers and service providers to report and refer GBV incidents to relevant service providers and authorities, conducts service mapping, automatically updates referral directory, collects and analyses referral data. This idea was built on the existing referral mechanism of the GBV Sub Sector which is done manually.\n\n`
  String get aboutSmartrrData {
    return Intl.message(
      'Smart Reporting and Referral (SMART RR) is a technology based mobile application that allows survivors, social workers and service providers to report and refer cases/incidents of GBV from their smart and basic phones. The tool was developed by Big Family 360 Foundation, a national non-governmental organisation in Nigeria.\n\nSmart RR application is a technology based mobile application which enables survivors, social workers and service providers to report and refer GBV incidents to relevant service providers and authorities, conducts service mapping, automatically updates referral directory, collects and analyses referral data. This idea was built on the existing referral mechanism of the GBV Sub Sector which is done manually.\n\n',
      name: 'aboutSmartrrData',
      desc: '',
      args: [],
    );
  }

  /// `I understand that in giving  my  authorization below,  I  am giving  permission to  share  the  specific  case  information from  my  incident report with the  service  provider(s)  I  have indicated, so  that I  can  receive  help  with safety,  health, psychosocial, and/or  legal  needs.    I  understand that shared information will  be  treated with confidentiality  and respect, and shared  only as  needed to  provide  the  assistance  I  request. I  understand that releasing  this  information means  that a  person from  the  agency  or  service  selected below may  come  to  talk to  me.   At any  point, I  have  the  right to  change  my  mind about sharing information with the  designated agency/focal  point listed below.`
  String get consentFormData {
    return Intl.message(
      'I understand that in giving  my  authorization below,  I  am giving  permission to  share  the  specific  case  information from  my  incident report with the  service  provider(s)  I  have indicated, so  that I  can  receive  help  with safety,  health, psychosocial, and/or  legal  needs.    I  understand that shared information will  be  treated with confidentiality  and respect, and shared  only as  needed to  provide  the  assistance  I  request. I  understand that releasing  this  information means  that a  person from  the  agency  or  service  selected below may  come  to  talk to  me.   At any  point, I  have  the  right to  change  my  mind about sharing information with the  designated agency/focal  point listed below.',
      name: 'consentFormData',
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
    if (locale != null) {
      for (var supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}