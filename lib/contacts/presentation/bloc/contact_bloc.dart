import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import 'contact_event.dart';
import 'contact_state.dart';

class ContactBloc extends Bloc<ContactEvent, ContactState> {
  ContactBloc() : super(ContactInitial()) {
    on<LoadContacts>(_onLoadContacts);
    on<UpdateContactPhoto>(_onUpdateContactPhoto);
    on<UpdateContactName>(_onUpdateContactName);
    on<UpdateContactPhone>(_onUpdateContactPhone);
    on<RefreshContacts>(_onRefreshContacts);
  }

  // Kontaktlarni yuklash
  Future<void> _onLoadContacts(
    LoadContacts event,
    Emitter<ContactState> emit,
  ) async {
    try {
      print('📞 Kontaktlarni yuklamoqda...');
      emit(ContactLoading());

      final contacts = await FlutterContacts.getContacts(
        withProperties: true,
        withPhoto: true,
      );

      print('✅ ${contacts.length} ta kontakt yuklandi');
      emit(ContactLoaded(contacts));
    } catch (e) {
      print('❌ Kontaktlar yuklashda xatolik: $e');
      emit(ContactError('Kontaktlar yuklanmadi'));
    }
  }

  // Kontakt rasmini yangilash - REAL LOGIC
  Future<void> _onUpdateContactPhoto(
    UpdateContactPhoto event,
    Emitter<ContactState> emit,
  ) async {
    try {
      print('📸 BLoC: Photo update boshlandi...');
      emit(ContactUpdating());

      // Rasm tanlash
      final ImagePicker imagePicker = ImagePicker();
      final XFile? image = await imagePicker.pickImage(
        source: event.imageSource,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );

      if (image == null) {
        print('❌ BLoC: Rasm tanlanmadi');
        emit(ContactError('Rasm tanlanmadi'));
        return;
      }

      print('📸 BLoC: Rasm tanlandi, bytes ga o\'girmoqda...');
      final Uint8List imageBytes = await image.readAsBytes();
      print('📸 BLoC: Image bytes: ${imageBytes.length} bytes');

      // Kontaktni topish
      final contact = await FlutterContacts.getContact(event.contactId);
      if (contact == null) {
        print('❌ BLoC: Kontakt topilmadi');
        emit(ContactError('Kontakt topilmadi'));
        return;
      }

      print('👤 BLoC: Kontakt topildi: ${contact.displayName}');

      // Rasmni o'rnatish va saqlash
      contact.photo = imageBytes;
      await contact.update();
      print('✅ BLoC: Kontakt rasmi saqlandi!');

      emit(ContactUpdated('Rasm muvaffaqiyatli yangilandi!'));
      add(LoadContacts()); // Qayta yuklash
    } catch (e) {
      print('❌ BLoC: Rasm yangilashda xatolik: $e');
      emit(ContactError('Rasm yangilanmadi: $e'));
    }
  }

  // Kontakt ismini yangilash - REAL LOGIC
  Future<void> _onUpdateContactName(
    UpdateContactName event,
    Emitter<ContactState> emit,
  ) async {
    try {
      print(
        '✏️ BLoC: Name update boshlandi: ${event.firstName} ${event.lastName}',
      );
      emit(ContactUpdating());

      final contact = await FlutterContacts.getContact(event.contactId);
      if (contact == null) {
        print('❌ BLoC: Kontakt topilmadi');
        emit(ContactError('Kontakt topilmadi'));
        return;
      }

      print('👤 BLoC: Kontakt topildi: ${contact.displayName}');

      // Ismni yangilash
      contact.name.first = event.firstName;
      contact.name.last = event.lastName;
      contact.displayName = '${event.firstName} ${event.lastName}'.trim();
      print('✏️ BLoC: Yangi ism: ${contact.displayName}');

      await contact.update();
      print('✅ BLoC: Kontakt ismi saqlandi!');

      emit(ContactUpdated('Ism muvaffaqiyatli yangilandi!'));
      add(LoadContacts());
    } catch (e) {
      print('❌ BLoC: Ism yangilashda xatolik: $e');
      emit(ContactError('Ism yangilanmadi: $e'));
    }
  }

  // Kontakt telefon raqamini yangilash - REAL LOGIC
  Future<void> _onUpdateContactPhone(
    UpdateContactPhone event,
    Emitter<ContactState> emit,
  ) async {
    try {
      print('📱 BLoC: Phone update boshlandi: ${event.phoneNumber}');
      emit(ContactUpdating());

      final contact = await FlutterContacts.getContact(event.contactId);
      if (contact == null) {
        print('❌ BLoC: Kontakt topilmadi');
        emit(ContactError('Kontakt topilmadi'));
        return;
      }

      print('👤 BLoC: Kontakt topildi: ${contact.displayName}');

      // Telefon raqamni yangilash
      if (contact.phones.isNotEmpty) {
        contact.phones.first.number = event.phoneNumber;
        print('📱 BLoC: Mavjud telefon yangilandi: ${event.phoneNumber}');
      } else {
        contact.phones.add(Phone(event.phoneNumber));
        print('📱 BLoC: Yangi telefon qo\'shildi: ${event.phoneNumber}');
      }

      await contact.update();
      print('✅ BLoC: Kontakt telefoni saqlandi!');

      emit(ContactUpdated('Telefon raqam muvaffaqiyatli yangilandi!'));
      add(LoadContacts());
    } catch (e) {
      print('❌ BLoC: Telefon yangilashda xatolik: $e');
      emit(ContactError('Telefon raqam yangilanmadi: $e'));
    }
  }

  Future<void> _onRefreshContacts(
    RefreshContacts event,
    Emitter<ContactState> emit,
  ) async {
    print('🔄 Refreshing contacts...');
    add(LoadContacts());
  }
}
