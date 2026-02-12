import 'dart:developer' as developer;
import '../../core/utils/resource.dart';
import '../../data/remote/dto/trip_details_dto.dart';
import '../../data/mapper/trip_details_mapper.dart';
import '../model/trip_details_domain.dart';
import '../repository/auth_repository.dart';
import '../repository/trip_repository.dart';

/// A use case is a single piece of business logic.
/// This one fetches full details for a specific trip (package/booking).
class GetTripDetailsUseCase {
  final TripRepository _tripRepository;
  final AuthRepository _authRepository;

  GetTripDetailsUseCase({
    required TripRepository tripRepository,
    required AuthRepository authRepository,
  })  : _tripRepository = tripRepository,
        _authRepository = authRepository;

  /// Returns a stream of loading/success/error states (`Resource` of `TripDetailsDomain`).
  /// `async*` creates a stream; `yield` sends each value through the stream to the UI.
  Stream<Resource<TripDetailsDomain>> call({
    int? packageId,
    int? bookingId,
    String? orderId,
  }) async* {
    try {
      // Step 1: Tell the UI we're loading (shows a spinner)
      yield const ResourceLoading();

      // Step 2: Check if user is logged in - API requires userId
      final userData = await _authRepository.getUserData();
      if (userData == null) {
        developer.log('User not logged in', name: 'GetTripDetailsUseCase');
        yield const ResourceError(
            'User not logged in. Please login again.');
        return;
      }

      developer.log(
          'Fetching trip details for packageId: $packageId, bookingId: $bookingId',
          name: 'GetTripDetailsUseCase');

      // Step 3: Call the API to get trip details
      final responseData = await _tripRepository.getTripDetails(
        packageId: packageId,
        bookingId: bookingId,
        orderId: orderId,
        userId: userData.userId,
      );

      // Step 4: Convert API response to domain model
      final tripDetailsResponse =
          TripDetailsResponse.fromJson(responseData);
      final tripDetails = tripDetailsResponse.toDomain();

      developer.log('Trip details loaded: ${tripDetails.tripName}',
          name: 'GetTripDetailsUseCase');
      // Step 5: Tell the UI we have the data
      yield ResourceSuccess(tripDetails);
    } on Exception catch (e) {
      developer.log('Exception in getTripDetails: $e',
          name: 'GetTripDetailsUseCase');
      yield ResourceError(e.toString());
    }
  }
}
