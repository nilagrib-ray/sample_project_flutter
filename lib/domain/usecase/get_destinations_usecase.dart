import 'dart:developer' as developer;
import '../../core/utils/resource.dart';
import '../../data/remote/dto/trip_dto.dart';
import '../../data/mapper/trip_mapper.dart';
import '../model/trip_domain.dart';
import '../repository/trip_repository.dart';

/// A use case is a single piece of business logic.
/// This one fetches destination categories (e.g. beaches, mountains) for browsing.
class GetDestinationsUseCase {
  final TripRepository _tripRepository;

  GetDestinationsUseCase({required TripRepository tripRepository})
      : _tripRepository = tripRepository;

  /// Returns a stream of loading/success/error states (`Resource` of destination list).
  /// `async*` creates a stream; `yield` sends each value through the stream to the UI.
  Stream<Resource<List<DestinationCategory>>> call() async* {
    try {
      // Step 1: Tell the UI we're loading (shows a spinner)
      yield const ResourceLoading();

      developer.log('Fetching destination categories...',
          name: 'GetDestinationsUseCase');

      // Step 2: Call the API to get upcoming trips (used to build categories)
      final responseData = await _tripRepository.getUpcomingTrips();
      // Step 3: Convert raw JSON into DTOs, then into domain models
      final categories = responseData
          .map((e) => CategoryDto.fromJson(e as Map<String, dynamic>))
          .toList();
      final destinations = categories.toDestinationCategories();

      developer.log('Destinations loaded: ${destinations.length}',
          name: 'GetDestinationsUseCase');
      // Step 4: Tell the UI we have the data
      yield ResourceSuccess(destinations);
    } on Exception catch (e) {
      developer.log('Exception in getDestinations: $e',
          name: 'GetDestinationsUseCase');
      yield ResourceError(e.toString());
    }
  }
}
