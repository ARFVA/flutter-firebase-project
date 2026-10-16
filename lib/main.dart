import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'firebase_options.dart';
import 'core/constants/app_constants.dart';
import 'core/services/fcm_service.dart';
import 'core/theme/app_theme.dart';
import 'bindings/initial_binding.dart';
import 'routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // App Check: protects Firestore/RTDB/Storage/Functions from abuse.
    // Debug provider in debug builds; Play Integrity (Android) / DeviceCheck (Apple) in release.
    try {
      await FirebaseAppCheck.instance.activate(
        androidProvider: kDebugMode
            ? AndroidProvider.debug
            : AndroidProvider.playIntegrity,
        appleProvider: kDebugMode
            ? AppleProvider.debug
            : AppleProvider.deviceCheck,
      );
      await FirebaseAppCheck.instance.setTokenAutoRefreshEnabled(true);
      debugPrint('App Check activated');
    } catch (e) {
      debugPrint('App Check not initialized: $e');
    }

    // FCM: permission, foreground/background display, topics, token lifecycle.
    if (!kIsWeb) {
      try {
        await FCMService.instance.initialize();
      } catch (e) {
        debugPrint('FCM initialization failed: $e');
      }
    }
  } catch (e) {
    debugPrint('Firebase initialization error: $e');
  }

  runApp(const StudyQuestApp());
}

class StudyQuestApp extends StatelessWidget {
  const StudyQuestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      initialBinding: InitialBinding(),
    );
  }
}
