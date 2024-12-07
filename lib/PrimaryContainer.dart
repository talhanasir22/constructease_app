import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'CalculatorScreen.dart';
class PrimaryContainer extends StatelessWidget {
  const PrimaryContainer({
    super.key,
    required this.text,
    this.icon,
    this.image,
  });

  final String text;
  final IconData? icon; // Nullable icon
  final String? image; // Nullable image path for Image.asset

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CalculatorScreen(pageTitle: text)));
      },
      child: Container(
        height: 150,
        width: 350,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.yellow.shade700,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                text,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),

              // Conditionally render the image if it's provided
              if (image != null) Image.asset(image!, height: 80, width: 80),

              // Conditionally render the icon if it's provided
              if (icon != null) Icon(icon, size: 80),
            ],
          ),
        ),
      ),
    );
  }
}
