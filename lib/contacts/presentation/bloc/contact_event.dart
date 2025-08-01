import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

abstract class ContactEvent extends Equatable {
  const ContactEvent();

  @override
  List<Object?> get props => [];
}

class LoadContacts extends ContactEvent {}

class UpdateContactPhoto extends ContactEvent {
  final String contactId;
  final ImageSource imageSource;

  const UpdateContactPhoto({
    required this.contactId,
    required this.imageSource,
  });

  @override
  List<Object?> get props => [contactId, imageSource];
}

class UpdateContactName extends ContactEvent {
  final String contactId;
  final String firstName;
  final String lastName;

  const UpdateContactName({
    required this.contactId,
    required this.firstName,
    required this.lastName,
  });

  @override
  List<Object?> get props => [contactId, firstName, lastName];
}

class UpdateContactPhone extends ContactEvent {
  final String contactId;
  final String phoneNumber;

  const UpdateContactPhone({
    required this.contactId,
    required this.phoneNumber,
  });

  @override
  List<Object?> get props => [contactId, phoneNumber];
}

class RefreshContacts extends ContactEvent {}