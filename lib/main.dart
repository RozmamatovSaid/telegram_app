import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:telegram/contacts/presentation/bloc/contact_bloc.dart';
import 'contacts/presentation/screens/contacts_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Telegram Contacts',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.black,
      ),
      home: BlocProvider(
        create: (context) => ContactBloc(),
        child: ContactsScreen(),
      ),
    );
  }
}
