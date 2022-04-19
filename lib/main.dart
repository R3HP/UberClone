import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxi_line/core/service_locator.dart';
import 'package:taxi_line/features/accounting/presentation/screen/auth_screen.dart';
import 'package:taxi_line/features/cab/presentation/screens/cab_screen.dart';
import 'package:taxi_line/features/cab/presentation/screens/waiting_screen.dart';
import 'package:taxi_line/features/main_screen/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setUp();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TaxiLine',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, AsyncSnapshot<User?> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SplashScreen();
            } else if (snapshot.hasData && snapshot.data != null) {
              return const CabScreen();
            } else {
              return const AuthScreen();
            }
          }),
      routes: {
        CabScreen.routeName: (ctx) =>  const CabScreen(),
        WaitingScreen.routeName : (ctx) => const WaitingScreen()
      },
    );
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  const Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: CircularProgressIndicator.adaptive(),
        ),
      ),
    );
  }
}
