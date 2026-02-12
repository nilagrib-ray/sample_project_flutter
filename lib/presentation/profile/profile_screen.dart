import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'components/profile_action_card.dart';
import 'profile_view_model.dart';

// StatelessWidget: No local mutable state. Profile data comes from ViewModel.
class ProfileScreen extends StatelessWidget {
  final VoidCallback onLogout;

  const ProfileScreen({super.key, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileViewModel>(
      builder: (context, viewModel, _) {
        final uiState = viewModel.uiState;

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: const Text(
              'Profile',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 32,
                color: Colors.black,
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Icon(Icons.tune, color: Colors.black, size: 32),
              ),
            ],
          ),
          body: SingleChildScrollView(
            // Column: Arranges elements vertically - avatar, name, buttons, etc.
            child: Column(
              children: [
                const SizedBox(height: 8),

                // Profile avatar: Stack creates layered effect - gradient glow
                // behind, white circle with icon on top. RadialGradient gives
                // soft glow from center outward.
                SizedBox(
                  width: 300,
                  height: 300,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 300,
                        height: 300,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            center: Alignment.center,
                            radius: 0.5,
                            colors: [
                              Color(0x50FF6600),
                              Color(0x40FF3377),
                              Color(0x25FF0099),
                              Color(0x08FF0099),
                              Color(0x00FF0099),
                            ],
                            stops: [0.0, 0.35, 0.55, 0.75, 1.0],
                          ),
                        ),
                      ),
                      Container(
                        width: 190,
                        height: 190,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border:
                              Border.all(color: const Color(0xFFF0F0F0)),
                        ),
                        child: const Icon(
                          Icons.person_outline,
                          color: Color(0xFFCCCCCC),
                          size: 120,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Developer',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  uiState.userEmail,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF666666),
                  ),
                ),
                const SizedBox(height: 4),

                TextButton(
                  onPressed: () => _showLogoutDialog(context, viewModel),
                  child: const Text(
                    'Log Out',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFFF6600),
                      decoration: TextDecoration.underline,
                      decorationColor: Color(0xFFFF6600),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Action cards: Each is a tappable row (icon + label + title)
                ProfileActionCard(
                  label: 'Make a change',
                  title: 'Update Details',
                  icon: Icons.person_outline,
                  onTap: () {},
                ),
                const SizedBox(height: 12),
                ProfileActionCard(
                  label: 'Got a question?',
                  title: "View our FAQ's",
                  icon: Icons.help,
                  onTap: () {},
                ),
                const SizedBox(height: 12),
                ProfileActionCard(
                  label: 'Need help?',
                  title: 'Send a Flare',
                  icon: Icons.auto_awesome,
                  onTap: () {},
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  // Shows confirmation dialog before logout. Navigator.pop closes the dialog.
  void _showLogoutDialog(BuildContext context, ProfileViewModel viewModel) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              viewModel.logout();
              onLogout();
            },
            child: const Text('Yes',
                style: TextStyle(color: Color(0xFFFF6600))),
          ),
        ],
      ),
    );
  }
}
