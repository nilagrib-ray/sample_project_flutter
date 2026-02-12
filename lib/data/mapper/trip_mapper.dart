import '../remote/dto/trip_dto.dart';
import '../../domain/model/trip_domain.dart';

/// Converts TripDto (API format) to TripDomain (app format).
extension TripDtoMapper on TripDto {
  TripDomain toDomain() {
    // destination? = safe access: if destination is null, skip; otherwise use it
    // destination! = we've checked it's not empty, so ! tells Dart it's safe
    final locationName = destination?.isNotEmpty == true
        ? destination!.first.name ?? ''
        : '';
    final destinationImageUrl = destination?.isNotEmpty == true
        ? destination!.first.descriptionFeaturedImageUrl
        : null;

    // ?? = null-coalescing: use left side if not null, otherwise use right side
    // Example: packageId ?? 0 means "use packageId, or 0 if packageId is null"
    return TripDomain(
      tripId: (packageId ?? bookingId ?? 0).toString(),
      packageId: packageId,
      bookingId: bookingId,
      orderId: orderId,
      tripName: packageTitle ?? bookingTitle ?? 'Unnamed Trip',
      featuredImage: featuredImage,
      image: image,
      squareImage: squareImage,
      destinationImage: destinationImageUrl,
      startDate: arrivalDate ?? '',
      endDate: departureDate ?? '',
      location: locationName,
      status: null,
      bookingTotal: bookingTotal,
      bookingBalance: bookingBalance,
      currencySymbol: currencySymbol,
      hotel: hotel,
      type: type,
    );
  }
}

/// Converts a list of TripDto to a list of TripDomain.
extension TripDtoListMapper on List<TripDto> {
  List<TripDomain> toDomain() {
    return map((dto) => dto.toDomain()).toList();
  }
}

/// Converts CategoryDto (API format) to DestinationCategory (app format).
extension CategoryDtoMapper on CategoryDto {
  DestinationCategory toDomain() {
    return DestinationCategory(
      categoryId: categoryId ?? 0,
      categoryName: categoryName ?? '',
      destUrl: destUrl ?? '',
      imageUrl: descriptionFeaturedImageUrl ??
          (posts?.isNotEmpty == true ? posts!.first.image ?? '' : ''),
      squareImageUrl:
          posts?.isNotEmpty == true ? posts!.first.squareImage ?? '' : '',
    );
  }
}

/// Converts a list of CategoryDto to a list of DestinationCategory.
extension CategoryDtoListMapper on List<CategoryDto> {
  List<DestinationCategory> toDestinationCategories() {
    return map((dto) => dto.toDomain()).toList();
  }
}
