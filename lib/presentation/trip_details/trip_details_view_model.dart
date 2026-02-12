import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import '../../core/utils/resource.dart';
import '../../domain/model/trip_details_domain.dart';
import '../../domain/usecase/get_itinerary_usecase.dart';
import '../../domain/usecase/get_trip_details_usecase.dart';

class TripDetailsUiState {
  final bool isLoading;
  final String tripName;
  final String? description;
  final String? featuredImage;
  final String? destinationImage;
  final String arrivalDate;
  final String? arrivalTime;
  final String departureDate;
  final String? departureTime;
  final String? hotel;
  final String bookingNumber;
  final int daysToGo;
  final int hoursToGo;
  final int minutesToGo;
  final String? destinationName;
  final List<Traveller> travellers;
  final List<ActionRequired> actionsRequired;
  final List<Event> todayEvents;
  final String? bookingTotal;
  final String? bookingBalance;
  final String currencySymbol;
  final String? errorMessage;
  final bool isLoadingItinerary;
  final double? destinationLatitude;
  final double? destinationLongitude;
  final String? meetingPointDetails;

  const TripDetailsUiState({
    this.isLoading = false,
    this.tripName = '',
    this.description,
    this.featuredImage,
    this.destinationImage,
    this.arrivalDate = '',
    this.arrivalTime,
    this.departureDate = '',
    this.departureTime,
    this.hotel,
    this.bookingNumber = '',
    this.daysToGo = 0,
    this.hoursToGo = 0,
    this.minutesToGo = 0,
    this.destinationName,
    this.travellers = const [],
    this.actionsRequired = const [],
    this.todayEvents = const [],
    this.bookingTotal,
    this.bookingBalance,
    this.currencySymbol = '£',
    this.errorMessage,
    this.isLoadingItinerary = false,
    this.destinationLatitude,
    this.destinationLongitude,
    this.meetingPointDetails,
  });

  TripDetailsUiState copyWith({
    bool? isLoading,
    String? tripName,
    String? description,
    String? featuredImage,
    String? destinationImage,
    String? arrivalDate,
    String? arrivalTime,
    String? departureDate,
    String? departureTime,
    String? hotel,
    String? bookingNumber,
    int? daysToGo,
    int? hoursToGo,
    int? minutesToGo,
    String? destinationName,
    List<Traveller>? travellers,
    List<ActionRequired>? actionsRequired,
    List<Event>? todayEvents,
    String? bookingTotal,
    String? bookingBalance,
    String? currencySymbol,
    String? errorMessage,
    bool? isLoadingItinerary,
    double? destinationLatitude,
    double? destinationLongitude,
    String? meetingPointDetails,
    bool clearError = false,
  }) {
    return TripDetailsUiState(
      isLoading: isLoading ?? this.isLoading,
      tripName: tripName ?? this.tripName,
      description: description ?? this.description,
      featuredImage: featuredImage ?? this.featuredImage,
      destinationImage: destinationImage ?? this.destinationImage,
      arrivalDate: arrivalDate ?? this.arrivalDate,
      arrivalTime: arrivalTime ?? this.arrivalTime,
      departureDate: departureDate ?? this.departureDate,
      departureTime: departureTime ?? this.departureTime,
      hotel: hotel ?? this.hotel,
      bookingNumber: bookingNumber ?? this.bookingNumber,
      daysToGo: daysToGo ?? this.daysToGo,
      hoursToGo: hoursToGo ?? this.hoursToGo,
      minutesToGo: minutesToGo ?? this.minutesToGo,
      destinationName: destinationName ?? this.destinationName,
      travellers: travellers ?? this.travellers,
      actionsRequired: actionsRequired ?? this.actionsRequired,
      todayEvents: todayEvents ?? this.todayEvents,
      bookingTotal: bookingTotal ?? this.bookingTotal,
      bookingBalance: bookingBalance ?? this.bookingBalance,
      currencySymbol: currencySymbol ?? this.currencySymbol,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isLoadingItinerary: isLoadingItinerary ?? this.isLoadingItinerary,
      destinationLatitude: destinationLatitude ?? this.destinationLatitude,
      destinationLongitude: destinationLongitude ?? this.destinationLongitude,
      meetingPointDetails: meetingPointDetails ?? this.meetingPointDetails,
    );
  }
}

class TripDetailsViewModel extends ChangeNotifier {
  final GetTripDetailsUseCase _getTripDetailsUseCase;
  final GetItineraryUseCase _getItineraryUseCase;

  TripDetailsViewModel({
    required GetTripDetailsUseCase getTripDetailsUseCase,
    required GetItineraryUseCase getItineraryUseCase,
  })  : _getTripDetailsUseCase = getTripDetailsUseCase,
        _getItineraryUseCase = getItineraryUseCase;

  TripDetailsUiState _uiState = const TripDetailsUiState();
  TripDetailsUiState get uiState => _uiState;

  Future<void> loadTripDetails(
      int? packageId, int? bookingId, String? orderId) async {
    await for (final resource in _getTripDetailsUseCase(
      packageId: packageId,
      bookingId: bookingId,
      orderId: orderId,
    )) {
      switch (resource) {
        case ResourceLoading():
          _uiState = _uiState.copyWith(isLoading: true, clearError: true);
          notifyListeners();
          developer.log('Loading trip details...',
              name: 'TripDetailsViewModel');
        case ResourceSuccess(:final data):
          developer.log('Trip details loaded: ${data.tripName}',
              name: 'TripDetailsViewModel');

          final countdown = _calculateTimeToGo(data.arrivalDate);

          final bookingNumDisplay = () {
            if (data.bookingId != null && data.bookingId != 0) {
              return data.bookingId.toString();
            }
            if (data.orderId != null &&
                data.orderId!.isNotEmpty &&
                data.orderId != 'null') {
              return data.orderId!;
            }
            return 'N/A';
          }();

          _uiState = _uiState.copyWith(
            isLoading: false,
            tripName: data.tripName,
            description: data.description,
            featuredImage: data.featuredImage ?? data.image,
            destinationImage: data.destinationImage,
            arrivalDate: data.arrivalDate,
            arrivalTime: data.arrivalTime,
            departureDate: data.departureDate,
            departureTime: data.departureTime,
            hotel: data.hotel,
            bookingNumber: bookingNumDisplay,
            daysToGo: countdown.$1,
            hoursToGo: countdown.$2,
            minutesToGo: countdown.$3,
            destinationName: data.destinationName,
            travellers: data.travellers,
            actionsRequired: data.actionsRequired,
            bookingTotal: data.bookingTotal,
            bookingBalance: data.bookingBalance,
            currencySymbol: '£',
            destinationLatitude: data.destinationLatitude,
            destinationLongitude: data.destinationLongitude,
            meetingPointDetails: data.meetingPointDetails,
          );
          notifyListeners();

          // Load itinerary if booking ID is available
          if (data.bookingId != null && data.bookingId! > 0) {
            _loadItinerary(data.bookingId!);
          }

        case ResourceError(:final message):
          developer.log('Error loading trip details: $message',
              name: 'TripDetailsViewModel');
          _uiState = _uiState.copyWith(
            isLoading: false,
            errorMessage: message,
          );
          notifyListeners();
      }
    }
  }

  Future<void> _loadItinerary(int bookingId) async {
    _uiState = _uiState.copyWith(isLoadingItinerary: true);
    notifyListeners();

    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    developer.log(
        'Loading itinerary for booking $bookingId on $today',
        name: 'TripDetailsViewModel');

    await for (final resource in _getItineraryUseCase(
      bookingId: bookingId,
      eventDate: today,
    )) {
      switch (resource) {
        case ResourceLoading():
          developer.log('Loading itinerary...',
              name: 'TripDetailsViewModel');
        case ResourceSuccess(:final data):
          developer.log('Itinerary loaded: ${data.events.length} events',
              name: 'TripDetailsViewModel');
          _uiState = _uiState.copyWith(
            isLoadingItinerary: false,
            todayEvents: data.events,
          );
          notifyListeners();
        case ResourceError(:final message):
          developer.log('Error loading itinerary: $message',
              name: 'TripDetailsViewModel');
          _uiState = _uiState.copyWith(isLoadingItinerary: false);
          notifyListeners();
      }
    }
  }

  (int, int, int) _calculateTimeToGo(String dateString) {
    try {
      if (dateString.isEmpty) return (0, 0, 0);

      final tripDate = DateTime.parse(dateString);
      final now = DateTime.now();

      if (tripDate.isAfter(now)) {
        final diff = tripDate.difference(now);
        final days = diff.inDays;
        final hours = diff.inHours % 24;
        final minutes = diff.inMinutes % 60;
        return (days, hours, minutes);
      }
      return (0, 0, 0);
    } catch (_) {
      return (0, 0, 0);
    }
  }
}
