import 'dart:developer' as developer;
import '../../core/utils/resource.dart';
import '../../data/remote/dto/trip_details_dto.dart';
import '../../data/mapper/trip_details_mapper.dart';
import '../model/trip_details_domain.dart';
import '../repository/auth_repository.dart';
import '../repository/trip_repository.dart';

class GetItineraryUseCase {
  final TripRepository _tripRepository;
  final AuthRepository _authRepository;

  GetItineraryUseCase({
    required TripRepository tripRepository,
    required AuthRepository authRepository,
  })  : _tripRepository = tripRepository,
        _authRepository = authRepository;

  Stream<Resource<ItineraryDomain>> call({
    required int bookingId,
    required String eventDate,
  }) async* {
    try {
      yield const ResourceLoading();

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

      final responseData = await _tripRepository.getItinerary(
        bookingId: bookingId,
        eventDate: eventDate,
        userId: userData.userId,
      );

      final itineraryResponse =
          ItineraryResponse.fromJson(responseData);
      final itinerary = itineraryResponse.toDomain();

      developer.log(
          'Itinerary loaded: ${itinerary.events.length} events',
          name: 'GetItineraryUseCase');
      yield ResourceSuccess(itinerary);
    } on Exception catch (e) {
      developer.log('Exception in getItinerary: $e',
          name: 'GetItineraryUseCase');
      yield ResourceError(e.toString());
    }
  }
}
