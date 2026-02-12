import 'dart:developer' as developer;
import '../../core/utils/resource.dart';
import '../../data/remote/dto/trip_details_dto.dart';
import '../../data/mapper/trip_details_mapper.dart';
import '../model/trip_details_domain.dart';
import '../repository/auth_repository.dart';
import '../repository/trip_repository.dart';

/// A use case is a single piece of business logic.
/// This one fetches the day-by-day itinerary (schedule of events) for a trip.
class GetItineraryUseCase {
  final TripRepository _tripRepository;
  final AuthRepository _authRepository;

  GetItineraryUseCase({
    required TripRepository tripRepository,
    required AuthRepository authRepository,
  })  : _tripRepository = tripRepository,
        _authRepository = authRepository;

  /// Returns a stream of loading/success/error states (`Resource` of `ItineraryDomain`).
  /// `async*` creates a stream; `yield` sends each value through the stream to the UI.
  Stream<Resource<ItineraryDomain>> call({
    required int bookingId,
    required String eventDate,
  }) async* {
    try {
      // Step 1: Tell the UI we're loading (shows a spinner)
      yield const ResourceLoading();

      // Step 2: Check if user is logged in - API requires userId
      final userData = await _authRepository.getUserData();
      if (userData == null) {
        developer.log('User not logged in', name: 'GetItineraryUseCase');
        yield const ResourceError(
            'User not logged in. Please login again.');
        return;
      }

      developer.log(
          'Fetching itinerary for bookingId: $bookingId, date: $eventDate',
          name: 'GetItineraryUseCase');

      // Step 3: Call the API to get itinerary for this booking and date
      final responseData = await _tripRepository.getItinerary(
        bookingId: bookingId,
        eventDate: eventDate,
        userId: userData.userId,
      );

      // Step 4: Convert API response to domain model
      final itineraryResponse =
          ItineraryResponse.fromJson(responseData);
      final itinerary = itineraryResponse.toDomain();

      developer.log(
          'Itinerary loaded: ${itinerary.events.length} events',
          name: 'GetItineraryUseCase');
      // Step 5: Tell the UI we have the data
      yield ResourceSuccess(itinerary);
    } on Exception catch (e) {
      developer.log('Exception in getItinerary: $e',
          name: 'GetItineraryUseCase');
      yield ResourceError(e.toString());
    }
  }
}
