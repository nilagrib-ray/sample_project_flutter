import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import '../../core/utils/resource.dart';
import '../../domain/model/contact_domain.dart';
import '../../domain/usecase/get_contacts_usecase.dart';

/// UiState: An immutable snapshot of everything the Messages screen needs to display.
class MessagesUiState {
  final bool isLoading;
  final String destinationName;
  final List<ContactDomain> reps;
  final String emergencyNumber;
  final String globalEmergencyNumber;
  final String phtContactPhone;
  final String? errorMessage;

  const MessagesUiState({
    this.isLoading = false,
    this.destinationName = '',
    this.reps = const [],
    this.emergencyNumber = '',
    this.globalEmergencyNumber = '447984290932',
    this.phtContactPhone = '0203 627 4443',
    this.errorMessage,
  });

  /// copyWith: Creates a new copy of the state with some fields changed.
  MessagesUiState copyWith({
    bool? isLoading,
    String? destinationName,
    List<ContactDomain>? reps,
    String? emergencyNumber,
    String? globalEmergencyNumber,
    String? phtContactPhone,
    String? errorMessage,
    bool clearError = false,
  }) {
    return MessagesUiState(
      isLoading: isLoading ?? this.isLoading,
      destinationName: destinationName ?? this.destinationName,
      reps: reps ?? this.reps,
      emergencyNumber: emergencyNumber ?? this.emergencyNumber,
      globalEmergencyNumber:
          globalEmergencyNumber ?? this.globalEmergencyNumber,
      phtContactPhone: phtContactPhone ?? this.phtContactPhone,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

/// ChangeNotifier: Tells the UI to rebuild when data changes.
class MessagesViewModel extends ChangeNotifier {
  final GetContactsUseCase _getContactsUseCase;

  /// Constructor body: Loads contacts immediately when the ViewModel is created.
  MessagesViewModel({required GetContactsUseCase getContactsUseCase})
      : _getContactsUseCase = getContactsUseCase {
    loadContacts();
  }

  MessagesUiState _uiState = const MessagesUiState();
  MessagesUiState get uiState => _uiState;

  Future<void> loadContacts() async {
    _uiState = _uiState.copyWith(isLoading: true, clearError: true);
    notifyListeners();

    await for (final resource in _getContactsUseCase()) {
      switch (resource) {
        case ResourceLoading():
          developer.log('Loading contacts...', name: 'MessagesViewModel');
        case ResourceSuccess(:final data):
          developer.log(
              'Contacts loaded successfully: ${data.reps.length} reps',
              name: 'MessagesViewModel');
          // Use API data when available; fall back to default emergency numbers
          _uiState = _uiState.copyWith(
            isLoading: false,
            destinationName: data.destinationName,
            reps: data.reps,
            emergencyNumber: data.emergencyNumber ?? '0203 627 4443',
            globalEmergencyNumber:
                data.globalEmergencyNumber ?? '447984290932',
            phtContactPhone: data.phtContactPhone ?? '0203 627 4443',
          );
          notifyListeners();
        case ResourceError(:final message):
          developer.log('Error loading contacts: $message',
              name: 'MessagesViewModel');
          _uiState = _uiState.copyWith(
            isLoading: false,
            errorMessage: message,
          );
          notifyListeners();
      }
    }
  }
}
