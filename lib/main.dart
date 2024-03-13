import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import 'firebase_options.dart';
import 'providers/pastor_provider.dart';
import 'providers/sermon_provider.dart';
import 'screens/home_screen.dart';
import 'screens/pastors_screen.dart';
import 'screens/sermon_screens/crud_sermon_screen.dart';
import 'screens/sermon_screens/sermons_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => SermonProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => PastorProvider(),
        ),
      ],
      child: Sizer(
        builder: (context, orientation, deviceType) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.grey,
            primaryColor: Colors.black,
            appBarTheme: const AppBarTheme(
              elevation: 0,
              backgroundColor: Colors.black,
            ),
            textTheme: const TextTheme(
              bodyMedium: TextStyle(
                color: Colors.black,
              ),
            ),
            floatingActionButtonTheme: const FloatingActionButtonThemeData(
              backgroundColor: Colors.black,
            ),
          ),
          initialRoute: '/',
          routes: {
            HomeScreen.routeName: (ctx) => const HomeScreen(),
            SermonsScreen.routeName: (ctx) => const SermonsScreen(),
            PastorsScreen.routeName: (ctx) => const PastorsScreen(),
            CRUDSermonScreen.routeName: (ctx) => const CRUDSermonScreen(),
          },
        ),
      ),
    );
  }
}
