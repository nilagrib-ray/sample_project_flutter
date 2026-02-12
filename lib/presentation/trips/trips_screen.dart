import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'components/trip_components.dart';
import 'trips_view_model.dart';

// StatelessWidget: Trips data comes from TripsViewModel, no local state.
class TripsScreen extends StatelessWidget {
  final VoidCallback onLogout;
  final void Function(int?, int?, String?) onTripClick;

  const TripsScreen({
    super.key,
    required this.onLogout,
    required this.onTripClick,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<TripsViewModel>(
      builder: (context, viewModel, _) {
        final uiState = viewModel.uiState;

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: const Text(
              'Trips',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 28,
                color: Colors.black,
              ),
            ),
          ),
          body: Stack(
            children: [
              if (uiState.isLoading)
                const Center(
                  child: CircularProgressIndicator(
                      color: Color(0xFFFF6600)),
                )
              else
                // ListView: Scrollable list - sections are Upcoming, Book next,
                // destinations (horizontal), Previous Trips.
                ListView(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  children: [
                    const SectionHeader('Upcoming'),
                    const SizedBox(height: 12),

                    if (uiState.upcomingTrips.isEmpty) ...[
                      const EmptyStateCard('No upcoming trips found'),
                      const SizedBox(height: 24),
                    ] else
                      ...uiState.upcomingTrips.map((trip) => Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: UpcomingTripCard(
                              trip: trip,
                              onTap: () => onTripClick(
                                  trip.packageId, trip.bookingId, trip.orderId),
                            ),
                          )),
                    if (uiState.upcomingTrips.isNotEmpty)
                      const SizedBox(height: 8),

                    // Row: Arranges children horizontally (icon + text).
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: const [
                          Icon(Icons.flight_takeoff_outlined,
                              color: Color(0xFFFF6600), size: 28),
                          SizedBox(width: 8),
                          Text(
                            'Book your next trip',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // ListView.separated with horizontal scroll: Destination
                    // cards scroll left/right. scrollDirection: Axis.horizontal.
                    if (uiState.destinations.isEmpty)
                      const EmptyStateCard('No trips available')
                    else
                      SizedBox(
                        height: 260,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding:
                              const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: uiState.destinations.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(width: 16),
                          itemBuilder: (_, index) => DestinationCard(
                            destination: uiState.destinations[index],
                          ),
                        ),
                      ),
                    const SizedBox(height: 24),

                    const SectionHeader('Previous Trips'),
                    const SizedBox(height: 12),

                    if (uiState.previousTrips.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          "You don't have any previous trips",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      )
                    else
                      ...uiState.previousTrips.map((trip) => Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: UpcomingTripCard(
                              trip: trip,
                              showDaysToGo: false,
                              onTap: () => onTripClick(
                                  trip.packageId, trip.bookingId, trip.orderId),
                            ),
                          )),
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
        );
      },
    );
  }
}
