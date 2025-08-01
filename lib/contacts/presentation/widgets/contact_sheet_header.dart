import 'package:flutter/material.dart';

class ContactSheetHeader extends StatelessWidget {
  const ContactSheetHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel", style: TextStyle(color: Colors.white70)),
        ),
        const Text(
          "Info",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextButton(
          onPressed: () {}, // Done action
          child: const Text("Done", style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}

// Avatar + Name
