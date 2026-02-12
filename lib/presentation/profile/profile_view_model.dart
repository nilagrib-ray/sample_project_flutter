import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import '../../domain/repository/auth_repository.dart';

class ProfileUiState {
  final String userEmail;
  final String userName;
  final String? profileImage;

  const ProfileUiState({
    this.userEmail = '',
    this.userName = 'Developer',
    this.profileImage,
  });

  ProfileUiState copyWith({
    String? userEmail,
    String? userName,
    String? profileImage,
  }) {
    return ProfileUiState(
      userEmail: userEmail ?? this.userEmail,
      userName: userName ?? this.userName,
      profileImage: profileImage ?? this.profileImage,
    );
  }
}

class ProfileViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;

  ProfileViewModel({required AuthRepository authRepository})
      : _authRepository = authRepository {
    _loadUserData();
  }

  ProfileUiState _uiState = const ProfileUiState();
  ProfileUiState get uiState => _uiState;

  Future<void> _loadUserData() async {
    final userData = await _authRepository.getUserData();
    if (userData != null) {
      _uiState = _uiState.copyWith(
        userEmail: userData.userEmail,
        userName: userData.firstName ?? userData.userName ?? 'Developer',
        profileImage: userData.profileImage,
      );
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _authRepository.clearUserData();
    developer.log('User logged out successfully', name: 'ProfileViewModel');
  }
}
