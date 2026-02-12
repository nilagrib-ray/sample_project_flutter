import 'dart:developer' as developer;
import '../../core/utils/resource.dart';
import '../../data/remote/dto/contact_dto.dart';
import '../../data/mapper/contact_mapper.dart';
import '../model/contact_domain.dart';
import '../repository/auth_repository.dart';
import '../repository/contact_repository.dart';

class GetContactsUseCase {
  final ContactRepository _contactRepository;
  final AuthRepository _authRepository;

  GetContactsUseCase({
    required ContactRepository contactRepository,
    required AuthRepository authRepository,
  })  : _contactRepository = contactRepository,
        _authRepository = authRepository;

  Stream<Resource<ContactsDomain>> call() async* {
    try {
      yield const ResourceLoading();

      final userData = await _authRepository.getUserData();
      if (userData == null) {
        developer.log('User not logged in', name: 'GetContactsUseCase');
        yield const ResourceError(
            'User not logged in. Please login again.');
        return;
      }

      developer.log(
          'Fetching contacts for userId: ${userData.userId}',
          name: 'GetContactsUseCase');

      final responseData =
          await _contactRepository.getContacts(userData.userId);
      final contactsResponse = ContactsResponse.fromJson(responseData);
      final contactsDomain = contactsResponse.toDomain();

      developer.log(
          'Contacts loaded: ${contactsDomain.reps.length} reps',
          name: 'GetContactsUseCase');
      yield ResourceSuccess(contactsDomain);
    } on Exception catch (e) {
      developer.log('Exception in getContacts: $e',
          name: 'GetContactsUseCase');
      yield ResourceError(e.toString());
    }
  }
}
