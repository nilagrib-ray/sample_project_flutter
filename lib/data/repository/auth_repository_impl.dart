import '../local/preferences_manager.dart';
import '../mapper/user_mapper.dart';
import '../remote/api_service.dart';
import '../remote/dto/login_dto.dart';
import '../../domain/model/user_domain.dart';
import '../../domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiService _apiService;
  final PreferencesManager _preferencesManager;

  AuthRepositoryImpl({
    required ApiService apiService,
    required PreferencesManager preferencesManager,
  })  : _apiService = apiService,
        _preferencesManager = preferencesManager;

  @override
  Future<Map<String, dynamic>> login(String email, String password) async {
    final request = LoginRequest(userEmail: email, password: password);
    final response = await _apiService.login(request.toJson());
    return response.data as Map<String, dynamic>;
  }

  @override
  Future<void> saveUserData(UserDomain user) async {
    await _preferencesManager.saveUserData(user.toDto());
  }

  @override
  Future<UserDomain?> getUserData() async {
    final dto = await _preferencesManager.getUserData();
    return dto?.toDomain();
  }

  @override
  Future<bool> isLoggedIn() async {
    return _preferencesManager.isLoggedIn();
  }

  @override
  Future<void> clearUserData() async {
    return _preferencesManager.clearUserData();
  }
}
