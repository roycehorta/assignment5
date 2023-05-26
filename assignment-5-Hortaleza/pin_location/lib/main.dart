import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pin_location/firebase_options.dart';
import 'package:pin_location/screens/fav_location.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(hortaleza());
}

class hortaleza extends StatelessWidget {
  const hortaleza({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FavLocation(),
      debugShowCheckedModeBanner: false,
    );
  }
}
