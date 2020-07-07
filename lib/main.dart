import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'data/contact.dart';

const kContactAmount = 500;

void main() {
  // debugPaintSizeEnabled = true;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

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

  Key searchKey = GlobalKey();
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
              final contacts = snapshot.data;
              return contacts.isEmpty
                  ? Center(child: Text('No contacts...'))
                  : Scrollbar(
                      child: ListView.separated(
                        separatorBuilder: (_, __) => const Divider(height: 0),
                        itemCount: contacts.length,
                        itemBuilder: (ctx, i) => ListTile(
                          leading: Icon(
                            contacts[i].type == ContactType.business
                                ? Icons.business
                                : Icons.person,
                          ),
                          title: Text(contacts[i].name),
                          subtitle: Text(contacts[i].tel),
                          onTap: () {},
                        ),
                      ),
                    );
            }
            return Center(child: CircularProgressIndicator());
          }),
    );
  }
}
