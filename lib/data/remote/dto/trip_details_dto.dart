class TripDetailsResponse {
  final int? id;
  final int? packageId;
  final int? bookingId;
  final String? orderId;
  final String? packageTitle;
  final String? bookingTitle;
  final String? description;
  final String? arrivalDate;
  final String? arrivalTime;
  final String? departureDate;
  final String? departureTime;
  final String? hotel;
  final String? featuredImage;
  final String? image;
  final String? squareImage;
  final dynamic travellers; // Can be list, string, or number
  final String? bookingTotal;
  final String? bookingBalance;
  final String? currencySymbol;
  final List<DestinationDetailDto>? destination;
  final List<ActionRequiredDto>? actionsRequired;
  final MeetingPointDto? meetingPoint;
  final String? meetingPointDetails;

  const TripDetailsResponse({
    this.id,
    this.packageId,
    this.bookingId,
    this.orderId,
    this.packageTitle,
    this.bookingTitle,
    this.description,
    this.arrivalDate,
    this.arrivalTime,
    this.departureDate,
    this.departureTime,
    this.hotel,
    this.featuredImage,
    this.image,
    this.squareImage,
    this.travellers,
    this.bookingTotal,
    this.bookingBalance,
    this.currencySymbol,
    this.destination,
    this.actionsRequired,
    this.meetingPoint,
    this.meetingPointDetails,
  });

  factory TripDetailsResponse.fromJson(Map<String, dynamic> json) {
    return TripDetailsResponse(
      id: json['id'] as int?,
      packageId: json['package_id'] as int?,
      bookingId: json['booking_id'] as int?,
      orderId: json['order_id']?.toString(),
      packageTitle: json['package_title'] as String?,
      bookingTitle: json['booking_title'] as String?,
      description: json['description'] as String?,
      arrivalDate: json['arrival_date'] as String?,
      arrivalTime: json['arrival_time'] as String?,
      departureDate: json['departure_date'] as String?,
      departureTime: json['departure_time'] as String?,
      hotel: json['hotel'] as String?,
      featuredImage: json['featured_image'] as String?,
      image: json['image'] as String?,
      squareImage: json['square_image'] as String?,
      travellers: json['travellers'],
      bookingTotal: json['booking_total'] as String?,
      bookingBalance: json['booking_balance'] as String?,
      currencySymbol: json['currency_symbol'] as String?,
      destination: (json['destination'] as List<dynamic>?)
          ?.map((e) => DestinationDetailDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      actionsRequired: (json['actions_required'] as List<dynamic>?)
          ?.map((e) => ActionRequiredDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      meetingPoint: json['meeting_point'] != null
          ? MeetingPointDto.fromJson(json['meeting_point'] as Map<String, dynamic>)
          : null,
      meetingPointDetails: json['meeting_point_details'] as String?,
    );
  }
}

class DestinationDetailDto {
  final int? id;
  final String? name;
  final String? slug;
  final String? descriptionFeaturedImageUrl;

  const DestinationDetailDto({
    this.id,
    this.name,
    this.slug,
    this.descriptionFeaturedImageUrl,
  });

  factory DestinationDetailDto.fromJson(Map<String, dynamic> json) {
    return DestinationDetailDto(
      id: json['id'] as int?,
      name: json['name'] as String?,
      slug: json['slug'] as String?,
      descriptionFeaturedImageUrl:
          json['description_featured_image_url'] as String?,
    );
  }
}

class TravellerDto {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final bool? isLeadBooker;

  const TravellerDto({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.isLeadBooker,
  });

  factory TravellerDto.fromJson(Map<String, dynamic> json) {
    return TravellerDto(
      id: json['id']?.toString(),
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      email: json['email'] as String?,
      isLeadBooker: json['is_lead_booker'] as bool?,
    );
  }
}

class ActionRequiredDto {
  final String? id;
  final String? title;
  final String? description;
  final String? actionType;

  const ActionRequiredDto({
    this.id,
    this.title,
    this.description,
    this.actionType,
  });

  factory ActionRequiredDto.fromJson(Map<String, dynamic> json) {
    return ActionRequiredDto(
      id: json['id']?.toString(),
      title: json['title'] as String?,
      description: json['description'] as String?,
      actionType: json['action_type'] as String?,
    );
  }
}

class ItineraryResponse {
  final List<EventDto>? events;
  final String? eventDate;

  const ItineraryResponse({this.events, this.eventDate});

  factory ItineraryResponse.fromJson(Map<String, dynamic> json) {
    return ItineraryResponse(
      events: (json['events'] as List<dynamic>?)
          ?.map((e) => EventDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      eventDate: json['event_date'] as String?,
    );
  }
}

class EventDto {
  final int? id;
  final String? title;
  final String? description;
  final String? startTime;
  final String? endTime;
  final String? location;
  final String? eventType;
  final String? image;

  const EventDto({
    this.id,
    this.title,
    this.description,
    this.startTime,
    this.endTime,
    this.location,
    this.eventType,
    this.image,
  });

  factory EventDto.fromJson(Map<String, dynamic> json) {
    return EventDto(
      id: json['id'] as int?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      startTime: json['start_time'] as String?,
      endTime: json['end_time'] as String?,
      location: json['location'] as String?,
      eventType: json['event_type'] as String?,
      image: json['image'] as String?,
    );
  }
}

class MeetingPointDto {
  final double? lat;
  final double? lng;
  final String? address;
  final String? name;
  final String? city;
  final String? country;

  const MeetingPointDto({
    this.lat,
    this.lng,
    this.address,
    this.name,
    this.city,
    this.country,
  });

  factory MeetingPointDto.fromJson(Map<String, dynamic> json) {
    return MeetingPointDto(
      lat: (json['lat'] as num?)?.toDouble(),
      lng: (json['lng'] as num?)?.toDouble(),
      address: json['address'] as String?,
      name: json['name'] as String?,
      city: json['city'] as String?,
      country: json['country'] as String?,
    );
  }
}
