import 'dart:developer' as developer;
import '../../core/utils/resource.dart';
import '../../data/remote/dto/contact_dto.dart';
import '../../data/mapper/contact_mapper.dart';
import '../model/contact_domain.dart';
import '../repository/auth_repository.dart';
import '../repository/contact_repository.dart';

/// A use case is a single piece of business logic.
/// This one fetches contact reps (support contacts) for the logged-in user.
class GetContactsUseCase {
  final ContactRepository _contactRepository;
  final AuthRepository _authRepository;

  GetContactsUseCase({
    required ContactRepository contactRepository,
    required AuthRepository authRepository,
  })  : _contactRepository = contactRepository,
        _authRepository = authRepository;

  /// Returns a stream of loading/success/error states (`Resource` of `ContactsDomain`).
  /// `async*` creates a stream; `yield` sends each value through the stream to the UI.
  Stream<Resource<ContactsDomain>> call() async* {
    try {
      // Step 1: Tell the UI we're loading (shows a spinner)
      yield const ResourceLoading();

      // Step 2: Check if user is logged in - we need their userId for the API
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

      // Step 3: Call the API to get contacts
      final responseData =
          await _contactRepository.getContacts(userData.userId);
      // Step 4: Convert API response to domain model
      final contactsResponse = ContactsResponse.fromJson(responseData);
      final contactsDomain = contactsResponse.toDomain();

      developer.log(
          'Contacts loaded: ${contactsDomain.reps.length} reps',
          name: 'GetContactsUseCase');
      // Step 5: Tell the UI we have the data
      yield ResourceSuccess(contactsDomain);
    } on Exception catch (e) {
      developer.log('Exception in getContacts: $e',
          name: 'GetContactsUseCase');
      yield ResourceError(e.toString());
    }
  }
}
