import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'components/profile_action_card.dart';
import 'profile_view_model.dart';

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
            child: Column(
              children: [
                const SizedBox(height: 8),

                // Profile avatar with glow
                SizedBox(
                  width: 280,
                  height: 280,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Blurred gradient glow
                      Container(
                        width: 200,
                        height: 200,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [Color(0xFFFF0099), Color(0xFFFF6600)],
                          ),
                        ),
                        child: ClipOval(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
                            child: Container(color: Colors.transparent),
                          ),
                        ),
                      ),
                      // White circle with icon
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
