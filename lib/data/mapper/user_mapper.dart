import '../remote/dto/login_dto.dart';
import '../../domain/model/user_domain.dart';

/// Mappers convert one data format to another.
/// Why? API data (DTOs) often has different structure than our app models (Domain).
/// Keeping them separate means API changes don't break the rest of the app.

/// In Dart, extensions let you add methods to existing classes without modifying them.
/// This extension adds toDomain() to LoginResponse (API format) so we can convert to UserDomain (app format).
extension LoginResponseMapper on LoginResponse {
  UserDomain toDomain() {
    return UserDomain(
      userId: userId.toString(),
      userType: userType,
      userEmail: email,
      userName: username,
      token: token,
      firstName: firstName,
      lastName: lastName,
      profileImage: profileImage,
    );
  }
}

/// Converts UserDataDto (stored/cached format) to UserDomain (app format).
extension UserDataDtoMapper on UserDataDto {
  UserDomain toDomain() {
    return UserDomain(
      userId: userId,
      userType: userType,
      userEmail: userEmail,
      userName: userName,
      token: token,
      firstName: firstName,
      lastName: lastName,
      profileImage: profileImage,
    );
  }
}

/// Converts UserDomain back to UserDataDto for saving to local storage.
extension UserDomainMapper on UserDomain {
  UserDataDto toDto() {
    return UserDataDto(
      userId: userId,
      userType: userType,
      userEmail: userEmail,
      userName: userName,
      token: token,
      firstName: firstName,
      lastName: lastName,
      profileImage: profileImage,
    );
  }
}
