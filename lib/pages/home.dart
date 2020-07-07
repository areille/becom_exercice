import 'dart:async';

import 'package:exercice/pages/edit.dart';
import 'package:flutter/material.dart';
import 'package:sticky_headers/sticky_headers.dart';

import '../data/contact.dart';

const kContactAmount = 500;

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Contact> contacts;

  StreamController<List<Contact>> _streamController =
      StreamController<List<Contact>>();
  StreamSink<List<Contact>> get contactsSink => _streamController.sink;
  Stream<List<Contact>> get contactsStream => _streamController.stream;

  TextEditingController searchCtrl = TextEditingController();

  @override
  void initState() {
    contacts = [
      for (int i = 0; i < kContactAmount; i++) Contact.random(),
    ]..sort((a, b) => a.name.compareTo(b.name));

    contactsSink.add(contacts);
    super.initState();
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  void updateDisplayedContacts(String pattern) {
    contactsSink.add([
      ...contacts.where((c) => c.name.toLowerCase().contains(pattern)),
    ]);
  }

  void editContact(Contact contact) async {
    final editedContact = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditionPage(contact: contact),
      ),
    );
    if (editedContact != null) {
      contacts
        ..remove(contact)
        ..add(editedContact)
        ..sort((a, b) => a.name.compareTo(b.name));
      contactsSink.add(contacts);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          height: 4 / 5 * kToolbarHeight,
          child: TextField(
            textAlignVertical: TextAlignVertical.center,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(left: 16),
              suffixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: const BorderRadius.all(
                  const Radius.circular(kToolbarHeight / 2),
                ),
                borderSide: BorderSide(
                  width: 0,
                  style: BorderStyle.none,
                ),
              ),
              filled: true,
              fillColor: Colors.white70,
            ),
            onChanged: updateDisplayedContacts,
          ),
        ),
      ),
      body: StreamBuilder<List<Contact>>(
          stream: contactsStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.isEmpty)
                return Center(child: Text('No contacts...'));
              else {
                final initials = [
                  ...{...snapshot.data.map((e) => e.name[0])}
                ];
                final Map<String, List<Contact>> contactMap = {
                  for (final letter in initials)
                    letter: [
                      ...snapshot.data.where((e) => e.name.startsWith(letter))
                    ]
                };
                return ListView.separated(
                  separatorBuilder: (_, __) => const Divider(height: 0),
                  itemCount: contactMap.length,
                  itemBuilder: (ctx, i) {
                    final letter = [...contactMap.keys][i];
                    return StickyHeader(
                      header: Container(
                        height: 30,
                        color: Colors.grey[200],
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        alignment: Alignment.centerLeft,
                        child: Text(letter),
                      ),
                      content: Column(
                        children: [
                          for (final contact in contactMap[letter])
                            ListTile(
                              leading: Icon(
                                contact.type == ContactType.business
                                    ? Icons.business
                                    : Icons.person,
                              ),
                              title: Text(contact.name),
                              subtitle: Text(contact.tel),
                              onTap: () => editContact(contact),
                            ),
                        ],
                      ),
                    );
                  },
                );
              }
            }
            return Center(child: CircularProgressIndicator());
          }),
    );
  }
}
