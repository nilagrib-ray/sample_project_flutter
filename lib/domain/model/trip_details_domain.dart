class TripDetailsDomain {
  final int id;
  final int? packageId;
  final int? bookingId;
  final String? orderId;
  final String tripName;
  final String? description;
  final String arrivalDate;
  final String? arrivalTime;
  final String departureDate;
  final String? departureTime;
  final String? hotel;
  final String? featuredImage;
  final String? image;
  final String? squareImage;
  final List<Traveller> travellers;
  final String? bookingTotal;
  final String? bookingBalance;
  final String? currencySymbol;
  final String? destinationName;
  final String? destinationImage;
  final List<ActionRequired> actionsRequired;
  final int daysToGo;
  final double? destinationLatitude;
  final double? destinationLongitude;
  final String? meetingPointDetails;

  const TripDetailsDomain({
    required this.id,
    this.packageId,
    this.bookingId,
    this.orderId,
    required this.tripName,
    this.description,
    required this.arrivalDate,
    this.arrivalTime,
    required this.departureDate,
    this.departureTime,
    this.hotel,
    this.featuredImage,
    this.image,
    this.squareImage,
    required this.travellers,
    this.bookingTotal,
    this.bookingBalance,
    this.currencySymbol,
    this.destinationName,
    this.destinationImage,
    required this.actionsRequired,
    required this.daysToGo,
    this.destinationLatitude,
    this.destinationLongitude,
    this.meetingPointDetails,
  });
}

class Traveller {
  final String id;
  final String firstName;
  final String lastName;
  final String fullName;
  final String? email;
  final bool isLeadBooker;

  const Traveller({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.fullName,
    this.email,
    required this.isLeadBooker,
  });
}

class ActionRequired {
  final String id;
  final String title;
  final String description;
  final String actionType;

  const ActionRequired({
    required this.id,
    required this.title,
    required this.description,
    required this.actionType,
  });
}

class ItineraryDomain {
  final List<Event> events;
  final String eventDate;

  const ItineraryDomain({
    required this.events,
    required this.eventDate,
  });
}

class Event {
  final int id;
  final String title;
  final String? description;
  final String? startTime;
  final String? endTime;
  final String? location;
  final String eventType;
  final String? image;

  const Event({
    required this.id,
    required this.title,
    this.description,
    this.startTime,
    this.endTime,
    this.location,
    required this.eventType,
    this.image,
  });
}
