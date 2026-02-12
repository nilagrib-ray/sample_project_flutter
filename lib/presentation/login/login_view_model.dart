import 'package:flutter/foundation.dart';
import '../../core/utils/resource.dart';
import '../../domain/usecase/login_usecase.dart';

class LoginUiState {
  final String email;
  final String password;
  final String? emailError;
  final String? passwordError;
  final bool isLoading;
  final String? errorMessage;
  final bool isSuccess;

  const LoginUiState({
    this.email = '',
    this.password = '',
    this.emailError,
    this.passwordError,
    this.isLoading = false,
    this.errorMessage,
    this.isSuccess = false,
  });

  LoginUiState copyWith({
    String? email,
    String? password,
    String? emailError,
    String? passwordError,
    bool? isLoading,
    String? errorMessage,
    bool? isSuccess,
    bool clearEmailError = false,
    bool clearPasswordError = false,
    bool clearErrorMessage = false,
  }) {
    return LoginUiState(
      email: email ?? this.email,
      password: password ?? this.password,
      emailError: clearEmailError ? null : (emailError ?? this.emailError),
      passwordError:
          clearPasswordError ? null : (passwordError ?? this.passwordError),
      isLoading: isLoading ?? this.isLoading,
      errorMessage:
          clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}

class LoginViewModel extends ChangeNotifier {
  final LoginUseCase _loginUseCase;

  LoginViewModel({required LoginUseCase loginUseCase})
      : _loginUseCase = loginUseCase;

  LoginUiState _uiState = const LoginUiState();
  LoginUiState get uiState => _uiState;

  void onEmailChange(String email) {
    _uiState = _uiState.copyWith(email: email, clearEmailError: true);
    notifyListeners();
  }

  void onPasswordChange(String password) {
    _uiState = _uiState.copyWith(password: password, clearPasswordError: true);
    notifyListeners();
  }

  Future<void> login() async {
    if (!_validateInput()) return;

    await for (final resource in _loginUseCase(_uiState.email, _uiState.password)) {
      switch (resource) {
        case ResourceLoading():
          _uiState = _uiState.copyWith(
            isLoading: true,
            clearErrorMessage: true,
          );
          notifyListeners();
        case ResourceSuccess():
          _uiState = _uiState.copyWith(isLoading: false, isSuccess: true);
          notifyListeners();
        case ResourceError(:final message):
          _uiState = _uiState.copyWith(
            isLoading: false,
            errorMessage: message,
          );
          notifyListeners();
      }
    }
  }

  bool _validateInput() {
    final email = _uiState.email.trim();
    final password = _uiState.password;
    bool isValid = true;

    if (email.isEmpty) {
      _uiState = _uiState.copyWith(emailError: 'Email is required');
      isValid = false;
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      _uiState = _uiState.copyWith(emailError: 'Invalid email format');
      isValid = false;
    }

    if (password.isEmpty) {
      _uiState = _uiState.copyWith(passwordError: 'Password is required');
      isValid = false;
    }

    if (!isValid) notifyListeners();
    return isValid;
  }
}
