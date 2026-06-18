import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TempCard extends StatelessWidget {
  final double temperature;

  const TempCard({super.key, required this.temperature});

  @override
  Widget build(BuildContext context) {
    Color tempColor;
    if (temperature > 28) {
      tempColor = Colors.redAccent;
    } else if (temperature < 24) {
      tempColor = Colors.lightBlueAccent;
    } else {
      tempColor = Colors.greenAccent;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: tempColor.withOpacity(0.5), width: 2),
        boxShadow: [
          BoxShadow(
            color: tempColor.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.thermostat, size: 50, color: tempColor),
          const SizedBox(height: 10),
          Text(
            '${temperature.toStringAsFixed(1)}°C',
            style: GoogleFonts.poppins(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: tempColor,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'Water Temperature',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}
