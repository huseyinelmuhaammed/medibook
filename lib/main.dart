import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app.dart';
import 'providers/appointment_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferences.getInstance();
  await initApp();
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppointmentProvider(),
      child: const MediBookApp(),
    ),
  );
}
