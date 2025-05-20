import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_web/screen/home/view/home_view.dart';
import 'package:flutter_web/screen/login/controller/login_controller.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  await dotenv.load(fileName: '.env');
  final container = ProviderContainer();
  await container.read(userTokenProvifer.notifier).loadToken();

  await Supabase.initialize(
    url: 'https://fzwtynggwmnodhdrwvwy.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ6d3R5bmdnd21ub2RoZHJ3dnd5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDc1NDQ5NjQsImV4cCI6MjA2MzEyMDk2NH0.Dxg8VB-IFjHINtirJiG8tdUjdpcmnA_pXUh9j85CH68',
  );
  runApp(
    UncontrolledProviderScope(
      container: container,
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(375, 812),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const HomeView(),
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
