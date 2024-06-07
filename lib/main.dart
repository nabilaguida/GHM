import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:greenhousemaintenance/providers/AuthProvider.dart';
import 'package:greenhousemaintenance/providers/categoriesProvider.dart';
import 'package:greenhousemaintenance/providers/localProvider.dart';
import 'package:greenhousemaintenance/providers/orderProvider.dart';
import 'package:greenhousemaintenance/screens/Orders/orderCreation.dart';
import 'package:greenhousemaintenance/screens/adminSide/adminHomeScreen.dart';
import 'package:greenhousemaintenance/screens/auth/onboardingscreen.dart';
import 'package:greenhousemaintenance/screens/home_screen.dart';
import 'package:greenhousemaintenance/utils/thems.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'firebase_options.dart';
import 'generated/l10n.dart';
import 'dart:ui';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.playIntegrity,
    appleProvider: AppleProvider.appAttest,
  );



  await Supabase.initialize(
    url: 'https://uiguuucagmlszbzkghks.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVpZ3V1dWNhZ21sc3piemtnaGtzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTUyOTQ5NzYsImV4cCI6MjAzMDg3MDk3Nn0.OFAcooyO6NiMjdd3RBBb6J_ApuEApzi2o6ew1dWhrTY',
    realtimeClientOptions: const RealtimeClientOptions(
      logLevel: RealtimeLogLevel.info,
    ),
  );

  LocalProvider localProvider = LocalProvider() ;
  await localProvider.getStoredLocal();
  if(localProvider.local == ''){
    await localProvider.setLocal(window.locale.languageCode);
  }



  final prefs = await SharedPreferences.getInstance();
  OrderProvider orderProvider = OrderProvider() ;
  CategoriesProvider categoriesProvider = CategoriesProvider();
  String uid = '';
  String role = '';
  uid = prefs.getString('uid') ?? '';
  role = prefs.getString('role') ?? '';
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => Auth_Provider()),
      ChangeNotifierProvider(create: (_) => orderProvider),
      ChangeNotifierProvider(create: (_) => localProvider),
      ChangeNotifierProvider(create: (_) => categoriesProvider),
    ],
    child: Consumer<LocalProvider>(
        builder: (context, mylocalProvider,child) {
          return MaterialApp(
            theme: ThemeData(
              primaryColor: Palette.primary,
            ),

            locale: Locale('${mylocalProvider.local}'),
            localizationsDelegates: [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            debugShowCheckedModeBanner: false,
            home: (uid == '' || role == '') ? OnboardingScreen() : (uid != '' && role == 'admin') ? AdminHomeScreen() : HomeScreen(),
          );
        }
    ),
  ));
}
