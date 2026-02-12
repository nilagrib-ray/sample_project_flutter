class LoginRequest {
  final String userEmail;
  final String password;

  const LoginRequest({required this.userEmail, required this.password});

  Map<String, dynamic> toJson() => {
        'user_email': userEmail,
        'password': password,
      };
}

class LoginResponse {
  final int userId;
  final String username;
  final String? firstName;
  final String? lastName;
  final String email;
  final String token;
  final String? profileImage;
  final String? guestBookings;
  final String userType;

  const LoginResponse({
    required this.userId,
    required this.username,
    this.firstName,
    this.lastName,
    required this.email,
    required this.token,
    this.profileImage,
    this.guestBookings,
    required this.userType,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      userId: json['user_id'] as int? ?? 0,
      username: json['username'] as String? ?? '',
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      email: json['email'] as String? ?? '',
      token: json['token'] as String? ?? '',
      profileImage: json['profile_image'] as String?,
      guestBookings: json['guest_bookings'] as String?,
      userType: json['user_type'] as String? ?? '',
    );
  }
}

class UserDataDto {
  final String userId;
  final String userType;
  final String userEmail;
  final String? userName;
  final String? token;
  final String? firstName;
  final String? lastName;
  final String? profileImage;

  const UserDataDto({
    required this.userId,
    required this.userType,
    required this.userEmail,
    this.userName,
    this.token,
    this.firstName,
    this.lastName,
    this.profileImage,
  });

  factory UserDataDto.fromJson(Map<String, dynamic> json) {
    return UserDataDto(
      userId: json['user_id']?.toString() ?? '',
      userType: json['user_type'] as String? ?? '',
      userEmail: json['user_email'] as String? ?? '',
      userName: json['user_name'] as String?,
      token: json['token'] as String?,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      profileImage: json['profile_image'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'user_type': userType,
        'user_email': userEmail,
        'user_name': userName,
        'token': token,
        'first_name': firstName,
        'last_name': lastName,
        'profile_image': profileImage,
      };
}
