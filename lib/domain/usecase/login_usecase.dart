import 'dart:developer' as developer;
import '../../core/utils/resource.dart';
import '../../data/remote/dto/login_dto.dart';
import '../../data/mapper/user_mapper.dart';
import '../repository/auth_repository.dart';

/// A use case is a single piece of business logic.
/// This one handles user login: validating credentials and saving the user session.
class LoginUseCase {
  /// The repository talks to the API and local storage. We inject it so we can test easily.
  final AuthRepository _repository;

  LoginUseCase({required AuthRepository repository})
      : _repository = repository;

  /// Returns a stream of loading/success/error states (`Resource` of bool).
  /// `async*` creates a stream generator -- we can send multiple values over time with `yield`.
  Stream<Resource<bool>> call(String email, String password) async* {
    try {
      // Validate PIN length before calling the API
      if (password.length < 6) {
        yield const ResourceError('PIN must be at least 6 characters long.');
        return;
      }

      // Step 1: Tell the UI we're loading (shows a spinner)
      yield const ResourceLoading();

      // Step 2: Call the API to attempt login
      final responseData = await _repository.login(email, password);
      final loginResponse = LoginResponse.fromJson(responseData);
      final userDomain = loginResponse.toDomain();

      // Step 3: Save user data locally so we know they're logged in
      await _repository.saveUserData(userDomain);

      // developer.log prints debug messages to the console (helpful during development)
      developer.log('Login successful for user: ${userDomain.userEmail}',
          name: 'LoginUseCase');
      // Step 4: Tell the UI login succeeded
      yield const ResourceSuccess(true);
    } on Exception catch (e) {
      developer.log('Exception during login: $e', name: 'LoginUseCase');
      // If anything fails, tell the UI there was an error
      yield ResourceError(e.toString());
    }
  }
}
