import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

class ContactListtile extends StatelessWidget {
  const ContactListtile({
    super.key,
    this.image,
    this.contact,
    required this.name,
    required this.status,
    required this.onTap,
  });
  
  final String? image;
  final Contact? contact; 
  final String name;
  final String status;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: _buildAvatar(),
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

  Widget _buildAvatar() {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF2C2C2E),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: _buildAvatarContent(),
      ),
    );
  }

  Widget _buildAvatarContent() {
    if (contact?.photo != null && contact!.photo!.isNotEmpty) {
      return Image.memory(
        contact!.photo!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildFallbackAvatar();
        },
      );
    }

    // Agar URL avatar bo'lsa
    if (image != null && image!.isNotEmpty && image!.startsWith('http')) {
      return Image.network(
        image!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildFallbackAvatar();
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          );
        },
      );
    }

    // Default fallback
    return _buildFallbackAvatar();
  }

  Widget _buildFallbackAvatar() {
    return Container(
      color: const Color(0xFF2C2C2E),
      child: Center(
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : '?',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}