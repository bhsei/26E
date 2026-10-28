import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'auth/auth_checker.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const AuthApp());
}
