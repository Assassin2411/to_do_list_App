class ProfileModel {
  const ProfileModel({
    required this.id,
    required this.email,
    required this.profileUrl,
    required this.fcmToken,
    required this.latitude,
    required this.longitude,
    required this.dateOfBirth,
    required this.accountCreatedDate,
    required this.lastOnline,
    required this.name,
  });

  final String id;
  final String name;
  final String email;
  final String profileUrl;
  final String fcmToken;
  final double latitude;
  final double longitude;
  final DateTime dateOfBirth;
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
      'longitude': longitude,
      'dateOfBirth': dateOfBirth,
      'accountCreatedDate': accountCreatedDate,
      'lastOnline': lastOnline,
    };
  }

  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      profileUrl: map['profileUrl'],
      fcmToken: map['fcmToken'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      dateOfBirth: map['dateOfBirth'],
      accountCreatedDate: map['accountCreatedDate'],
      lastOnline: map['lastOnline'],
    );
  }
}
