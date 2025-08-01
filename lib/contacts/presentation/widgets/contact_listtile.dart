import 'package:flutter/material.dart';

class ContactListtile extends StatelessWidget {
  const ContactListtile({
    super.key,
    this.image,
    required this.name,
    required this.status,
    required this.onTap,
  });
  final String? image;
  final String name;
  final String status;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 22,
        backgroundImage: image != null && image!.isNotEmpty
            ? NetworkImage(image!)
            : null,
        backgroundColor: const Color(0xFF2C2C2E),
        child: image == null || image!.isEmpty
            ? Text(
                name.isNotEmpty ? name[0].toUpperCase() : '?',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              )
            : null,
      ),
      title: Text(
        name,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
      subtitle: Text(
        status,
        style: TextStyle(
          color: status == 'online' ? const Color(0xFF44C2FF) : Colors.white70,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.only(left: 18, right: 0),
    );
  }
}
