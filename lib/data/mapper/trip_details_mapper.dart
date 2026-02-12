import 'dart:developer' as developer;
import '../remote/dto/trip_details_dto.dart';
import '../../domain/model/trip_details_domain.dart';

/// Converts TripDetailsResponse (API format) to TripDetailsDomain (app format).
/// This is a complex mapper because the API returns travellers in different formats
/// and may not always include coordinates.
extension TripDetailsResponseMapper on TripDetailsResponse {
  TripDetailsDomain toDomain() {
    // Get destination name and image from the first destination in the list
    final destinationName = destination?.isNotEmpty == true
        ? destination!.first.name ?? ''
        : '';
    final destinationImageUrl = destination?.isNotEmpty == true
        ? destination!.first.descriptionFeaturedImageUrl
        : null;

    // Calculate how many days until the trip starts
    final daysToGo = _calculateDaysToGo(arrivalDate ?? '');

    // Use API coordinates if available, otherwise fall back to known coordinates by destination name
    final latitude =
        meetingPoint?.lat ?? _getDefaultLatitude(destinationName);
    final longitude =
        meetingPoint?.lng ?? _getDefaultLongitude(destinationName);

    developer.log(
        'Coordinates: lat=$latitude, lng=$longitude for $destinationName',
        name: 'TripDetailsMapper');

    // Travellers can come as a list of objects, a string like "3", or a number like 3
    final travellersList = _parseTravellers(travellers);

    return TripDetailsDomain(
      id: id ?? 0,
      packageId: packageId,
      bookingId: bookingId,
      orderId: orderId,
      tripName: 'Ayia Napa', // packageTitle ?? bookingTitle ??
      description: description,
      arrivalDate: arrivalDate ?? '',
      arrivalTime: arrivalTime,
      departureDate: departureDate ?? '',
      departureTime: departureTime,
      hotel: hotel,
      featuredImage: featuredImage,
      image: image,
      squareImage: squareImage,
      travellers: travellersList,
      bookingTotal: bookingTotal,
      bookingBalance: bookingBalance,
      currencySymbol: currencySymbol,
      destinationName: destinationName,
      destinationImage: destinationImageUrl,
      actionsRequired:
          actionsRequired?.map((a) => a.toDomain()).toList() ?? [],
      daysToGo: daysToGo,
      destinationLatitude: latitude,
      destinationLongitude: longitude,
      meetingPointDetails: meetingPointDetails,
    );
  }

  /// Handles travellers whether API sends: list of objects, string count, or number count.
  List<Traveller> _parseTravellers(dynamic travellersData) {
    try {
      if (travellersData == null) {
        return [];
      }

      // Case 1: API sends a list of traveller objects
      if (travellersData is List) {
        return travellersData.map((e) {
          final dto = TravellerDto.fromJson(e as Map<String, dynamic>);
          return dto.toDomain();
        }).toList();
      }

      // Case 2: API sends a string like "3" - create placeholder travellers
      if (travellersData is String) {
        final count = int.tryParse(travellersData) ?? 0;
        return List.generate(count, (index) {
          return Traveller(
            id: '$index',
            firstName: 'Traveller',
            lastName: '${index + 1}',
            fullName: 'Traveller ${index + 1}',
            email: null,
            isLeadBooker: index == 0,
          );
        });
      }

      // Case 3: API sends a number like 3 - same as string case
      if (travellersData is num) {
        final count = travellersData.toInt();
        return List.generate(count, (index) {
          return Traveller(
            id: '$index',
            firstName: 'Traveller',
            lastName: '${index + 1}',
            fullName: 'Traveller ${index + 1}',
            email: null,
            isLeadBooker: index == 0,
          );
        });
      }

      return [];
    } catch (e) {
      developer.log('Error parsing travellers: $e',
          name: 'TripDetailsMapper');
      return [];
    }
  }
}

/// Converts TravellerDto to Traveller domain model.
extension TravellerDtoMapper on TravellerDto {
  Traveller toDomain() {
    final first = firstName ?? '';
    final last = lastName ?? '';
    return Traveller(
      id: id ?? '',
      firstName: first,
      lastName: last,
      fullName: (first.isNotEmpty || last.isNotEmpty)
          ? '$first $last'.trim()
          : 'Unnamed Traveller',
      email: email,
      isLeadBooker: isLeadBooker ?? false,
    );
  }
}

/// Converts ActionRequiredDto to ActionRequired domain model.
extension ActionRequiredDtoMapper on ActionRequiredDto {
  ActionRequired toDomain() {
    return ActionRequired(
      id: id ?? '',
      title: title ?? '',
      description: description ?? '',
      actionType: actionType ?? '',
    );
  }
}

/// Converts ItineraryResponse (API) to ItineraryDomain (app).
extension ItineraryResponseMapper on ItineraryResponse {
  ItineraryDomain toDomain() {
    return ItineraryDomain(
      events: events?.map((e) => e.toDomain()).toList() ?? [],
      eventDate: eventDate ?? '',
    );
  }
}

/// Converts EventDto to Event domain model.
extension EventDtoMapper on EventDto {
  Event toDomain() {
    return Event(
      id: id ?? 0,
      title: title ?? '',
      description: description,
      startTime: startTime,
      endTime: endTime,
      location: location,
      eventType: eventType ?? '',
      image: image,
    );
  }
}

/// Returns hardcoded latitude for popular destinations when API doesn't provide coordinates.
double _getDefaultLatitude(String destinationName) {
  final name = destinationName.toLowerCase();
  if (name.contains('ayia napa')) return 34.9823;
  if (name.contains('ibiza')) return 38.9067;
  if (name.contains('magaluf')) return 39.5107;
  if (name.contains('zante') || name.contains('zakynthos')) return 37.7870;
  if (name.contains('malia')) return 35.2886;
  if (name.contains('kavos')) return 39.4147;
  if (name.contains('albufeira')) return 37.0893;
  if (name.contains('marbella')) return 36.5100;
  if (name.contains('benidorm')) return 38.5382;
  return 35.0;
}

/// Returns hardcoded longitude for popular destinations when API doesn't provide coordinates.
double _getDefaultLongitude(String destinationName) {
  final name = destinationName.toLowerCase();
  if (name.contains('ayia napa')) return 34.0053;
  if (name.contains('ibiza')) return 1.4206;
  if (name.contains('magaluf')) return 2.5347;
  if (name.contains('zante') || name.contains('zakynthos')) return 20.8984;
  if (name.contains('malia')) return 25.4748;
  if (name.contains('kavos')) return 20.0761;
  if (name.contains('albufeira')) return -8.2458;
  if (name.contains('marbella')) return -4.8824;
  if (name.contains('benidorm')) return -0.1312;
  return 25.0;
}

/// Calculates days until trip: parses date string, compares to today, returns difference in days.
int _calculateDaysToGo(String dateString) {
  try {
    if (dateString.isEmpty) return 0;
    final tripDate = DateTime.parse(dateString);
    final now = DateTime.now();
    if (tripDate.isAfter(now)) {
      return tripDate.difference(now).inDays;
    }
    return 0;
  } catch (_) {
    return 0;
  }
}
