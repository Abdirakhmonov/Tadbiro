import 'package:examen_4/services/fire_store_event_service.dart';
import 'package:examen_4/services/firebase_auth_service.dart';
import 'package:examen_4/services/location_service.dart';
import 'package:examen_4/views/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/themeMode.dart';
import 'blocs/auth/auth_bloc.dart';
import 'blocs/events/event_bloc.dart';
import 'firebase_options.dart';

void main() async {
  // PermissionStatus cameraPermission = await Permission.camera.status;
  // if (cameraPermission != PermissionStatus.granted) {
  //   await Permission.camera.request();
  // }
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final prefs = await SharedPreferences.getInstance();
  final themeString = prefs.getString('theme_mode');
  final initialThemeMode =
      themeString == 'dark' ? ThemeMode.dark : ThemeMode.light;

  runApp(MyApp(initialThemeMode: initialThemeMode));
}

class MyApp extends StatefulWidget {
  final ThemeMode initialThemeMode;

  MyApp({super.key, required this.initialThemeMode});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _firebaseAuthService = UserAuthService();

  @override
  void initState() {
    LocationService.checkPermissions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authService = UserAuthService();
    final eventService = EventService();
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ThemeCubit()..emit(widget.initialThemeMode),
        ),
        BlocProvider(
          create: (context) => AuthenticationBloc(authService),
        ),
        BlocProvider(
          create: (context) => EventBloc(eventService),
        )
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            themeMode: themeMode,
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
