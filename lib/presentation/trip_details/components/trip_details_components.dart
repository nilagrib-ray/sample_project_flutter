import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../domain/model/trip_details_domain.dart';

class CountdownCard extends StatelessWidget {
  final int days;
  final int hours;
  final int minutes;

  const CountdownCard({
    super.key,
    required this.days,
    required this.hours,
    required this.minutes,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _CountdownItem(value: days, label: 'Days'),
              _CountdownItem(value: hours, label: 'Hours'),
              _CountdownItem(value: minutes, label: 'Minutes'),
            ],
          ),
        ),
      ),
    );
  }
}

class _CountdownItem extends StatelessWidget {
  final int value;
  final String label;

  const _CountdownItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value.toString(),
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
      ],
    );
  }
}

class ActionRequiredCard extends StatelessWidget {
  final ActionRequired action;
  final VoidCallback? onTap;

  const ActionRequiredCard({super.key, required this.action, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.error_outline,
                    color: Color(0xFFFF6600), size: 32),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    action.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                const Icon(Icons.chevron_right, color: Colors.black, size: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TravellerCard extends StatelessWidget {
  final Traveller traveller;

  const TravellerCard({super.key, required this.traveller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: const Color(0xFFE0E0E0),
            child:
                const Icon(Icons.person, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                traveller.fullName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              if (traveller.isLeadBooker)
                const Text(
                  'Lead Booker',
                  style: TextStyle(fontSize: 14, color: Color(0xFFFF6600)),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class DestinationLinkCard extends StatelessWidget {
  final String destinationName;
  final VoidCallback? onTap;

  const DestinationLinkCard({
    super.key,
    required this.destinationName,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Card(
        color: const Color(0xFFF5F5F5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 1,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Discover your resort',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        destinationName,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFFFF6600),
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: Colors.black, size: 28),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LinkFriendsCard extends StatelessWidget {
  final VoidCallback? onTap;
  const LinkFriendsCard({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFF8800), Color(0xFFFF6600), Color(0xFFFF5500)],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: const Text(
            'Link with friends bookings',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class SectionHeaderRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color iconTint;
  final String? trailingText;
  final IconData? trailingIcon;

  const SectionHeaderRow({
    super.key,
    required this.icon,
    required this.title,
    this.iconTint = Colors.black,
    this.trailingText,
    this.trailingIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: iconTint, size: 28),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          if (trailingText != null)
            Text(
              trailingText!,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFFFF6600),
              ),
            ),
          if (trailingIcon != null)
            Icon(trailingIcon!, color: Colors.black, size: 28),
        ],
      ),
    );
  }
}

class DestinationMap extends StatelessWidget {
  final double latitude;
  final double longitude;
  final String destinationName;

  const DestinationMap({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.destinationName,
  });

  @override
  Widget build(BuildContext context) {
    final position = LatLng(latitude, longitude);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          height: 250,
          child: GoogleMap(
            initialCameraPosition: CameraPosition(
              target: position,
              zoom: 13,
            ),
            markers: {
              Marker(
                markerId: const MarkerId('destination'),
                position: position,
                infoWindow: InfoWindow(
                  title: destinationName,
                  snippet: 'Your destination',
                ),
              ),
            },
            zoomControlsEnabled: false,
            myLocationButtonEnabled: false,
            compassEnabled: true,
            mapToolbarEnabled: true,
          ),
        ),
      ),
    );
  }
}

// ── Helper Functions ──────────────────────────────────────────

String formatDateDayMonth(String dateString) {
  try {
    final parts = dateString.split('-');
    if (parts.length == 3) {
      final day = parts[2];
      const months = [
        '', 'January', 'February', 'March', 'April', 'May', 'June',
        'July', 'August', 'September', 'October', 'November', 'December'
      ];
      final monthIndex = int.tryParse(parts[1]) ?? 0;
      final month = monthIndex > 0 && monthIndex <= 12
          ? months[monthIndex]
          : parts[1];
      return '$day $month';
    }
    return dateString;
  } catch (_) {
    return dateString;
  }
}

String formatDateYear(String dateString) {
  try {
    final parts = dateString.split('-');
    return parts.length == 3 ? parts[0] : dateString;
  } catch (_) {
    return dateString;
  }
}

String formatDateNumeric(String dateString) {
  try {
    final parts = dateString.split('-');
    if (parts.length == 3) {
      return '${parts[2]}/${parts[1]}/${parts[0]}';
    }
    return dateString;
  } catch (_) {
    return dateString;
  }
}

String formatAmount(String? amount) {
  if (amount == null || amount.isEmpty) return '0.00';
  final value = double.tryParse(amount);
  return value != null ? value.toStringAsFixed(2) : amount;
}
