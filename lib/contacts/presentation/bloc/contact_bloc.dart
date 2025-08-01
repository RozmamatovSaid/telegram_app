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

  // Kontaktlarni yuklash - withAccounts: true qo'shildi
  Future<void> _onLoadContacts(
    LoadContacts event,
    Emitter<ContactState> emit,
  ) async {
    try {
      print('📞 Kontaktlarni yuklamoqda...');
      emit(ContactLoading());

      // BU YERDA ASOSIY O'ZGARISH!
      final contacts = await FlutterContacts.getContacts(
        withProperties: true,
        withPhoto: true,
        withAccounts: true, // ← Bu muhim parameter!
        withGroups: true, // ← Bu ham yaxshi bo'ladi
      );

      print('✅ ${contacts.length} ta kontakt yuklandi (rawId bilan)');
      emit(ContactLoaded(contacts));
    } catch (e) {
      print('❌ Kontaktlar yuklashda xatolik: $e');
      emit(ContactError('Kontaktlar yuklanmadi: $e'));
    }
  }

  // Kontakt rasmini yangilash - to'g'irlangan
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

      // Kontaktni to'liq ma'lumotlar bilan yuklash
      final contact = await FlutterContacts.getContact(
        event.contactId,
        withProperties: true,
        withPhoto: true,
        withAccounts: true, // ← Bu ham kerak
      );

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

  // Kontakt ismini yangilash - to'g'irlangan
  Future<void> _onUpdateContactName(
    UpdateContactName event,
    Emitter<ContactState> emit,
  ) async {
    try {
      print(
        '✏️ BLoC: Name update boshlandi: ${event.firstName} ${event.lastName}',
      );
      emit(ContactUpdating());

      // Kontaktni to'liq ma'lumotlar bilan yuklash
      final contact = await FlutterContacts.getContact(
        event.contactId,
        withProperties: true,
        withPhoto: true,
        withAccounts: true, // ← Muhim!
      );

      if (contact == null) {
        print('❌ BLoC: Kontakt topilmadi');
        emit(ContactError('Kontakt topilmadi'));
        return;
      }

      print('👤 BLoC: Kontakt topildi: ${contact.displayName}');
      print(
        '🔍 BLoC: Raw contact IDs: ${contact.accounts.map((e) => e.rawId)}',
      );

      // Ismni yangilash
      contact.name.first = event.firstName;
      contact.name.last = event.lastName;

      // Display name ham yangilanadi
      final fullName = '${event.firstName} ${event.lastName}'.trim();
      if (fullName.isNotEmpty) {
        contact.displayName = fullName;
      }

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

  Future<void> _onUpdateContactPhone(
    UpdateContactPhone event,
    Emitter<ContactState> emit,
  ) async {
    try {
      print('📱 BLoC: Phone update boshlandi: ${event.phoneNumber}');
      emit(ContactUpdating());

      final contact = await FlutterContacts.getContact(
        event.contactId,
        withProperties: true,
        withPhoto: true,
        withAccounts: true, 
      );

      if (contact == null) {
        print('❌ BLoC: Kontakt topilmadi');
        emit(ContactError('Kontakt topilmadi'));
        return;
      }

      print('👤 BLoC: Kontakt topildi: ${contact.displayName}');

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
