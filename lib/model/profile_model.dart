import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileModel {
  ProfileModel({
    required this.id,
    required this.email,
    required this.fcmToken,
    required this.latitude,
    required this.longitude,
    required this.dateOfBirth,
    required this.phoneNumber,
    required this.dobUpdate,
    required this.phoneUpdate,
    required this.accountCreatedDate,
    required this.lastOnline,
    required this.name,
    required this.profileUrl,
  });

  final String id;
  final String name;
  final String email;
  String profileUrl;
  bool dobUpdate;
  bool phoneUpdate;
  int phoneNumber;
  final String fcmToken;
  final double latitude;
  final double longitude;
  DateTime dateOfBirth;
  final DateTime accountCreatedDate;
  final DateTime lastOnline;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profileUrl': profileUrl,
      'fcmToken': fcmToken,
      'latitude': latitude,
      'phoneNumber': phoneNumber,
      'dobUpdate': dobUpdate,
      'phoneUpdate': phoneUpdate,
      'longitude': longitude,
      'dateOfBirth': dateOfBirth,
      'accountCreatedDate': accountCreatedDate,
      'lastOnline': lastOnline,
    };
  }

  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      profileUrl: map['profileUrl'] ?? '',
      id: map['id'],
      name: map['name'],
      email: map['email'],
      fcmToken: map['fcmToken'],
      dobUpdate: map['dobUpdate'],
      phoneUpdate: map['phoneUpdate'],
      phoneNumber: map['phoneNumber'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      dateOfBirth: (map['dateOfBirth'] as Timestamp).toDate(),
      accountCreatedDate: (map['accountCreatedDate'] as Timestamp).toDate(),
      lastOnline: (map['lastOnline'] as Timestamp).toDate(),
    );
  }
}

ProfileModel profile = ProfileModel(
    id: '1',
    email: 'mail@website.com',
    fcmToken: '',
    latitude: 26,
    longitude: 70,
    dobUpdate: false,
    phoneUpdate: false,
    phoneNumber: 1234567890,
    dateOfBirth: DateTime.now(),
    accountCreatedDate: DateTime.now(),
    lastOnline: DateTime.now(),
    name: 'Anonymous',
    profileUrl: '');
