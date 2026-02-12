class ContactDomain {
  final String id;
  final String firstName;
  final String lastName;
  final String fullName;
  final String phone;
  final String pronouns;
  final String? imageUrl;

  const ContactDomain({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.fullName,
    required this.phone,
    required this.pronouns,
    this.imageUrl,
  });
}

class ContactsDomain {
  final String destinationName;
  final String? destinationImage;
  final List<ContactDomain> reps;
  final String? emergencyNumber;
  final String? globalEmergencyNumber;
  final String? phtContactPhone;
  final String? phtContactEmail;
  final String? meetingPointDetails;

  const ContactsDomain({
    required this.destinationName,
    this.destinationImage,
    required this.reps,
    this.emergencyNumber,
    this.globalEmergencyNumber,
    this.phtContactPhone,
    this.phtContactEmail,
    this.meetingPointDetails,
  });
}

class KeyContact {
  final String name;
  final String subtitle;
  final String? contactInfo;
  final bool isWhatsApp;

  const KeyContact({
    required this.name,
    required this.subtitle,
    this.contactInfo,
    this.isWhatsApp = false,
  });
}
