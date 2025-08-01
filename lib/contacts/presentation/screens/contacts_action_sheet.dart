import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:telegram/contacts/presentation/bloc/contact_bloc.dart';
import 'package:telegram/contacts/presentation/bloc/contact_event.dart';
import 'package:telegram/contacts/presentation/bloc/contact_state.dart';
import 'package:telegram/contacts/presentation/widgets/profile_widgets/contact_avatar.dart';
import 'package:telegram/contacts/presentation/widgets/profile_widgets/editable_field.dart';

class ContactActionSheet extends StatelessWidget {
  final String contactId;
  final String avatarUrl;
  final String firstName;
  final String lastName;
  final String mainPhone;
  final String homePhone;
  final String bio;

  const ContactActionSheet({
    super.key,
    required this.contactId,
    required this.avatarUrl,
    required this.firstName,
    required this.lastName,
    required this.mainPhone,
    required this.homePhone,
    required this.bio,
  });

  // Rasm yangilash - BLoC orqali
  void _updatePhoto(BuildContext context) {
    print('📸 Photo update triggered for contact: $contactId');
    context.read<ContactBloc>().add(
      UpdateContactPhoto(
        contactId: contactId,
        imageSource: ImageSource.gallery,
      ),
    );
  }

  // Ism yangilash - BLoC orqali
  void _updateName(BuildContext context, String newValue, bool isFirstName) {
    print('✏️ Name update: $newValue, isFirstName: $isFirstName');

    final firstName = isFirstName ? newValue : this.firstName;
    final lastName = isFirstName ? this.lastName : newValue;

    context.read<ContactBloc>().add(
      UpdateContactName(
        contactId: contactId,
        firstName: firstName,
        lastName: lastName,
      ),
    );
  }

  // Telefon yangilash - BLoC orqali
  void _updatePhone(BuildContext context, String newPhone) {
    print('📱 Phone update: $newPhone');
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
            ),
          );
        } else if (state is ContactError) {
          print('❌ BLoC listener: ContactError - ${state.message}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
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

                // Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        // Avatar with loading
                        Stack(
                          children: [
                            ContactAvatar(
                              avatarUrl: avatarUrl,
                              firstName: firstName,
                              lastName: lastName,
                              onTap: () => _updatePhoto(context),
                              size: 100,
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
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),

                        const SizedBox(height: 30),

                        // Name display
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

                        // Ism field
                        EditableField(
                          label: 'Ism',
                          value: firstName,
                          hintText: 'Ism kiriting',
                          onSave: (value) => _updateName(context, value, true),
                        ),

                        const SizedBox(height: 15),

                        // Familiya field
                        EditableField(
                          label: 'Familiya',
                          value: lastName,
                          hintText: 'Familiya kiriting',
                          onSave: (value) => _updateName(context, value, false),
                        ),

                        const SizedBox(height: 20),

                        // Main phone field
                        EditableField(
                          label: 'main',
                          value: mainPhone,
                          hintText: '+998 90 123 45 67',
                          valueColor: const Color(0xFF27e65c),
                          keyboardType: TextInputType.phone,
                          onSave: (value) => _updatePhone(context, value),
                        ),

                        const SizedBox(height: 15),

                        // Home phone (read-only)
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

                        // Notifications
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 12,
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
                          onTap: () => print('🗑️ Delete contact tapped'),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: const Text(
                              'Delete Contact',
                              style: TextStyle(color: Colors.red, fontSize: 16),
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
}
