import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

class ContactAvatar extends StatelessWidget {
  final String avatarUrl;
  final String firstName;
  final String lastName;
  final VoidCallback? onTap;
  final double size;
  final Contact? contact; // Contact object qo'shamiz

  const ContactAvatar({
    super.key,
    required this.avatarUrl,
    required this.firstName,
    required this.lastName,
    this.onTap,
    this.size = 100,
    this.contact,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey[600],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(size / 2),
          child: _buildAvatarImage(),
        ),
      ),
    );
  }

  Widget _buildAvatarImage() {
    // Agar contact object bor va rasmi bor bo'lsa
    if (contact?.photo != null && contact!.photo!.isNotEmpty) {
      return Image.memory(
        contact!.photo!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Icon(Icons.person, size: size * 0.5, color: Colors.white);
        },
      );
    }

    // Agar URL avatar bo'lsa
    if (avatarUrl.startsWith('http')) {
      return Image.network(
        avatarUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Icon(Icons.person, size: size * 0.5, color: Colors.white);
        },
      );
    }

    // Default icon
    return Icon(Icons.person, size: size * 0.5, color: Colors.white);
  }
}
