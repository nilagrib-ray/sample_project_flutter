import 'dart:developer' as developer;
import '../../core/utils/resource.dart';
import '../../data/remote/dto/trip_dto.dart';
import '../../data/mapper/trip_mapper.dart';
import '../model/trip_domain.dart';
import '../repository/trip_repository.dart';

class GetDestinationsUseCase {
  final TripRepository _tripRepository;

  GetDestinationsUseCase({required TripRepository tripRepository})
      : _tripRepository = tripRepository;

  Stream<Resource<List<DestinationCategory>>> call() async* {
    try {
      yield const ResourceLoading();

      developer.log('Fetching destination categories...',
          name: 'GetDestinationsUseCase');

      final responseData = await _tripRepository.getUpcomingTrips();
      final categories = responseData
          .map((e) => CategoryDto.fromJson(e as Map<String, dynamic>))
          .toList();
      final destinations = categories.toDestinationCategories();

      developer.log('Destinations loaded: ${destinations.length}',
          name: 'GetDestinationsUseCase');
      yield ResourceSuccess(destinations);
    } on Exception catch (e) {
      developer.log('Exception in getDestinations: $e',
          name: 'GetDestinationsUseCase');
      yield ResourceError(e.toString());
    }
  }
}
