import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ratek/core/constants/app_constants.dart';
import 'package:ratek/core/services/connectivity_service.dart';
import 'package:ratek/core/theme/app_theme.dart';
import 'package:ratek/core/services/database_service.dart';
import 'package:ratek/get_started.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize local database
  await DatabaseService.instance.database;

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    final isOnline = ref.watch(connectivityProvider);
    if (isOnline) {
      scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.green,
          content: Text("Back online! Data synced"),
          duration: Duration(seconds: 3),
          action: SnackBarAction(
            label: 'Dismiss',
            onPressed: () =>
                scaffoldMessengerKey.currentState?.hideCurrentSnackBar(),
          ),
        ),
      );
    } else {
      scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
          content: Text(
            "You are offline!",
            style: TextStyle(color: Colors.white),
          ),
          duration: Duration(seconds: 3),
          action: SnackBarAction(
            label: 'Dismiss',
            onPressed: () =>
                scaffoldMessengerKey.currentState?.hideCurrentSnackBar(),
          ),
        ),
      );
    }
    return ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        builder: (context, child) {
          return MaterialApp(
            scaffoldMessengerKey: scaffoldMessengerKey,
            debugShowCheckedModeBanner: false,
            title: AppConstants.appName,
            theme: AppTheme.lightTheme(context),
            darkTheme: AppTheme.darkTheme(context),
            themeMode: ThemeMode.system, // Automatically use system theme
            home: const GetStartedScreen(),
          );
        });
  }

  @override
  void dispose() {
    // Close the database when the app is closed
    DatabaseService.instance.close();
    super.dispose();
  }
}
