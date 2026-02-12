import '../model/user_domain.dart';

abstract class AuthRepository {
  Future<Map<String, dynamic>> login(String email, String password);
  Future<void> saveUserData(UserDomain user);
  Future<UserDomain?> getUserData();
  Future<bool> isLoggedIn();
  Future<void> clearUserData();
}
