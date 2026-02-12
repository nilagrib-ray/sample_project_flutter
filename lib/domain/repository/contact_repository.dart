/// Abstract contract for contact-related data. Implementations fetch from API
/// or local storage. The domain layer only defines what operations are needed.
abstract class ContactRepository {
  /// Fetches contacts for a user (e.g. reps, emergency numbers for their trips).
  /// Returns raw map to be parsed by the caller.
  Future<Map<String, dynamic>> getContacts(String userId);

  /// Gets the WhatsApp support number. Used when the user wants to contact
  /// support via WhatsApp.
  Future<Map<String, dynamic>> getWhatsAppNumber();
}
