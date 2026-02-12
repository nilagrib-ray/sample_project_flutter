// DTOs for contacts API. RepsData uses _parseStringMap to handle JSON maps
// whose keys may be numbers or strings.

/// Contact info for a booking: emergency numbers, meeting point, reps.
class ContactsResponse {
  final int? id;
  final int? bookingId;
  final String? name;
  final String? slug;
  final String? featuredImage;
  final ContactMeetingPoint? meetingPoint;
  final String? emergencyNumber;
  final String? phtContactPhone;
  final String? globalEmergencyContact;
  final String? phtContactEmail;
  final String? meetingPointDetails;
  final String? faq;
  final RepsData? reps;

  const ContactsResponse({
    this.id,
    this.bookingId,
    this.name,
    this.slug,
    this.featuredImage,
    this.meetingPoint,
    this.emergencyNumber,
    this.phtContactPhone,
    this.globalEmergencyContact,
    this.phtContactEmail,
    this.meetingPointDetails,
    this.faq,
    this.reps,
  });

  factory ContactsResponse.fromJson(Map<String, dynamic> json) {
    return ContactsResponse(
      id: json['id'] as int?,
      bookingId: json['booking_id'] as int?,
      name: json['name'] as String?,
      slug: json['slug'] as String?,
      featuredImage: json['featured_image'] as String?,
      meetingPoint: json['meeting_point'] != null
          ? ContactMeetingPoint.fromJson(
              json['meeting_point'] as Map<String, dynamic>)
          : null,
      emergencyNumber:
          json['contact_details_emergency_number'] as String?,
      phtContactPhone:
          json['contact_details_pht_contact_phone'] as String?,
      globalEmergencyContact:
          json['global_emergency_contact'] as String?,
      phtContactEmail:
          json['contact_details_pht_contact_email'] as String?,
      meetingPointDetails: json['meeting_point_details'] as String?,
      faq: json['faq'] as String?,
      reps: json['reps'] != null
          ? RepsData.fromJson(json['reps'] as Map<String, dynamic>)
          : null,
    );
  }
}

/// Meeting point location with address and coordinates.
class ContactMeetingPoint {
  final String? address;
  final double? lat;
  final double? lng;
  final int? zoom;
  final String? placeId;
  final String? name;
  final String? streetNumber;
  final String? streetName;
  final String? city;
  final String? state;
  final String? postCode;
  final String? country;
  final String? countryShort;

  const ContactMeetingPoint({
    this.address,
    this.lat,
    this.lng,
    this.zoom,
    this.placeId,
    this.name,
    this.streetNumber,
    this.streetName,
    this.city,
    this.state,
    this.postCode,
    this.country,
    this.countryShort,
  });

  factory ContactMeetingPoint.fromJson(Map<String, dynamic> json) {
    return ContactMeetingPoint(
      address: json['address'] as String?,
      lat: (json['lat'] as num?)?.toDouble(),
      lng: (json['lng'] as num?)?.toDouble(),
      zoom: json['zoom'] as int?,
      placeId: json['place_id'] as String?,
      name: json['name'] as String?,
      streetNumber: json['street_number'] as String?,
      streetName: json['street_name'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      postCode: json['post_code'] as String?,
      country: json['country'] as String?,
      countryShort: json['country_short'] as String?,
    );
  }
}

/// Rep (representative) data: maps of rep ID -> first name, last name, phone, etc.
class RepsData {
  final Map<String, String>? repsFirstName;
  final Map<String, String>? repsLastName;
  final Map<String, String>? repsPhone;
  final Map<String, String>? repsPronouns;
  final Map<String, String>? repsImage;

  const RepsData({
    this.repsFirstName,
    this.repsLastName,
    this.repsPhone,
    this.repsPronouns,
    this.repsImage,
  });

  factory RepsData.fromJson(Map<String, dynamic> json) {
    return RepsData(
      repsFirstName: _parseStringMap(json['reps_first_name']),
      repsLastName: _parseStringMap(json['reps_last_name']),
      repsPhone: _parseStringMap(json['reps_phone']),
      repsPronouns: _parseStringMap(json['reps_pronouns']),
      repsImage: _parseStringMap(json['reps_image']),
    );
  }

  /// Converts a JSON map to `Map<String, String>`. JSON keys can be numbers
  /// (e.g. rep ID 1, 2) but we need String keys. Converts both keys and values.
  static Map<String, String>? _parseStringMap(dynamic value) {
    if (value == null) return null;
    if (value is Map) {
      return value.map((k, v) => MapEntry(k.toString(), v.toString()));
    }
    return null;
  }
}

/// WhatsApp business number for the trip/booking.
class WhatsAppNumberResponse {
  final String? whatsappNumber;
  final String? countryCode;
  final String? displayNumber;

  const WhatsAppNumberResponse({
    this.whatsappNumber,
    this.countryCode,
    this.displayNumber,
  });

  factory WhatsAppNumberResponse.fromJson(Map<String, dynamic> json) {
    return WhatsAppNumberResponse(
      whatsappNumber: json['whatsapp_number'] as String?,
      countryCode: json['country_code'] as String?,
      displayNumber: json['display_number'] as String?,
    );
  }
}
