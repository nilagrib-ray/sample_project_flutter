/// Abstract contract for trip-related data. Implementations fetch from API or
/// cache; the app code that uses this doesn't care where the data comes from.
abstract class TripRepository {
  /// Fetches all trips for a user. Returns raw map (to be parsed by caller).
  Future<Map<String, dynamic>> getTrips(String userId);

  /// Gets only upcoming trips (future dates). Returns a list of trip data.
  Future<List<dynamic>> getUpcomingTrips();

  /// Fetches full details for one trip. At least one of packageId, bookingId,
  /// or orderId is typically needed to identify the trip.
  Future<Map<String, dynamic>> getTripDetails({
    int? packageId,
    int? bookingId,
    String? orderId,
    required String userId,
  });

  /// Fetches the itinerary (day-by-day schedule) for a specific booking and date.
  Future<Map<String, dynamic>> getItinerary({
    required int bookingId,
    required String eventDate,
    required String userId,
  });
}
