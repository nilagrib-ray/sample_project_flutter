abstract class TripRepository {
  Future<Map<String, dynamic>> getTrips(String userId);
  Future<List<dynamic>> getUpcomingTrips();
  Future<Map<String, dynamic>> getTripDetails({
    int? packageId,
    int? bookingId,
    String? orderId,
    required String userId,
  });
  Future<Map<String, dynamic>> getItinerary({
    required int bookingId,
    required String eventDate,
    required String userId,
  });
}
