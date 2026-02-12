import 'package:flutter/foundation.dart';
import '../../core/utils/resource.dart';
import '../../domain/usecase/login_usecase.dart';

/// UiState: An immutable snapshot of everything the Login screen needs to display.
/// The UI reads this and rebuilds when it changes.
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

  /// copyWith: Creates a new copy of the state with some fields changed.
  /// States are immutable, so we never edit the old one—we create a new one.
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

/// ChangeNotifier: A Flutter class that can tell the UI to rebuild when data changes.
/// When we call notifyListeners(), all listening widgets rebuild.
class LoginViewModel extends ChangeNotifier {
  // The _ prefix makes this private—only accessible within this file
  final LoginUseCase _loginUseCase;

  LoginViewModel({required LoginUseCase loginUseCase})
      : _loginUseCase = loginUseCase;

  LoginUiState _uiState = const LoginUiState();
  LoginUiState get uiState => _uiState;

  void onEmailChange(String email) {
    _uiState = _uiState.copyWith(email: email, clearEmailError: true);
    notifyListeners(); // Tells UI: "my data changed, please rebuild"
  }

  void onPasswordChange(String password) {
    _uiState = _uiState.copyWith(password: password, clearPasswordError: true);
    notifyListeners();
  }

  Future<void> login() async {
    if (!_validateInput()) return;

    // await for: Listens to each value from the Stream one at a time
    await for (final resource in _loginUseCase(_uiState.email, _uiState.password)) {
      // switch on Resource: Pattern matching—checks if result is Loading, Success, or Error
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
          // (:final message): Destructuring—extracts the message field from the object
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
      // Email regex: ^[\w-\.]+ = local part (letters, digits, underscore, hyphen, dot)
      // @ = literal at-sign
      // ([\w-]+\.)+ = domain parts like "gmail." or "co."
      // [\w-]{2,4}$ = top-level domain (e.g. com, org) 2–4 chars at end
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
