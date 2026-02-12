abstract class ContactRepository {
  Future<Map<String, dynamic>> getContacts(String userId);
  Future<Map<String, dynamic>> getWhatsAppNumber();
}
