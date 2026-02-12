import 'dart:developer' as developer;
import '../../core/utils/resource.dart';
import '../../data/remote/dto/trip_dto.dart';
import '../../data/mapper/trip_mapper.dart';
import '../model/trip_domain.dart';
import '../repository/auth_repository.dart';
import '../repository/trip_repository.dart';

class GetTripsUseCase {
  final TripRepository _tripRepository;
  final AuthRepository _authRepository;

  GetTripsUseCase({
    required TripRepository tripRepository,
    required AuthRepository authRepository,
  })  : _tripRepository = tripRepository,
        _authRepository = authRepository;

  Stream<Resource<List<TripDomain>>> call() async* {
    try {
      yield const ResourceLoading();

      final userData = await _authRepository.getUserData();
      if (userData == null) {
        developer.log('User not logged in', name: 'GetTripsUseCase');
        yield const ResourceError('User not logged in. Please login again.');
        return;
      }

      developer.log('Fetching trips for userId: ${userData.userId}',
          name: 'GetTripsUseCase');

      final responseData = await _tripRepository.getTrips(userData.userId);
      final tripsResponse = TripsResponse.fromJson(responseData);

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
      yield ResourceSuccess(allTrips);
    } on Exception catch (e) {
      developer.log('Exception in getTrips: $e', name: 'GetTripsUseCase');
      yield ResourceError(e.toString());
    }
  }
}
