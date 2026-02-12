class UserDomain {
  final String userId;
  final String userType;
  final String userEmail;
  final String? userName;
  final String? token;
  final String? firstName;
  final String? lastName;
  final String? profileImage;

  const UserDomain({
    required this.userId,
    required this.userType,
    required this.userEmail,
    this.userName,
    this.token,
    this.firstName,
    this.lastName,
    this.profileImage,
  });
}
