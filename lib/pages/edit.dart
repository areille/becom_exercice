import 'package:flutter/material.dart';

import '../data/contact.dart';
import '../utils/date_ext.dart';

class EditionPage extends StatefulWidget {
  final Contact contact;

  const EditionPage({
    Key key,
    @required this.contact,
  }) : super(key: key);
  @override
  _EditionPageState createState() => _EditionPageState();
}

class _EditionPageState extends State<EditionPage> {
  ContactType editedContactType;
  DateTime editedContactBirthDay;
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController telCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController addressCtrl = TextEditingController();
  TextEditingController zipCtrl = TextEditingController();
  TextEditingController cityCtrl = TextEditingController();
  TextEditingController dateCtrl = TextEditingController();
  TextEditingController commentCtrl = TextEditingController();

  @override
  void initState() {
    editedContactType = widget.contact.type;
    editedContactBirthDay = widget.contact.birthDate;

    nameCtrl.text = widget.contact.name;
    telCtrl.text = widget.contact.tel;
    emailCtrl.text = widget.contact.email;
    addressCtrl.text = widget.contact.address;
    zipCtrl.text = widget.contact.postalCode;
    cityCtrl.text = widget.contact.city;
    dateCtrl.text = widget.contact.birthDate.pretty();
    commentCtrl.text = widget.contact.comment;
    super.initState();
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    telCtrl.dispose();
    emailCtrl.dispose();
    addressCtrl.dispose();
    zipCtrl.dispose();
    cityCtrl.dispose();
    dateCtrl.dispose();
    commentCtrl.dispose();
    super.dispose();
  }

  void editContactType(ContactType newType) {
    setState(() {
      editedContactType = newType;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact edition'),
      ),
      body: ListView(
        children: [
          Row(
            children: [
              Radio<ContactType>(
                value: ContactType.personal,
                groupValue: editedContactType,
                onChanged: editContactType,
              ),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: editedContactType == ContactType.personal ? 1 : .4,
                child: const Icon(
                  Icons.person,
                  color: Colors.blue,
                ),
              ),
              SizedBox(width: 8),
              Radio<ContactType>(
                value: ContactType.business,
                groupValue: editedContactType,
                onChanged: editContactType,
              ),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: editedContactType == ContactType.business ? 1 : .4,
                child: const Icon(
                  Icons.business,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: nameCtrl,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(10.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                labelStyle: TextStyle(
                  fontSize: 16.0,
                ),
                labelText: 'Name',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: telCtrl,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(10.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                labelStyle: TextStyle(
                  fontSize: 16.0,
                ),
                labelText: 'Telephone',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: emailCtrl,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(10.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                labelStyle: TextStyle(
                  fontSize: 16.0,
                ),
                labelText: 'Email',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: addressCtrl,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(10.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                labelStyle: TextStyle(
                  fontSize: 16.0,
                ),
                labelText: 'Address',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Flexible(
                  flex: 1,
                  child: TextField(
                    controller: zipCtrl,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(10.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      labelStyle: TextStyle(
                        fontSize: 16.0,
                      ),
                      labelText: 'Postal code',
                    ),
                  ),
                ),
                SizedBox(width: 4),
                Flexible(
                  flex: 2,
                  child: TextField(
                    controller: cityCtrl,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(10.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      labelStyle: TextStyle(
                        fontSize: 16.0,
                      ),
                      labelText: 'City',
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: dateCtrl,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(10.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                labelStyle: TextStyle(
                  fontSize: 16.0,
                ),
                labelText: 'BirthDate',
              ),
              onTap: () async {
                // Prevents keyboard from showing
                FocusScope.of(context).requestFocus(FocusNode());
                final DateTime newDate = await showDatePicker(
                  context: context,
                  initialDate: widget.contact.birthDate ?? DateTime.now(),
                  lastDate: DateTime.now(),
                  firstDate: DateTime(1900),
                );
                if (newDate != null) {
                  dateCtrl.text = newDate.pretty();
                  setState(() {
                    editedContactBirthDay = newDate;
                  });
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: commentCtrl,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(10.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                labelStyle: TextStyle(
                  fontSize: 16.0,
                ),
                labelText: 'Comment',
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () => Navigator.pop(context),
                color: Colors.red,
              ),
              RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: Text(
                  'Validate',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () => Navigator.pop(
                  context,
                  Contact(
                    editedContactType,
                    nameCtrl.text,
                    telCtrl.text,
                    emailCtrl.text,
                    addressCtrl.text,
                    zipCtrl.text,
                    cityCtrl.text,
                    editedContactBirthDay,
                    commentCtrl.text,
                  ),
                ),
                color: Colors.green,
              ),
            ],
          )
        ],
      ),
    );
  }
}
