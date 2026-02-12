import '../remote/api_service.dart';
import '../../domain/repository/trip_repository.dart';

class TripRepositoryImpl implements TripRepository {
  final ApiService _apiService;

  TripRepositoryImpl({required ApiService apiService})
      : _apiService = apiService;

  @override
  Future<Map<String, dynamic>> getTrips(String userId) async {
    final response = await _apiService.getTrips(userId);
    return response.data as Map<String, dynamic>;
  }

  @override
  Future<List<dynamic>> getUpcomingTrips() async {
    final response = await _apiService.getUpcomingTrips();
    return response.data as List<dynamic>;
  }

  @override
  Future<Map<String, dynamic>> getTripDetails({
    int? packageId,
    int? bookingId,
    String? orderId,
    required String userId,
  }) async {
    final response = await _apiService.getTripDetails(
      packageId: packageId,
      bookingId: bookingId,
      orderId: orderId,
      userId: userId,
    );
    return response.data as Map<String, dynamic>;
  }

  @override
  Future<Map<String, dynamic>> getItinerary({
    required int bookingId,
    required String eventDate,
    required String userId,
  }) async {
    final response = await _apiService.getItinerary(
      bookingId: bookingId,
      eventDate: eventDate,
      userId: userId,
    );
    return response.data as Map<String, dynamic>;
  }
}
