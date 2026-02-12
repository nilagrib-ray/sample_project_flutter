import 'dart:developer' as developer;
import '../../core/utils/resource.dart';
import '../../data/remote/dto/trip_dto.dart';
import '../../data/mapper/trip_mapper.dart';
import '../model/trip_domain.dart';
import '../repository/auth_repository.dart';
import '../repository/trip_repository.dart';

/// A use case is a single piece of business logic.
/// This one fetches the list of trips (upcoming and previous) for the logged-in user.
class GetTripsUseCase {
  final TripRepository _tripRepository;
  final AuthRepository _authRepository;

  /// Repositories are injected via constructor - this makes testing easier.
  GetTripsUseCase({
    required TripRepository tripRepository,
    required AuthRepository authRepository,
  })  : _tripRepository = tripRepository,
        _authRepository = authRepository;

  /// Returns a stream of loading/success/error states (`Resource` of trip list).
  /// `async*` creates a stream; `yield` sends each value through the stream to the UI.
  Stream<Resource<List<TripDomain>>> call() async* {
    try {
      // Step 1: Tell the UI we're loading (shows a spinner)
      yield const ResourceLoading();

      // Step 2: Check if user is logged in - we need their userId for the API
      final userData = await _authRepository.getUserData();
      if (userData == null) {
        developer.log('User not logged in', name: 'GetTripsUseCase');
        yield const ResourceError('User not logged in. Please login again.');
        return;
      }

      developer.log('Fetching trips for userId: ${userData.userId}',
          name: 'GetTripsUseCase');

      // Step 3: Call the API to get trips
      final responseData = await _tripRepository.getTrips(userData.userId);
      final tripsResponse = TripsResponse.fromJson(responseData);

      // Step 4: Combine upcoming and previous trips into one list
      final allTrips = <TripDomain>[];

      if (tripsResponse.upcomingTrips != null) {
        developer.log(
            'Upcoming trips: ${tripsResponse.upcomingTrips!.length}',
            name: 'GetTripsUseCase');
        allTrips.addAll(tripsResponse.upcomingTrips!.toDomain());
      }

      if (tripsResponse.previousTrips != null) {
        developer.log(
            'Previous trips: ${tripsResponse.previousTrips!.length}',
            name: 'GetTripsUseCase');
        allTrips.addAll(tripsResponse.previousTrips!.toDomain());
      }

      developer.log('Total trips loaded: ${allTrips.length}',
          name: 'GetTripsUseCase');
      // Step 5: Tell the UI we have the data
      yield ResourceSuccess(allTrips);
    } on Exception catch (e) {
      developer.log('Exception in getTrips: $e', name: 'GetTripsUseCase');
      yield ResourceError(e.toString());
    }
  }
}
