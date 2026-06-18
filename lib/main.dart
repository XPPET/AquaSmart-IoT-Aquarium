import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyAbA9SCKTYmgb2TBi5aPRDIG0x2nVJx7ss",
      appId: "1:437643705679:web:e6bd99ea8a501b34e8993a",
      messagingSenderId: "437643705679",
      projectId: "aquarium-web",
      databaseURL: "https://aquarium-web-default-rtdb.firebaseio.com/",
    ),
  );
  runApp(const MaterialApp(debugShowCheckedModeBanner: false, home: AquaDashboard()));
}

class AquaDashboard extends StatelessWidget {
  const AquaDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final ref = FirebaseDatabase.instance.ref();

    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(title: const Text("AquaSmart Control"), backgroundColor: Colors.blueGrey),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Θερμοκρασία Ενυδρείου", style: TextStyle(color: Colors.white, fontSize: 18)),
            StreamBuilder(
              stream: ref.child('status/temperature').onValue,
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
                  return Text(
                    "${snapshot.data!.snapshot.value}°C",
                    style: const TextStyle(fontSize: 64, color: Colors.greenAccent, fontWeight: FontWeight.bold),
                  );
                }
                return const CircularProgressIndicator();
              },
            ),
            const SizedBox(height: 50),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orangeAccent,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              ),
              onPressed: () => ref.child('controls/feed_now').set(true),
              icon: const Icon(Icons.set_meal, color: Colors.black),
              label: const Text("ΤΑΪΣΜΑ", style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}