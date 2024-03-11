import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:permission_handler/permission_handler.dart';

import 'firebase_options.dart';
import 'pharmacie_page.dart';
import 'pharm_garde_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Demande les autorisations de localisation au démarrage de l'application
  await _askPermission();
  runApp(const MyApp());
}

Future<void> _askPermission() async {
  var status = await Permission.location.request();
  if (status.isDenied || status.isPermanentlyDenied) {
    // L'utilisateur a refusé les autorisations ou les a refusées de manière permanente
    // Vous pouvez afficher un dialogue pour expliquer pourquoi les autorisations sont nécessaires
    // et fournir un moyen pour l'utilisateur de les activer manuellement dans les paramètres de l'appareil
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MED FINDER',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'MED FINDER'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;

  const MyHomePage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        actions: const <Widget>[Icon(Icons.games_rounded)],
      ),
      backgroundColor: const Color.fromARGB(255, 202, 215, 221),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Center(
            child: Container(
              color: Colors.white,
              height: 320,
              width: MediaQuery.of(context).size.width,
              child: Image.asset('images/logoApp.png'),
            ),
          ),
          const SizedBox(height: 65),
          Center(
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Coming Soon'),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.yellow,
                minimumSize: const Size(350, 65),
                backgroundColor: Colors.lightBlue[900],
              ),
              child: const Text('Médicaments', style: TextStyle(fontSize: 22)),
            ),
          ),
          const SizedBox(height: 50),
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PharmaciesPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.yellow,
                minimumSize: const Size(350, 65),
                backgroundColor: Colors.lightBlue[900],
              ),
              child: const Text('Pharmacies', style: TextStyle(fontSize: 22)),
            ),
          ),
          const SizedBox(height: 50),
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MapPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.yellow,
                minimumSize: const Size(350, 65),
                backgroundColor: Colors.lightBlue[900],
              ),
              child: const Text('Pharmacies de Garde', style: TextStyle(fontSize: 22)),
            ),
          ),
        ],
      ),
    );
  }
}
