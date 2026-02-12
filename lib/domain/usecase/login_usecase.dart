import 'dart:developer' as developer;
import '../../core/utils/resource.dart';
import '../../data/remote/dto/login_dto.dart';
import '../../data/mapper/user_mapper.dart';
import '../repository/auth_repository.dart';

class LoginUseCase {
  final AuthRepository _repository;

  LoginUseCase({required AuthRepository repository})
      : _repository = repository;

  Stream<Resource<bool>> call(String email, String password) async* {
    try {
      if (password.length < 6) {
        yield const ResourceError('PIN must be at least 6 characters long.');
        return;
      }

      yield const ResourceLoading();

      final responseData = await _repository.login(email, password);
      final loginResponse = LoginResponse.fromJson(responseData);
      final userDomain = loginResponse.toDomain();

      await _repository.saveUserData(userDomain);

      developer.log('Login successful for user: ${userDomain.userEmail}',
          name: 'LoginUseCase');
      yield const ResourceSuccess(true);
    } on Exception catch (e) {
      developer.log('Exception during login: $e', name: 'LoginUseCase');
      yield ResourceError(e.toString());
    }
  }
}
