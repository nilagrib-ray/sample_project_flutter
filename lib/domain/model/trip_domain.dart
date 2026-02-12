/// Represents a trip in the app. Used when listing trips (e.g. on the home
/// screen). Fields like images and location are optional (?) because the API
/// may not always return them.
class TripDomain {
  final String tripId;
  final int? packageId;
  final int? bookingId;
  final String? orderId;
  final String tripName;
  final String? featuredImage;
  final String? image;
  final String? squareImage;
  final String? destinationImage;
  final String startDate;
  final String endDate;
  final String? location;
  final String? status;
  final String? bookingTotal;
  final String? bookingBalance;
  final String? currencySymbol;
  final String? hotel;
  final String? type;

  const TripDomain({
    required this.tripId,
    this.packageId,
    this.bookingId,
    this.orderId,
    required this.tripName,
    this.featuredImage,
    this.image,
    this.squareImage,
    this.destinationImage,
    required this.startDate,
    required this.endDate,
    this.location,
    this.status,
    this.bookingTotal,
    this.bookingBalance,
    this.currencySymbol,
    this.hotel,
    this.type,
  });
}

/// Represents a category of destinations (e.g. "Beach", "Adventure"). Used to
/// group or filter destinations in the app. All fields are required since a
/// category isn't useful without this info.
class DestinationCategory {
  final int categoryId;
  final String categoryName;
  final String destUrl;
  final String imageUrl;
  final String squareImageUrl;

  const DestinationCategory({
    required this.categoryId,
    required this.categoryName,
    required this.destUrl,
    required this.imageUrl,
    required this.squareImageUrl,
  });
}
