import '../remote/api_service.dart';
import '../../domain/repository/contact_repository.dart';

class ContactRepositoryImpl implements ContactRepository {
  final ApiService _apiService;

  ContactRepositoryImpl({required ApiService apiService})
      : _apiService = apiService;

  @override
  Future<Map<String, dynamic>> getContacts(String userId) async {
    final response = await _apiService.getContacts(userId);
    return response.data as Map<String, dynamic>;
  }

  @override
  Future<Map<String, dynamic>> getWhatsAppNumber() async {
    final response = await _apiService.getWhatsAppBusinessNumber();
    return response.data as Map<String, dynamic>;
  }
}
