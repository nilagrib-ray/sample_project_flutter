// DTOs (Data Transfer Objects) are classes that match the structure of JSON
// data sent or received from the server. They let us work with structured
// objects instead of raw JSON maps.

/// Request body sent when the user logs in (email + password).
class LoginRequest {
  final String userEmail;
  final String password;

  const LoginRequest({required this.userEmail, required this.password});

  /// Converts this object to a JSON map for sending to the server.
  /// Keys use snake_case to match the API (e.g. 'user_email').
  Map<String, dynamic> toJson() => {
        'user_email': userEmail,
        'password': password,
      };
}

/// Response from the login API containing user info and auth token.
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

  /// Factory constructor: creates a LoginResponse from a JSON map.
  /// Used when we receive data from the server and need to turn it into an object.
  /// The ?? operator provides a default value when the JSON field is null.
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

/// User data stored locally after login (user info + token for API calls).
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

  /// Creates UserDataDto from JSON (e.g. when loading from local storage).
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

  /// Converts to JSON for saving to local storage.
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
