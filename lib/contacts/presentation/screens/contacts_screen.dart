import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:telegram/contacts/presentation/bloc/contact_bloc.dart';
import 'package:telegram/contacts/presentation/bloc/contact_event.dart';
import 'package:telegram/contacts/presentation/bloc/contact_state.dart';
import 'package:telegram/contacts/presentation/screens/contacts_action_sheet.dart';

import '../widgets/contact_listtile.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    print('🔐 Permission tekshirilmoqda...');

    final permission = await Permission.contacts.request();
    if (permission.isGranted) {
      print('✅ Permission berildi, kontaktlarni yuklayapmiz...');
      if (mounted) {
        context.read<ContactBloc>().add(LoadContacts());
      }
    } else {
      print('❌ Permission rad etildi');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Kontaktlarga ruxsat berilmadi'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String getContactName(Contact contact) {
    if (contact.displayName.isNotEmpty) {
      return contact.displayName;
    }
    final fullName = '${contact.name.first} ${contact.name.last}'.trim();
    return fullName.isNotEmpty ? fullName : 'Noma\'lum';
  }

  String getContactPhone(Contact contact) {
    if (contact.phones.isNotEmpty) {
      return contact.phones.first.number;
    }
    return 'Telefon yoq';
  }

  String getContactAvatar(Contact contact) {
    final name = getContactName(contact);

    // Agar telefondagi rasm bor bo'lsa
    if (contact.photo != null && contact.photo!.isNotEmpty) {
      print('📸 Contact has photo: ${contact.displayName}');
      return 'memory_image'; // Special marker
    }

    // Aks holda generated avatar
    return 'https://ui-avatars.com/api/?name=${Uri.encodeFull(name)}&background=0D8ABC&color=fff&size=128';
  }

  String getContactStatus(Contact contact) {
    final statuses = ['online', 'last seen recently', 'offline'];
    return statuses[contact.hashCode.abs() % statuses.length];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C1C1D),
        title: const Text(
          'Contacts',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 17,
          ),
        ),
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () {
              print('➕ Add contact tapped');
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              print('🔄 Refresh tapped');
              context.read<ContactBloc>().add(LoadContacts());
            },
          ),
        ],
      ),
      body: BlocBuilder<ContactBloc, ContactState>(
        builder: (context, state) {
          print('🔄 Current state: ${state.runtimeType}');

          if (state is ContactLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.blue),
            );
          }

          if (state is ContactError) {
            print('❌ Error state: ${state.message}');
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.message,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadContacts,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: const Text(
                      'Qayta urinish',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            );
          }

          if (state is ContactLoaded) {
            final contacts = state.contacts;
            print('✅ Contacts loaded: ${contacts.length} ta');

            if (contacts.isEmpty) {
              return const Center(
                child: Text(
                  'Kontaktlar topilmadi',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            return ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: 3 + contacts.length * 2,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return ListTile(
                    leading: const Icon(
                      Icons.location_on_outlined,
                      color: Colors.white,
                    ),
                    title: const Text(
                      'Add People Nearby',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onTap: () => print('📍 Add People Nearby tapped'),
                    contentPadding: const EdgeInsets.only(left: 18, right: 0),
                  );
                }

                if (index == 1) {
                  return ListTile(
                    leading: const Icon(
                      Icons.person_add_alt_1,
                      color: Colors.white,
                    ),
                    title: const Text(
                      'Invite Friends',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onTap: () => print('👥 Invite Friends tapped'),
                    contentPadding: const EdgeInsets.only(left: 18, right: 0),
                  );
                }

                if (index == 2) {
                  return const Divider(
                    color: Colors.white12,
                    thickness: 1,
                    height: 0,
                  );
                }

                final contactIndex = ((index - 3) / 2).floor();
                if ((index - 3) % 2 == 0) {
                  return const Divider(
                    color: Colors.white12,
                    thickness: 1,
                    height: 0,
                  );
                }

                if (contactIndex >= contacts.length) {
                  return const SizedBox.shrink();
                }

                final contact = contacts[contactIndex];
                final contactName = getContactName(contact);
                final contactPhone = getContactPhone(contact);
                final contactAvatar = getContactAvatar(contact);
                final contactStatus = getContactStatus(contact);

                return ContactListtile(
                  image: contactAvatar == 'memory_image' ? null : contactAvatar,
                  contact: contact, // Contact object ham uzatamiz
                  name: contactName,
                  status: contactStatus,
                  onTap: () {
                    print('👤 Contact tapped: $contactName (ID: ${contact.id})');

                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (sheetContext) {
                        final contactBloc = context.read<ContactBloc>();
                        return BlocProvider<ContactBloc>.value(
                          value: contactBloc,
                          child: ContactActionSheet(
                            contactId: contact.id,
                            avatarUrl: contactAvatar,
                            firstName: contact.name.first,
                            lastName: contact.name.last,
                            mainPhone: contactPhone,
                            homePhone: contact.phones.length > 1
                                ? contact.phones[1].number
                                : '',
                            bio: contact.organizations.isNotEmpty
                                ? contact.organizations.first.company
                                : 'Telegram foydalanuvchisi',
                            contact: contact, // Contact object ham uzatamiz
                          ),
                        );
                      },
                    );
                  },
                );
              },
            );
          }

          return const Center(
            child: Text(
              'Kontaktlar yuklanmoqda...',
              style: TextStyle(color: Colors.white),
            ),
          );
        },
      ),
    );
  }
}