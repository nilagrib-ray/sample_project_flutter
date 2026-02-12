import '../remote/dto/contact_dto.dart';
import '../../domain/model/contact_domain.dart';

extension ContactsResponseMapper on ContactsResponse {
  ContactsDomain toDomain() {
    final repsList = <ContactDomain>[];

    if (reps != null) {
      final repsData = reps!;
      final firstNames = repsData.repsFirstName ?? {};
      final lastNames = repsData.repsLastName ?? {};
      final phones = repsData.repsPhone ?? {};
      final pronouns = repsData.repsPronouns ?? {};
      final images = repsData.repsImage ?? {};

      // Extract unique rep indices from first name keys
      final repKeys = firstNames.keys.map((key) {
        final parts = key
            .replaceFirst('contact_details_reps_', '')
            .split('_');
        return int.tryParse(parts.first) ?? -1;
      }).where((i) => i >= 0).toSet().toList()
        ..sort();

      for (final index in repKeys) {
        final firstNameKey = 'contact_details_reps_${index}_first_name';
        final lastNameKey = 'contact_details_reps_${index}_last_name';
        final phoneKey = 'contact_details_reps_${index}_phone';
        final pronounKey = 'contact_details_reps_${index}_pronouns';
        final imageKey = 'contact_details_reps_${index}_image';

        final firstName = firstNames[firstNameKey] ?? '';
        final lastName = lastNames[lastNameKey] ?? '';
        final phone = phones[phoneKey] ?? '';
        final pronoun = pronouns[pronounKey] ?? '';
        final image = images[imageKey];

        if (firstName.trim().isNotEmpty && lastName.trim().isNotEmpty) {
          repsList.add(
            ContactDomain(
              id: index.toString(),
              firstName: firstName.trim(),
              lastName: lastName.trim(),
              fullName: '${firstName.trim()} ${lastName.trim()}',
              phone: phone.trim(),
              pronouns: pronoun.trim(),
              imageUrl: image,
            ),
          );
        }
      }
    }

    return ContactsDomain(
      destinationName: name ?? 'Destination',
      destinationImage: featuredImage,
      reps: repsList,
      emergencyNumber: emergencyNumber,
      globalEmergencyNumber: globalEmergencyContact,
      phtContactPhone: phtContactPhone,
      phtContactEmail: phtContactEmail,
      meetingPointDetails: meetingPointDetails,
    );
  }
}
