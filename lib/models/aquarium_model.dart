class AquariumData {
  final double temperature;
  final bool feedNow;
  final bool lightSwitch;

  AquariumData({
    required this.temperature,
    required this.feedNow,
    required this.lightSwitch,
  });

  factory AquariumData.fromMap(Map<dynamic, dynamic> data) {
    return AquariumData(
      temperature: (data['temperature'] as num?)?.toDouble() ?? 0.0,
      feedNow: data['feed_now'] as bool? ?? false,
      lightSwitch: data['light_switch'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'temperature': temperature,
      'feed_now': feedNow,
      'light_switch': lightSwitch,
    };
  }
}
