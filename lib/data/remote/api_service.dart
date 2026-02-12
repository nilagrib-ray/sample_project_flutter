import 'package:dio/dio.dart';
import '../../core/utils/constants.dart';

/// Equivalent of the Retrofit ApiService interface.
/// Uses Dio for HTTP networking with interceptors for auth headers.
class ApiService {
  final Dio _dio;

  ApiService({Dio? dio}) : _dio = dio ?? _createDio();

  static Dio _createDio() {
    final dio = Dio(
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

    dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (obj) => print('[API] $obj'),
      ),
    );

    return dio;
  }

  /// POST mobileapp/v1/login
  Future<Response> login(Map<String, dynamic> body) async {
    return _dio.post('mobileapp/v1/login', data: body);
  }

  /// GET mobileapp/v1/trips
  Future<Response> getTrips(String userId) async {
    return _dio.get('mobileapp/v1/trips', queryParameters: {
      'user_id': userId,
    });
  }

  /// GET mobileapp/v1/upcoming-trips
  Future<Response> getUpcomingTrips() async {
    return _dio.get('mobileapp/v1/upcoming-trips');
  }

  /// GET mobileapp/v1/user-info/{id}
  Future<Response> getUserInfo(String userId) async {
    return _dio.get('mobileapp/v1/user-info/$userId');
  }

  /// GET mobileapp/v1/get-contacts
  Future<Response> getContacts(String userId) async {
    return _dio.get('mobileapp/v1/get-contacts', queryParameters: {
      'user_id': userId,
    });
  }

  /// GET mobileapp/v1/whatsapp-business-number
  Future<Response> getWhatsAppBusinessNumber() async {
    return _dio.get('mobileapp/v1/whatsapp-business-number');
  }

  /// GET mobileapp/v1/trip-details
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

  /// GET mobileapp/v1/get_allocations_itinerary
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
