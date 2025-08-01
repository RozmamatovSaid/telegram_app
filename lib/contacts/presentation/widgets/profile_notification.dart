import 'package:flutter/material.dart';

class ContactNotification extends StatelessWidget {
  const ContactNotification({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Text(
        "Notifications",
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Text(
            "Enabled",
            style: TextStyle(color: Colors.white60, fontSize: 16),
          ),
          Icon(Icons.chevron_right, color: Colors.white54),
        ],
      ),
      onTap: () {},
    );
  }
}

// Delete button
