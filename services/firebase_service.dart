import 'package:firebase_database/firebase_database.dart';

class FirebaseService {
  // Η αναφορά στη βάση δεδομένων σου
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  // 1. Stream για να διαβάζεις τη θερμοκρασία live (για το Dashboard)
  Stream<DatabaseEvent> getTemperatureStream() {
    return _dbRef.child('status/temperature').onValue;
  }

  // 2. Συνάρτηση για το τάισμα
  Future<void> triggerFeeding() async {
    try {
      // Στέλνει την εντολή feed_now: true
      await _dbRef.child('controls').update({'feed_now': true});
      
      // Μετά από 2 δευτερόλεπτα το ξανακάνει false (reset)
      Future.delayed(Duration(seconds: 2), () async {
        await _dbRef.child('controls').update({'feed_now': false});
      });
    } catch (e) {
      print("Error feeding fish: $e");
    }
  }

  // 3. Συνάρτηση για τον έλεγχο των φώτων
  Future<void> toggleLights(bool status) async {
    await _dbRef.child('controls').update({'light_switch': status});
  }
}