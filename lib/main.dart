import 'package:firebase_core/firebase_core.dart';
import 'package:firstly/pages/home.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  if (kIsWeb) {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyAsvJCGuiHzCU4vEx434nLBfUPE9pyCKPE",
            authDomain: "mentalhealthapp-4f78b.firebaseapp.com",
            projectId: "mentalhealthapp-4f78b",
            storageBucket: "mentalhealthapp-4f78b.firebasestorage.app",
            messagingSenderId: "976470722642",
            appId: "1:976470722642:web:1e30eca9fa62fbdeedf78b",
            measurementId: "G-WEJ07SS2Y0"));
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false, home: HomePage());
  }
}
