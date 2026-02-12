import '../remote/dto/login_dto.dart';
import '../../domain/model/user_domain.dart';

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
