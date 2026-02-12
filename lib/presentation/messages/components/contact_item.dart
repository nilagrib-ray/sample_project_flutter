import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../domain/model/contact_domain.dart';

/// A row showing a contact's avatar, name, pronouns, and a WhatsApp icon.
/// Used to display a regular contact in the messages screen.
class ContactItem extends StatelessWidget {
  final ContactDomain contact;

  const ContactItem({super.key, required this.contact});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          // ClipOval crops the image into a circle
          ClipOval(
            child: CachedNetworkImage(
              imageUrl: contact.imageUrl ?? 'https://via.placeholder.com/150',
              width: 56,
              height: 56,
              fit: BoxFit.cover,
              placeholder: (_, _) => Container(
                width: 56,
                height: 56,
                color: const Color(0xFFE0E0E0),
              ),
              errorWidget: (_, _, _) => Container(
                width: 56,
                height: 56,
                color: const Color(0xFFE0E0E0),
                child: const Icon(Icons.person, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Expanded lets the name/pronouns take up remaining space in the row
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  contact.fullName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  contact.pronouns,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFFFF6600),
                  ),
                ),
              ],
            ),
          ),
          // FaIcon uses Font Awesome icons (e.g. WhatsApp brand icon)
          const FaIcon(
            FontAwesomeIcons.whatsapp,
            color: Colors.black,
            size: 26,
          ),
        ],
      ),
    );
  }
}

/// A black card prompting the user to "Send a Flare" when they need help.
/// Tappable via InkWell (shows ripple effect on tap).
class SendFlareCard extends StatelessWidget {
  const SendFlareCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Card(
        color: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        child: InkWell(
          onTap: () {/* TODO: Send Flare */},
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Need help?',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFFFF6600),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Send a Flare',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                const Icon(Icons.auto_awesome, color: Colors.white, size: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A row for emergency/key contacts showing name, subtitle, and icon.
/// Shows WhatsApp icon if contact uses WhatsApp, otherwise phone icon.
class KeyContactItem extends StatelessWidget {
  final KeyContact contact;

  const KeyContactItem({super.key, required this.contact});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  contact.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  contact.subtitle,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFFFF6600),
                  ),
                ),
              ],
            ),
          ),
          contact.isWhatsApp
              ? const FaIcon(FontAwesomeIcons.whatsapp,
                  color: Colors.black, size: 26)
              : const Icon(Icons.phone_outlined, color: Colors.black, size: 26),
        ],
      ),
    );
  }
}
