/// App-wide constants: values that never change and are used in many places.
/// Keeping them here avoids magic strings/numbers scattered in the code.
class AppConstants {
  /// Private constructor (_) means this class can never be instantiated with
  /// "new AppConstants()". You only use it as a container for static values.
  AppConstants._();

  /// The base URL for all API requests. All endpoints are appended to this.
  static const String baseUrl =
      'https://partyharddev.wpenginepowered.com/wp-json/';

  /// Token used to authenticate API requests. The server checks this to know
  /// the request is from our app.
  static const String appToken =
      '1KPGaQRWygFCc47zUlxRyQrjTC9UMAy6PoL6JgyCwyPpY9qUErkidTuMzhaazSIHf3Vu1shS3aMP4EI7';

  /// API key for Google Maps. Required to show maps, directions, or location
  /// features in the app.
  static const String googleMapsApiKey = 'AIzaSyDw2hnbsiGVlMuky7-vmqI-BJ4kbL7nGf8';
}
