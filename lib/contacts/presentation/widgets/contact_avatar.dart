import 'package:flutter/material.dart';

class ContactAvatar extends StatelessWidget {
  final String avatarUrl;
  final String firstName;
  final String lastName;
  const ContactAvatar({
    super.key,
    required this.avatarUrl,
    required this.firstName,
    required this.lastName,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          CircleAvatar(radius: 38, backgroundImage: NetworkImage(avatarUrl)),
          const SizedBox(height: 10),
          Text(
            firstName,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 19,
            ),
          ),
          Text(
            lastName,
            style: const TextStyle(color: Colors.white70, fontSize: 15),
          ),
        ],
      ),
    );
  }
}

// Label-value field
