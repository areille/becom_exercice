import 'package:faker/faker.dart';

class Contact {
  int id;
  ContactType type;
  String name;
  String tel;
  String email;
  String address;
  String postalCode;
  String city;
  DateTime birthDate;
  String comment;

  Contact(
    this.type,
    this.name,
    this.tel,
    this.email,
    this.address,
    this.postalCode,
    this.city,
    this.birthDate,
    this.comment,
  );

  factory Contact.random() {
    final faker = Faker();
    return Contact(
      faker.randomGenerator.boolean()
          ? ContactType.personal
          : ContactType.business,
      faker.person.name(),
      '01 23 45 67 89',
      faker.internet.email(),
      faker.address.streetAddress(),
      faker.address.zipCode(),
      faker.address.city(),
      faker.date.dateTime(minYear: 1900, maxYear: 2020),
      faker.lorem.sentence(),
    );
  }

  @override
  String toString() => '''
{
  name: $name,
}
''';
}

enum ContactType { personal, business }
