import 'package:equatable/equatable.dart';
import 'package:flutter_contacts/contact.dart';

abstract class ContactState extends Equatable {
  const ContactState();

  @override
  List<Object?> get props => [];
}

class ContactInitial extends ContactState {}

class ContactLoading extends ContactState {}

class ContactLoaded extends ContactState {
  final List<Contact> contacts;

  const ContactLoaded(this.contacts);

  @override
  List<Object?> get props => [contacts];
}

class ContactError extends ContactState {
  final String message;

  const ContactError(this.message);

  @override
  List<Object?> get props => [message];
}

class ContactUpdating extends ContactState {}

class ContactUpdated extends ContactState {
  final String message;

  const ContactUpdated(this.message);

  @override
  List<Object?> get props => [message];
}
