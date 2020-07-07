import 'package:faker/faker.dart';

class Contact {
  final ContactType type;
  final String name;
  final String tel;
  final String email;
  final String address;
  final String postalCode;
  final String city;
  final DateTime birthDate;
  final String comment;

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
      faker.date.dateTime(),
      faker.lorem.sentence(),
    );
  }
}

enum ContactType { personal, business }
