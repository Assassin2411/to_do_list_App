class ProfileModel {
  const ProfileModel(
    this.email,
    this.profileUrl,
    this.fcmToken,
    this.latitude,
    this.longitude,
    this.dateOfBirth,
    this.accountCreatedDate,
    this.lastOnline, {
    required this.name,
  });
  final String name;
  final String email;
  final String profileUrl;
  final String fcmToken;
  final double latitude;
  final double longitude;
  final DateTime dateOfBirth;
  final DateTime accountCreatedDate;
  final DateTime lastOnline;
}
