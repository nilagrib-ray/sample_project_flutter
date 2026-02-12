import 'package:dio/dio.dart';
import '../../core/utils/constants.dart';

/// HTTP client for talking to the backend API. Dio is a popular Flutter/Dart
/// library for making HTTP requests (similar to Retrofit in Android).
class ApiService {
  final Dio _dio;

  /// If no Dio is passed in, we create one with default settings.
  ApiService({Dio? dio}) : _dio = dio ?? _createDio();

  /// Creates and configures the Dio instance used for all API calls.
  static Dio _createDio() {
    final dio = Dio(
      /// BaseOptions: default settings applied to every request.
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {
          'App-Token': AppConstants.appToken,
          'Content-Type': 'application/json',
        },
      ),
    );

    /// Interceptors run before/after every request (like middleware).
    /// LogInterceptor prints request and response data for debugging.
    dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        // ignore: avoid_print
        logPrint: (obj) => print('[API] $obj'),
      ),
    );

    return dio;
  }

  /// Sends email and password to login. Returns user info and auth token.
  Future<Response> login(Map<String, dynamic> body) async {
    return _dio.post('mobileapp/v1/login', data: body);
  }

  /// Fetches all trips (upcoming + previous) for a user.
  Future<Response> getTrips(String userId) async {
    return _dio.get('mobileapp/v1/trips', queryParameters: {
      'user_id': userId,
    });
  }

  /// Fetches only upcoming trips for the logged-in user.
  Future<Response> getUpcomingTrips() async {
    return _dio.get('mobileapp/v1/upcoming-trips');
  }

  /// Fetches user profile info by user ID.
  Future<Response> getUserInfo(String userId) async {
    return _dio.get('mobileapp/v1/user-info/$userId');
  }

  /// Fetches contact details (emergency numbers, reps) for a booking.
  Future<Response> getContacts(String userId) async {
    return _dio.get('mobileapp/v1/get-contacts', queryParameters: {
      'user_id': userId,
    });
  }

  /// Fetches the WhatsApp business number for contacting support.
  Future<Response> getWhatsAppBusinessNumber() async {
    return _dio.get('mobileapp/v1/whatsapp-business-number');
  }

  /// Fetches full details for a specific trip (destination, actions, meeting point).
  Future<Response> getTripDetails({
    int? packageId,
    int? bookingId,
    String? orderId,
    required String userId,
  }) async {
    return _dio.get('mobileapp/v1/trip-details', queryParameters: {
      'package_id': ?packageId,
      'booking_id': ?bookingId,
      'order_id': ?orderId,
      'user_id': userId,
    });
  }

  /// Fetches the day-by-day itinerary for a booking on a specific date.
  Future<Response> getItinerary({
    required int bookingId,
    required String eventDate,
    required String userId,
  }) async {
    return _dio.get('mobileapp/v1/get_allocations_itinerary',
        queryParameters: {
          'booking_id': bookingId,
          'event_date': eventDate,
          'user_id': userId,
        });
  }
}
