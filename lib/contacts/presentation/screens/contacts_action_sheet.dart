import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:telegram/contacts/presentation/bloc/contact_bloc.dart';
import 'package:telegram/contacts/presentation/bloc/contact_event.dart';
import 'package:telegram/contacts/presentation/bloc/contact_state.dart';

import '../widgets/profile_widgets/editable_field.dart';

class ContactActionSheet extends StatelessWidget {
  final String contactId;
  final String avatarUrl;
  final String firstName;
  final String lastName;
  final String mainPhone;
  final String homePhone;
  final String bio;
  final Contact? contact;

  const ContactActionSheet({
    super.key,
    required this.contactId,
    required this.avatarUrl,
    required this.firstName,
    required this.lastName,
    required this.mainPhone,
    required this.homePhone,
    required this.bio,
    this.contact,
  });

  void _updatePhoto(sheetContext) {
    final contactBloc = sheetContext.read<ContactBloc>();

    showModalBottomSheet(
      context: sheetContext,
      backgroundColor: const Color(0xFF1C1C1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (bottomSheetContext) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Rasm tanlash',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(bottomSheetContext);
                    contactBloc.add(
                      UpdateContactPhoto(
                        contactId: contactId,
                        imageSource: ImageSource.gallery,
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Column(
                      children: [
                        Icon(
                          Icons.photo_library,
                          color: Colors.white,
                          size: 30,
                        ),
                        SizedBox(height: 8),
                        Text('Galereya', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(bottomSheetContext);
                    contactBloc.add(
                      UpdateContactPhoto(
                        contactId: contactId,
                        imageSource: ImageSource.camera,
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Column(
                      children: [
                        Icon(Icons.camera_alt, color: Colors.white, size: 30),
                        SizedBox(height: 8),
                        Text('Kamera', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Ism yangilash
  void _updateName(BuildContext context, String newValue, bool isFirstName) {
    final firstName = isFirstName ? newValue : this.firstName;
    final lastName = isFirstName ? this.lastName : newValue;

    // Validatsiya
    if (newValue.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ism bo\'sh bo\'lishi mumkin emas'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    context.read<ContactBloc>().add(
      UpdateContactName(
        contactId: contactId,
        firstName: firstName,
        lastName: lastName,
      ),
    );
  }

  void _updatePhone(BuildContext context, String newPhone) {
    if (newPhone.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Telefon raqam bo\'sh bo\'lishi mumkin emas'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    context.read<ContactBloc>().add(
      UpdateContactPhone(contactId: contactId, phoneNumber: newPhone),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ContactBloc, ContactState>(
      listener: (context, state) {
        if (state is ContactUpdated) {
          print('✅ BLoC listener: ContactUpdated - ${state.message}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
        } else if (state is ContactError) {
          print('❌ BLoC listener: ContactError - ${state.message}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      },
      child: BlocBuilder<ContactBloc, ContactState>(
        builder: (context, state) {
          final isUpdating = state is ContactUpdating;
          print('🔄 ContactActionSheet BLoC state: ${state.runtimeType}');

          return Container(
            height: MediaQuery.of(context).size.height * 0.8,
            decoration: const BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: Colors.blue, fontSize: 17),
                        ),
                      ),
                      const Text(
                        'Info',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Text(
                          'Done',
                          style: TextStyle(color: Colors.blue, fontSize: 17),
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            GestureDetector(
                              onTap: isUpdating
                                  ? null
                                  : () => _updatePhoto(context),
                              child: Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey[700],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: _buildAvatar(),
                                ),
                              ),
                            ),
                            if (isUpdating)
                              Positioned.fill(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black54,
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: const Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.blue,
                                      strokeWidth: 2,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),

                        const SizedBox(height: 30),

                        Text(
                          '$firstName $lastName'.trim().isEmpty
                              ? 'Noma\'lum'
                              : '$firstName $lastName'.trim(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 30),

                        EditableField(
                          label: 'Ism',
                          value: firstName,
                          hintText: 'Ism kiriting',
                          onSave: (value) => _updateName(context, value, true),
                          enabled: !isUpdating,
                        ),

                        const SizedBox(height: 15),

                        EditableField(
                          label: 'Familiya',
                          value: lastName,
                          hintText: 'Familiya kiriting',
                          onSave: (value) => _updateName(context, value, false),
                          enabled: !isUpdating,
                        ),

                        const SizedBox(height: 20),

                        EditableField(
                          label: 'main',
                          value: mainPhone,
                          hintText: '+998 90 123 45 67',
                          valueColor: const Color(0xFF27e65c),
                          keyboardType: TextInputType.phone,
                          onSave: (value) => _updatePhone(context, value),
                          enabled: !isUpdating,
                        ),

                        const SizedBox(height: 15),

                        EditableField(
                          label: 'home',
                          value: homePhone,
                          hintText: 'Home phone',
                          onSave: (value) {},
                          canEdit: false,
                        ),

                        const SizedBox(height: 15),

                        // Bio (read-only)
                        EditableField(
                          label: 'bio',
                          value: bio,
                          hintText: 'Bio',
                          onSave: (value) {},
                          canEdit: false,
                        ),

                        const SizedBox(height: 30),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1C1C1E),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                'Notifications',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Enabled',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Icon(
                                    Icons.chevron_right,
                                    color: Colors.white70,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Delete button
                        GestureDetector(
                          onTap: isUpdating
                              ? null
                              : () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      backgroundColor: const Color(0xFF1C1C1E),
                                      title: const Text(
                                        'Kontaktni o\'chirish',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      content: Text(
                                        '$firstName $lastName kontaktini o\'chirishni xohlaysizmi?',
                                        style: const TextStyle(
                                          color: Colors.white70,
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text(
                                            'Bekor qilish',
                                            style: TextStyle(
                                              color: Colors.blue,
                                            ),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                            print(
                                              '🗑️ Delete contact: $contactId',
                                            );
                                          },
                                          child: const Text(
                                            'O\'chirish',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            decoration: BoxDecoration(
                              color: isUpdating
                                  ? Colors.grey[800]
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Delete Contact',
                              style: TextStyle(
                                color: isUpdating ? Colors.grey : Colors.red,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAvatar() {
    // Agar contact object bor va rasmi bor bo'lsa
    if (contact?.photo != null && contact!.photo!.isNotEmpty) {
      return Image.memory(
        contact!.photo!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.person, size: 50, color: Colors.white);
        },
      );
    }

    if (avatarUrl.startsWith('http')) {
      return Image.network(
        avatarUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.person, size: 50, color: Colors.white);
        },
      );
    }

    // Default icon
    return const Icon(Icons.person, size: 50, color: Colors.white);
  }
}

// To'g'irlangan EditableField widget
