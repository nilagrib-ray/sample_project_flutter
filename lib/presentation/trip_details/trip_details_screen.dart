import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'components/trip_details_components.dart';
import 'trip_details_view_model.dart';

class TripDetailsScreen extends StatefulWidget {
  final int? packageId;
  final int? bookingId;
  final String? orderId;
  final VoidCallback onNavigateBack;

  const TripDetailsScreen({
    super.key,
    this.packageId,
    this.bookingId,
    this.orderId,
    required this.onNavigateBack,
  });

  @override
  State<TripDetailsScreen> createState() => _TripDetailsScreenState();
}

class _TripDetailsScreenState extends State<TripDetailsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TripDetailsViewModel>().loadTripDetails(
            widget.packageId,
            widget.bookingId,
            widget.orderId,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TripDetailsViewModel>(
      builder: (context, viewModel, _) {
        final uiState = viewModel.uiState;

        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Stack(
              children: [
                if (uiState.isLoading)
                  const Center(
                    child: CircularProgressIndicator(
                        color: Color(0xFFFF6600)),
                  )
                else
                  ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      // Hero image
                      SizedBox(
                        height: 260,
                        child: Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10, bottom: 10),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: CachedNetworkImage(
                                  imageUrl: uiState.destinationImage ??
                                      uiState.featuredImage ??
                                      '',
                                  height: 260,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  placeholder: (_, _) => Container(
                                    color: const Color(0xFFE0E0E0),
                                  ),
                                  errorWidget: (_, _, _) => Container(
                                    color: const Color(0xFFE0E0E0),
                                    child: const Icon(Icons.image, size: 48),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 32,
                              right: 32,
                              child: GestureDetector(
                                onTap: widget.onNavigateBack,
                                child: Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.4),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.close,
                                      color: Colors.white, size: 20),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Title and booking number
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              (uiState.destinationName?.isNotEmpty == true)
                                  ? uiState.destinationName!
                                  : uiState.tripName,
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  uiState.bookingNumber.isNotEmpty
                                      ? 'Booking # ${uiState.bookingNumber}'
                                      : 'Booking information unavailable',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                                if (uiState.bookingNumber.isNotEmpty)
                                  const Icon(Icons.content_copy,
                                      color: Colors.grey, size: 20),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Date range
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  formatDateDayMonth(uiState.arrivalDate),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  formatDateYear(uiState.arrivalDate),
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.grey),
                                ),
                              ],
                            ),
                            const Icon(Icons.arrow_forward,
                                color: Color(0xFFFF6600), size: 24),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  formatDateDayMonth(uiState.departureDate),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  formatDateYear(uiState.departureDate),
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.grey),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Countdown
                      CountdownCard(
                        days: uiState.daysToGo,
                        hours: uiState.hoursToGo,
                        minutes: uiState.minutesToGo,
                      ),
                      const SizedBox(height: 20),

                      // Destination link
                      if (uiState.destinationName?.isNotEmpty == true) ...[
                        DestinationLinkCard(
                            destinationName: uiState.destinationName!),
                        const SizedBox(height: 20),
                      ],

                      // Link friends
                      const LinkFriendsCard(),
                      const SizedBox(height: 24),

                      // Actions required
                      if (uiState.actionsRequired.isNotEmpty) ...[
                        const SectionHeaderRow(
                          icon: Icons.error_outline,
                          title: 'Actions Required',
                          iconTint: Color(0xFFFF6600),
                        ),
                        const SizedBox(height: 12),
                        ...uiState.actionsRequired.map(
                            (a) => Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: ActionRequiredCard(action: a),
                                )),
                        const SizedBox(height: 8),
                      ],

                      // Travellers
                      if (uiState.travellers.isNotEmpty) ...[
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.person,
                                      color: Colors.black, size: 28),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${uiState.travellers.length} Travellers',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              if (uiState.actionsRequired.isNotEmpty)
                                const Icon(Icons.error_outline,
                                    color: Color(0xFFFF6600), size: 24),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...uiState.travellers.asMap().entries.map(
                              (entry) => Column(
                                children: [
                                  TravellerCard(traveller: entry.value),
                                  if (entry.key <
                                      uiState.travellers.length - 1)
                                    const Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Divider(
                                          color: Color(0xFFE0E0E0)),
                                    ),
                                ],
                              ),
                            ),
                        const SizedBox(height: 20),
                      ],

                      // Today's Events
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: const [
                                Icon(Icons.calendar_today,
                                    color: Colors.black, size: 24),
                                SizedBox(width: 8),
                                Text(
                                  "Today's Events",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            const Text(
                              'See all',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFFFF6600),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (uiState.todayEvents.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            'No events found for today',
                            style: TextStyle(
                                fontSize: 16, color: Colors.grey),
                          ),
                        ),
                      const SizedBox(height: 20),

                      // Map section
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: const [
                                Icon(Icons.location_on,
                                    color: Colors.black, size: 24),
                                SizedBox(width: 8),
                                Text(
                                  "Where you're going",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            const Text(
                              'Expand',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFFFF6600),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      _buildMapSection(uiState),
                      const SizedBox(height: 20),

                      // Travel Details
                      _buildTravelDetails(uiState),
                      const SizedBox(height: 20),

                      // Hotel
                      if (uiState.hotel?.isNotEmpty == true)
                        _buildHotelSection(uiState),

                      // Payments
                      if (uiState.bookingTotal != null)
                        _buildPaymentsSection(uiState),
                    ],
                  ),

                if (uiState.errorMessage != null)
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: Card(
                      color: const Color(0xFFF5F5F5),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          uiState.errorMessage!,
                          style: const TextStyle(
                            color: Color(0xFFD32F2F),
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMapSection(TripDetailsUiState uiState) {
    final hasCoords = uiState.destinationLatitude != null &&
        uiState.destinationLongitude != null &&
        uiState.destinationLatitude != 0.0 &&
        uiState.destinationLongitude != 0.0;

    if (hasCoords) {
      return DestinationMap(
        latitude: uiState.destinationLatitude!,
        longitude: uiState.destinationLongitude!,
        destinationName: uiState.destinationName ?? uiState.tripName,
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 250,
          color: const Color(0xFFE0E0E0),
          alignment: Alignment.center,
          child: const Text(
            'Location not available',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      ),
    );
  }

  Widget _buildTravelDetails(TripDetailsUiState uiState) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Travel Details',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.black, size: 28),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Divider(color: Color(0xFFE0E0E0)),
              const SizedBox(height: 16),
              const Text('Scheduled Flight Arrival',
                  style: TextStyle(fontSize: 14, color: Colors.black)),
              const SizedBox(height: 4),
              Text(
                '${formatDateNumeric(uiState.arrivalDate)} at ${(uiState.arrivalTime ?? "00:00").substring(0, 5.clamp(0, (uiState.arrivalTime ?? "00:00").length))}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              const Divider(color: Color(0xFFE0E0E0)),
              const SizedBox(height: 16),
              const Text('Scheduled Flight Departure',
                  style: TextStyle(fontSize: 14, color: Colors.black)),
              const SizedBox(height: 4),
              Text(
                '${formatDateNumeric(uiState.departureDate)} at ${(uiState.departureTime ?? "20:00").substring(0, 5.clamp(0, (uiState.departureTime ?? "20:00").length))}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              const Divider(color: Color(0xFFE0E0E0)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHotelSection(TripDetailsUiState uiState) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(Icons.hotel_outlined, color: Colors.black, size: 28),
                  SizedBox(width: 8),
                  Text(
                    'Hotel',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const Icon(Icons.error_outline,
                  color: Color(0xFFFF6600), size: 24),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Staying at',
                  style: TextStyle(fontSize: 14, color: Colors.grey)),
              Text(
                uiState.hotel!,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildPaymentsSection(TripDetailsUiState uiState) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Payments',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.black, size: 28),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Card(
            color: Colors.white,
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${uiState.currencySymbol} Per Person',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFFFF6600),
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.person,
                              color: Colors.black, size: 18),
                          const SizedBox(width: 4),
                          Text(
                            'X ${uiState.travellers.length}',
                            style: const TextStyle(
                                fontSize: 14, color: Colors.black),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: Color(0xFFE0E0E0)),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Booking Total:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        '${uiState.currencySymbol}${formatAmount(uiState.bookingTotal)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Outstanding:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        '${uiState.currencySymbol}${formatAmount(uiState.bookingBalance ?? "0.00")}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}
