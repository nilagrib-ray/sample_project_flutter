import 'dart:developer' as developer;
import '../../core/utils/resource.dart';
import '../../data/remote/dto/trip_details_dto.dart';
import '../../data/mapper/trip_details_mapper.dart';
import '../model/trip_details_domain.dart';
import '../repository/auth_repository.dart';
import '../repository/trip_repository.dart';

class GetTripDetailsUseCase {
  final TripRepository _tripRepository;
  final AuthRepository _authRepository;

  GetTripDetailsUseCase({
    required TripRepository tripRepository,
    required AuthRepository authRepository,
  })  : _tripRepository = tripRepository,
        _authRepository = authRepository;

  Stream<Resource<TripDetailsDomain>> call({
    int? packageId,
    int? bookingId,
    String? orderId,
  }) async* {
    try {
      yield const ResourceLoading();

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

      final responseData = await _tripRepository.getTripDetails(
        packageId: packageId,
        bookingId: bookingId,
        orderId: orderId,
        userId: userData.userId,
      );

      final tripDetailsResponse =
          TripDetailsResponse.fromJson(responseData);
      final tripDetails = tripDetailsResponse.toDomain();

      developer.log('Trip details loaded: ${tripDetails.tripName}',
          name: 'GetTripDetailsUseCase');
      yield ResourceSuccess(tripDetails);
    } on Exception catch (e) {
      developer.log('Exception in getTripDetails: $e',
          name: 'GetTripDetailsUseCase');
      yield ResourceError(e.toString());
    }
  }
}
