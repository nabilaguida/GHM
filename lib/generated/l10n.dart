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

  /// `Hello`
  String get hello {
    return Intl.message(
      'Hello',
      name: 'hello',
      desc: '',
      args: [],
    );
  }

  /// `Welcome to GHM App`
  String get welcome {
    return Intl.message(
      'Welcome to GHM App',
      name: 'welcome',
      desc: '',
      args: [],
    );
  }

  /// `Sign up to access our services`
  String get signup_message {
    return Intl.message(
      'Sign up to access our services',
      name: 'signup_message',
      desc: '',
      args: [],
    );
  }

  /// `Get Started`
  String get get_started {
    return Intl.message(
      'Get Started',
      name: 'get_started',
      desc: '',
      args: [],
    );
  }

  /// `Glad you're here!`
  String get glad_youre_here {
    return Intl.message(
      'Glad you\'re here!',
      name: 'glad_youre_here',
      desc: '',
      args: [],
    );
  }

  /// `Let's get you logged in.`
  String get lets_get_you_logged_in {
    return Intl.message(
      'Let\'s get you logged in.',
      name: 'lets_get_you_logged_in',
      desc: '',
      args: [],
    );
  }

  /// `Enter your Phone Number`
  String get enter_your_phone_number {
    return Intl.message(
      'Enter your Phone Number',
      name: 'enter_your_phone_number',
      desc: '',
      args: [],
    );
  }

  /// `Continue`
  String get continue_ {
    return Intl.message(
      'Continue',
      name: 'continue_',
      desc: '',
      args: [],
    );
  }

  /// `Phone number`
  String get phone_Number {
    return Intl.message(
      'Phone number',
      name: 'phone_Number',
      desc: '',
      args: [],
    );
  }

  /// `Having trouble? `
  String get having_trouble {
    return Intl.message(
      'Having trouble? ',
      name: 'having_trouble',
      desc: '',
      args: [],
    );
  }

  /// `help`
  String get help {
    return Intl.message(
      'help',
      name: 'help',
      desc: '',
      args: [],
    );
  }

  /// `Next Step.`
  String get NextStep {
    return Intl.message(
      'Next Step.',
      name: 'NextStep',
      desc: '',
      args: [],
    );
  }

  /// `Enter the OTP code Sent to`
  String get EnterOTPSentTo {
    return Intl.message(
      'Enter the OTP code Sent to',
      name: 'EnterOTPSentTo',
      desc: '',
      args: [],
    );
  }

  /// `Resend code`
  String get ResendCode {
    return Intl.message(
      'Resend code',
      name: 'ResendCode',
      desc: '',
      args: [],
    );
  }

  /// `Verify`
  String get Verify {
    return Intl.message(
      'Verify',
      name: 'Verify',
      desc: '',
      args: [],
    );
  }

  /// `haven't recieved the code?\n`
  String get HavenTReceivedCode {
    return Intl.message(
      'haven\'t recieved the code?\n',
      name: 'HavenTReceivedCode',
      desc: '',
      args: [],
    );
  }

  /// `Last Step`
  String get last_step {
    return Intl.message(
      'Last Step',
      name: 'last_step',
      desc: '',
      args: [],
    );
  }

  /// `Full your information and complete signup`
  String get complete_signup {
    return Intl.message(
      'Full your information and complete signup',
      name: 'complete_signup',
      desc: '',
      args: [],
    );
  }

  /// `Enter your full name`
  String get enter_full_name {
    return Intl.message(
      'Enter your full name',
      name: 'enter_full_name',
      desc: '',
      args: [],
    );
  }

  /// `Enter your location`
  String get enter_location {
    return Intl.message(
      'Enter your location',
      name: 'enter_location',
      desc: '',
      args: [],
    );
  }

  /// `Full Name`
  String get full_name {
    return Intl.message(
      'Full Name',
      name: 'full_name',
      desc: '',
      args: [],
    );
  }

  /// `Address`
  String get address {
    return Intl.message(
      'Address',
      name: 'address',
      desc: '',
      args: [],
    );
  }

  /// `welcome`
  String get welcome_word {
    return Intl.message(
      'welcome',
      name: 'welcome_word',
      desc: '',
      args: [],
    );
  }

  /// `My Orders`
  String get My_orders {
    return Intl.message(
      'My Orders',
      name: 'My_orders',
      desc: '',
      args: [],
    );
  }

  /// `Coming Soon`
  String get Coming_Soon {
    return Intl.message(
      'Coming Soon',
      name: 'Coming_Soon',
      desc: '',
      args: [],
    );
  }

  /// `Recent activities`
  String get Recent_activities {
    return Intl.message(
      'Recent activities',
      name: 'Recent_activities',
      desc: '',
      args: [],
    );
  }

  /// `See All`
  String get See_All {
    return Intl.message(
      'See All',
      name: 'See_All',
      desc: '',
      args: [],
    );
  }

  /// `Available Services`
  String get Available_Services {
    return Intl.message(
      'Available Services',
      name: 'Available_Services',
      desc: '',
      args: [],
    );
  }

  /// `Pending`
  String get pending_status {
    return Intl.message(
      'Pending',
      name: 'pending_status',
      desc: '',
      args: [],
    );
  }

  /// `Ongoing`
  String get ongoing_status {
    return Intl.message(
      'Ongoing',
      name: 'ongoing_status',
      desc: '',
      args: [],
    );
  }

  /// `Completed`
  String get completed_status {
    return Intl.message(
      'Completed',
      name: 'completed_status',
      desc: '',
      args: [],
    );
  }

  /// `Canceled`
  String get canceled_status {
    return Intl.message(
      'Canceled',
      name: 'canceled_status',
      desc: '',
      args: [],
    );
  }

  /// `Order title`
  String get order_title {
    return Intl.message(
      'Order title',
      name: 'order_title',
      desc: '',
      args: [],
    );
  }

  /// `Please fill the form and submit your order.`
  String get fill_the_order_form {
    return Intl.message(
      'Please fill the form and submit your order.',
      name: 'fill_the_order_form',
      desc: '',
      args: [],
    );
  }

  /// `Chose sub-category`
  String get chose_subcategory {
    return Intl.message(
      'Chose sub-category',
      name: 'chose_subcategory',
      desc: '',
      args: [],
    );
  }

  /// `Order description`
  String get order_description {
    return Intl.message(
      'Order description',
      name: 'order_description',
      desc: '',
      args: [],
    );
  }

  /// `Phone Number (Optional)`
  String get phone_number_optional {
    return Intl.message(
      'Phone Number (Optional)',
      name: 'phone_number_optional',
      desc: '',
      args: [],
    );
  }

  /// `Chose the order type`
  String get chose_order_type {
    return Intl.message(
      'Chose the order type',
      name: 'chose_order_type',
      desc: '',
      args: [],
    );
  }

  /// `Urgent`
  String get urgent {
    return Intl.message(
      'Urgent',
      name: 'urgent',
      desc: '',
      args: [],
    );
  }

  /// `Regular`
  String get regular {
    return Intl.message(
      'Regular',
      name: 'regular',
      desc: '',
      args: [],
    );
  }

  /// `Upload relevant images if possible.(Max=3)`
  String get upload_images {
    return Intl.message(
      'Upload relevant images if possible.(Max=3)',
      name: 'upload_images',
      desc: '',
      args: [],
    );
  }

  /// `Submit Order`
  String get submit_order {
    return Intl.message(
      'Submit Order',
      name: 'submit_order',
      desc: '',
      args: [],
    );
  }

  /// `Or`
  String get or {
    return Intl.message(
      'Or',
      name: 'or',
      desc: '',
      args: [],
    );
  }

  /// `Contact us on Whatsapp`
  String get contact_us_on_whatsapp {
    return Intl.message(
      'Contact us on Whatsapp',
      name: 'contact_us_on_whatsapp',
      desc: '',
      args: [],
    );
  }

  /// `Hello this is `
  String get whatsapp_category_01 {
    return Intl.message(
      'Hello this is ',
      name: 'whatsapp_category_01',
      desc: '',
      args: [],
    );
  }

  /// `from the app Green House Maintenance. I think i need some help in:`
  String get whatsapp_category_02 {
    return Intl.message(
      'from the app Green House Maintenance. I think i need some help in:',
      name: 'whatsapp_category_02',
      desc: '',
      args: [],
    );
  }

  /// `You already picked 3 images`
  String get You_already_picked_images {
    return Intl.message(
      'You already picked 3 images',
      name: 'You_already_picked_images',
      desc: '',
      args: [],
    );
  }

  /// `Image Preview`
  String get Image_Preview {
    return Intl.message(
      'Image Preview',
      name: 'Image_Preview',
      desc: '',
      args: [],
    );
  }

  /// `Ongoing orders`
  String get Ongoing_orders {
    return Intl.message(
      'Ongoing orders',
      name: 'Ongoing_orders',
      desc: '',
      args: [],
    );
  }

  /// `Completed orders`
  String get Completed_orders {
    return Intl.message(
      'Completed orders',
      name: 'Completed_orders',
      desc: '',
      args: [],
    );
  }

  /// `Check Status`
  String get Check_Status {
    return Intl.message(
      'Check Status',
      name: 'Check_Status',
      desc: '',
      args: [],
    );
  }

  /// `Order pics`
  String get Order_pics {
    return Intl.message(
      'Order pics',
      name: 'Order_pics',
      desc: '',
      args: [],
    );
  }

  /// `Date Posted`
  String get Date_Posted {
    return Intl.message(
      'Date Posted',
      name: 'Date_Posted',
      desc: '',
      args: [],
    );
  }

  /// `Cancel Order`
  String get Cancel_Order {
    return Intl.message(
      'Cancel Order',
      name: 'Cancel_Order',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get Settings {
    return Intl.message(
      'Settings',
      name: 'Settings',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get Profile {
    return Intl.message(
      'Profile',
      name: 'Profile',
      desc: '',
      args: [],
    );
  }

  /// `Save Changes`
  String get Save_Changes {
    return Intl.message(
      'Save Changes',
      name: 'Save_Changes',
      desc: '',
      args: [],
    );
  }

  /// `Edit Profile`
  String get Edit_Profile {
    return Intl.message(
      'Edit Profile',
      name: 'Edit_Profile',
      desc: '',
      args: [],
    );
  }

  /// `Account Settings`
  String get Account_Settings {
    return Intl.message(
      'Account Settings',
      name: 'Account_Settings',
      desc: '',
      args: [],
    );
  }

  /// `Done`
  String get done {
    return Intl.message(
      'Done',
      name: 'done',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get Language {
    return Intl.message(
      'Language',
      name: 'Language',
      desc: '',
      args: [],
    );
  }

  /// `LogOut`
  String get LogOut {
    return Intl.message(
      'LogOut',
      name: 'LogOut',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid OTP`
  String get Please_enter_a_valid_OTP {
    return Intl.message(
      'Please enter a valid OTP',
      name: 'Please_enter_a_valid_OTP',
      desc: '',
      args: [],
    );
  }

  /// `Oops Something Went Wrong`
  String get Oops_Something_Went_Wrong {
    return Intl.message(
      'Oops Something Went Wrong',
      name: 'Oops_Something_Went_Wrong',
      desc: '',
      args: [],
    );
  }

  /// `Order created successfully`
  String get Order_created_successfully {
    return Intl.message(
      'Order created successfully',
      name: 'Order_created_successfully',
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
      Locale.fromSubtags(languageCode: 'ar'),
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
