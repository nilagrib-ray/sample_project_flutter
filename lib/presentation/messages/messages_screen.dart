import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/model/contact_domain.dart';
import 'components/contact_item.dart';
import 'messages_view_model.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MessagesViewModel>(
      builder: (context, viewModel, _) {
        final uiState = viewModel.uiState;

        final keyContacts = [
          const KeyContact(
              name: 'Party Hard',
              subtitle: 'UK Office Team',
              isWhatsApp: true),
          KeyContact(
            name: 'Party Hard Emergency Number',
            subtitle: uiState.globalEmergencyNumber,
            contactInfo: uiState.globalEmergencyNumber,
          ),
          const KeyContact(
            name: 'Local Emergency Services',
            subtitle: 'Ambulance / Fire / Police',
          ),
        ];

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: const Text(
              'Messages',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 28,
                color: Colors.black,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {/* TODO: Notifications */},
                icon: const Icon(Icons.notifications_outlined,
                    color: Colors.black, size: 36),
              ),
            ],
          ),
          body: Stack(
            children: [
              if (uiState.isLoading)
                const Center(
                  child: CircularProgressIndicator(
                      color: Color(0xFFFF6600)),
                )
              else
                ListView(
                  children: [
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        uiState.destinationName.isNotEmpty
                            ? '${uiState.destinationName} Reps'
                            : 'Reps',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    if (uiState.reps.isEmpty) ...[
                      _EmptyStateCard('No reps available'),
                      const SizedBox(height: 24),
                    ] else
                      ...uiState.reps.map((contact) => Column(
                            children: [
                              ContactItem(contact: contact),
                              const Divider(
                                indent: 20,
                                endIndent: 20,
                                color: Color(0xFFE0E0E0),
                              ),
                            ],
                          )),

                    const SizedBox(height: 24),
                    const SendFlareCard(),
                    const SizedBox(height: 32),

                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'Key Contacts',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    ...keyContacts.asMap().entries.map((entry) {
                      final index = entry.key;
                      final contact = entry.value;
                      return Column(
                        children: [
                          KeyContactItem(contact: contact),
                          if (index < keyContacts.length - 1)
                            const Divider(
                              indent: 20,
                              endIndent: 20,
                              color: Color(0xFFE0E0E0),
                            ),
                        ],
                      );
                    }),

                    const SizedBox(height: 32),
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

class _EmptyStateCard extends StatelessWidget {
  final String message;
  const _EmptyStateCard(this.message);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            message,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ),
    );
  }
}
