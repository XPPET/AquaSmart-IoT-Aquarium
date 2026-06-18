import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import '../models/aquarium_model.dart';

class FirebaseService {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  // Stream to listen for realtime updates
  Stream<AquariumData> get aquariumStream {
    return _dbRef.onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data == null) {
        return AquariumData(temperature: 0.0, feedNow: false, lightSwitch: false);
      }
      return AquariumData.fromMap(data);
    });
  }

  // Trigger feeding: set feed_now to true, wait 2s, then false
  Future<void> triggerFeeding() async {
    await _dbRef.update({'feed_now': true});
    await Future.delayed(const Duration(seconds: 2));
    await _dbRef.update({'feed_now': false});
  }

  // Toggle lights
  Future<void> toggleLights(bool value) async {
    await _dbRef.update({'light_switch': value});
  }
}
