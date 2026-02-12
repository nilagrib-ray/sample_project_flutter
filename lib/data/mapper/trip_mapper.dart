import '../remote/dto/trip_dto.dart';
import '../../domain/model/trip_domain.dart';

extension TripDtoMapper on TripDto {
  TripDomain toDomain() {
    final locationName = destination?.isNotEmpty == true
        ? destination!.first.name ?? ''
        : '';
    final destinationImageUrl = destination?.isNotEmpty == true
        ? destination!.first.descriptionFeaturedImageUrl
        : null;

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

extension TripDtoListMapper on List<TripDto> {
  List<TripDomain> toDomain() {
    return map((dto) => dto.toDomain()).toList();
  }
}

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

extension CategoryDtoListMapper on List<CategoryDto> {
  List<DestinationCategory> toDestinationCategories() {
    return map((dto) => dto.toDomain()).toList();
  }
}
