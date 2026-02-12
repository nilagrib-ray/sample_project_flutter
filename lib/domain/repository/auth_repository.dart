import '../model/user_domain.dart';

/// An abstract class is a contract: it defines WHAT methods must exist, but not
/// HOW they work. The actual implementation (e.g. calling a real API, using
/// local storage) lives elsewhere. This lets you swap implementations (e.g. for
/// testing) without changing the code that uses this repository.
abstract class AuthRepository {
  /// Attempts to log in with email and password. Returns a map with user data
  /// or error info. The caller handles parsing the response.
  Future<Map<String, dynamic>> login(String email, String password);

  /// Saves user data locally (e.g. to device storage) so the user stays logged in.
  Future<void> saveUserData(UserDomain user);

  /// Retrieves saved user data. Returns null if no user is stored.
  Future<UserDomain?> getUserData();

  /// Returns true if the user has valid saved data and is considered logged in.
  Future<bool> isLoggedIn();

  /// Clears all saved user data (logout).
  Future<void> clearUserData();
}
