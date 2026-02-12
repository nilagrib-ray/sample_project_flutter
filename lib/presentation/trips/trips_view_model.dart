import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import '../../core/utils/resource.dart';
import '../../domain/model/trip_domain.dart';
import '../../domain/repository/auth_repository.dart';
import '../../domain/usecase/get_destinations_usecase.dart';
import '../../domain/usecase/get_trips_usecase.dart';

/// UiState: An immutable snapshot of everything the Trips screen needs to display.
class TripsUiState {
  final bool isLoading;
  final List<TripDomain> upcomingTrips;
  final List<DestinationCategory> destinations;
  final List<TripDomain> previousTrips;
  final String? errorMessage;

  const TripsUiState({
    this.isLoading = false,
    this.upcomingTrips = const [],
    this.destinations = const [],
    this.previousTrips = const [],
    this.errorMessage,
  });

  /// copyWith: Creates a new copy of the state with some fields changed.
  TripsUiState copyWith({
    bool? isLoading,
    List<TripDomain>? upcomingTrips,
    List<DestinationCategory>? destinations,
    List<TripDomain>? previousTrips,
    String? errorMessage,
    bool clearError = false,
  }) {
    return TripsUiState(
      isLoading: isLoading ?? this.isLoading,
      upcomingTrips: upcomingTrips ?? this.upcomingTrips,
      destinations: destinations ?? this.destinations,
      previousTrips: previousTrips ?? this.previousTrips,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

/// ChangeNotifier: Tells the UI to rebuild when data changes.
class TripsViewModel extends ChangeNotifier {
  final GetTripsUseCase _getTripsUseCase;
  final GetDestinationsUseCase _getDestinationsUseCase;
  final AuthRepository _authRepository;

  /// Constructor body in { }: Code that runs right when the ViewModel is created.
  /// Here we load trips and destinations immediately.
  TripsViewModel({
    required GetTripsUseCase getTripsUseCase,
    required GetDestinationsUseCase getDestinationsUseCase,
    required AuthRepository authRepository,
  })  : _getTripsUseCase = getTripsUseCase,
        _getDestinationsUseCase = getDestinationsUseCase,
        _authRepository = authRepository {
    loadAllTrips();
    loadDestinations();
  }

  TripsUiState _uiState = const TripsUiState();
  TripsUiState get uiState => _uiState;

  Future<void> loadAllTrips() async {
    _uiState = _uiState.copyWith(isLoading: true, clearError: true);
    notifyListeners();

    await for (final resource in _getTripsUseCase()) {
      switch (resource) {
        case ResourceLoading():
          developer.log('Loading trips...', name: 'TripsViewModel');
        case ResourceSuccess(:final data):
          developer.log('Trips loaded successfully: ${data.length}',
              name: 'TripsViewModel');
          // Split trips: _isUpcoming returns true if start date is in the future
          _uiState = _uiState.copyWith(
            isLoading: false,
            upcomingTrips: data.where((t) => _isUpcoming(t.startDate)).toList(),
            previousTrips:
                data.where((t) => !_isUpcoming(t.startDate)).toList(),
          );
          notifyListeners();
        case ResourceError(:final message):
          developer.log('Error loading trips: $message',
              name: 'TripsViewModel');
          _uiState = _uiState.copyWith(
            isLoading: false,
            errorMessage: message,
          );
          notifyListeners();
      }
    }
  }

  Future<void> loadDestinations() async {
    await for (final resource in _getDestinationsUseCase()) {
      switch (resource) {
        case ResourceLoading():
          developer.log('Loading destinations...', name: 'TripsViewModel');
        case ResourceSuccess(:final data):
          developer.log('Destinations loaded: ${data.length}',
              name: 'TripsViewModel');
          _uiState = _uiState.copyWith(destinations: data);
          notifyListeners();
        case ResourceError(:final message):
          developer.log('Error loading destinations: $message',
              name: 'TripsViewModel');
      }
    }
  }

  Future<void> logout() async {
    await _authRepository.clearUserData();
    developer.log('User logged out successfully', name: 'TripsViewModel');
  }

  /// _isUpcoming: Returns true if the trip's start date is after now (future trips).
  /// Trips in the past go to previousTrips; upcoming ones go to upcomingTrips.
  bool _isUpcoming(String dateString) {
    try {
      final tripDate = DateTime.parse(dateString);
      return tripDate.isAfter(DateTime.now());
    } catch (_) {
      return false;
    }
  }
}
