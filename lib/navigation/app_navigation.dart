import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../di/service_locator.dart';
import '../presentation/login/login_screen.dart';
import '../presentation/login/login_view_model.dart';
import '../presentation/messages/messages_screen.dart';
import '../presentation/messages/messages_view_model.dart';
import '../presentation/profile/profile_screen.dart';
import '../presentation/profile/profile_view_model.dart';
import '../presentation/trip_details/trip_details_screen.dart';
import '../presentation/trip_details/trip_details_view_model.dart';
import '../presentation/trips/trips_screen.dart';
import '../presentation/trips/trips_view_model.dart';

// Unique keys that identify each navigation layer. Flutter needs these to manage
// separate navigation stacks (e.g. root vs tabs inside the shell).
final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

// Creates the GoRouter: the object that decides which screen to show based on
// the URL path. Think of it like a traffic controller for your app's screens.
GoRouter createRouter({required bool isLoggedIn}) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    // Where the user lands when the app opens: messages if logged in, login if not.
    initialLocation: isLoggedIn ? '/messages' : '/login',
    routes: [
      // Login screen: shown when user is not logged in. No bottom nav bar here.
      GoRoute(
        path: '/login',
        builder: (context, state) {
          // ChangeNotifierProvider makes the LoginViewModel available to LoginScreen
          // and any child widgets. They can listen for updates and rebuild when data changes.
          return ChangeNotifierProvider(
            create: (_) => getIt<LoginViewModel>(),
            child: LoginScreen(
              onLoginSuccess: () {
                // context.go() replaces the entire navigation stack with /messages.
                // Use go when switching tabs or "going home" (no back button).
                context.go('/messages');
              },
            ),
          );
        },
      ),

      // ShellRoute wraps multiple child routes with shared UI. Here, the bottom
      // nav bar is shared; only the main content area changes when switching tabs.
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return _MainShell(child: child);
        },
        routes: [
          GoRoute(
            path: '/messages',
            // NoTransitionPage: switches tabs instantly without slide/fade animation.
            // This feels natural for tab switching (like Instagram or Twitter).
            pageBuilder: (context, state) => const NoTransitionPage(
              child: _MessagesPage(),
            ),
          ),
          GoRoute(
            path: '/trips',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: _TripsPage(),
            ),
          ),
          GoRoute(
            path: '/profile',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: _ProfilePage(),
            ),
          ),
        ],
      ),

      // Trip details: full-screen page when user taps a trip. No bottom nav,
      // and user can press back to return to the trips list.
      GoRoute(
        path: '/trip_details/:packageId/:bookingId/:orderId',
        builder: (context, state) {
          // Extract URL parameters: the :packageId, :bookingId, :orderId from the path.
          final packageId =
              int.tryParse(state.pathParameters['packageId'] ?? '0');
          final bookingId =
              int.tryParse(state.pathParameters['bookingId'] ?? '0');
          final orderId = state.pathParameters['orderId'];

          return ChangeNotifierProvider(
            create: (_) => getIt<TripDetailsViewModel>(),
            child: TripDetailsScreen(
              packageId: packageId == 0 ? null : packageId,
              bookingId: bookingId == 0 ? null : bookingId,
              orderId: orderId == 'null' ? null : orderId,
              // context.pop() goes back one screen (like pressing the back button).
              onNavigateBack: () => context.pop(),
            ),
          );
        },
      ),
    ],
  );
}

// The shell wraps the current tab's content and adds a bottom navigation bar.
// The child is whatever screen is active (Messages, Trips, or Profile).
class _MainShell extends StatelessWidget {
  final Widget child;

  const _MainShell({required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: _BottomNavBar(),
    );
  }
}

// Material 3 bottom navigation bar with three tabs: Messages, Trips, Profile.
class _BottomNavBar extends StatelessWidget {
  static const _navItems = [
    _NavItem('/messages', 'Messages', Icons.message, Icons.message_outlined),
    _NavItem(
        '/trips', 'Trips', Icons.flight_takeoff, Icons.flight_takeoff_outlined),
    _NavItem('/profile', 'Profile', Icons.person, Icons.person_outline),
  ];

  @override
  Widget build(BuildContext context) {
    // Get current URL path to know which tab is selected.
    final location = GoRouterState.of(context).uri.toString();
    int selectedIndex = 0;
    for (int i = 0; i < _navItems.length; i++) {
      if (location.startsWith(_navItems[i].path)) {
        selectedIndex = i;
        break;
      }
    }

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE0E0E0), width: 0.5)),
      ),
      child: NavigationBar(
        backgroundColor: Colors.white,
        elevation: 0,
        indicatorColor: Colors.transparent,
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          // context.go() switches tabs by navigating to the new path.
          // The shell stays; only the child content changes.
          context.go(_navItems[index].path);
        },
        destinations: _navItems.map((item) {
          final isSelected =
              location.startsWith(item.path);
          return NavigationDestination(
            icon: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isSelected ? item.selectedIcon : item.unselectedIcon,
                  color: isSelected
                      ? const Color(0xFFFF6600)
                      : const Color(0xFF666666),
                ),
                const SizedBox(height: 4),
                Text(
                  item.label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected
                        ? const Color(0xFFFF6600)
                        : const Color(0xFF666666),
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  width: 40,
                  height: 2,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFFFF6600)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
              ],
            ),
            label: '',
          );
        }).toList(),
      ),
    );
  }
}

// Helper class to define each tab: path (URL), label, and icons for selected/unselected.
class _NavItem {
  final String path;
  final String label;
  final IconData selectedIcon;
  final IconData unselectedIcon;

  const _NavItem(this.path, this.label, this.selectedIcon, this.unselectedIcon);
}

// Each tab uses a page wrapper that creates its own ViewModel via Provider.
// This way, when you switch tabs, each tab gets a fresh ViewModel. Without this,
// the ViewModel would be shared and might show stale data when switching back.
class _MessagesPage extends StatelessWidget {
  const _MessagesPage();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => getIt<MessagesViewModel>(),
      child: const MessagesScreen(),
    );
  }
}

class _TripsPage extends StatelessWidget {
  const _TripsPage();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => getIt<TripsViewModel>(),
      child: TripsScreen(
        onLogout: () => context.go('/login'),
        // context.push() adds trip details on top of the current screen.
        // User can go back to trips list with the back button.
        onTripClick: (packageId, bookingId, orderId) {
          context.push(
            '/trip_details/${packageId ?? 0}/${bookingId ?? 0}/${orderId ?? "null"}',
          );
        },
      ),
    );
  }
}

class _ProfilePage extends StatelessWidget {
  const _ProfilePage();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => getIt<ProfileViewModel>(),
      child: ProfileScreen(
        onLogout: () => context.go('/login'),
      ),
    );
  }
}
