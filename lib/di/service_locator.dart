import 'package:get_it/get_it.dart';

import '../data/local/preferences_manager.dart';
import '../data/remote/api_service.dart';
import '../data/repository/auth_repository_impl.dart';
import '../data/repository/contact_repository_impl.dart';
import '../data/repository/trip_repository_impl.dart';
import '../domain/repository/auth_repository.dart';
import '../domain/repository/contact_repository.dart';
import '../domain/repository/trip_repository.dart';
import '../domain/usecase/get_contacts_usecase.dart';
import '../domain/usecase/get_destinations_usecase.dart';
import '../domain/usecase/get_itinerary_usecase.dart';
import '../domain/usecase/get_trip_details_usecase.dart';
import '../domain/usecase/get_trips_usecase.dart';
import '../domain/usecase/login_usecase.dart';
import '../presentation/login/login_view_model.dart';
import '../presentation/messages/messages_view_model.dart';
import '../presentation/profile/profile_view_model.dart';
import '../presentation/trip_details/trip_details_view_model.dart';
import '../presentation/trips/trips_view_model.dart';

/// GetIt is a service locator - a central place that creates and stores objects.
/// Instead of ClassA creating its own ClassB, we ask GetIt for ClassB. That's Dependency Injection (DI).
final getIt = GetIt.instance;

/// Registers all app dependencies. Call this at app startup.
/// Order matters: register things before other things that depend on them.
void setupServiceLocator() {
  // ── Core / Network ──────────────────────────────────────────────
  // registerLazySingleton: create once, reuse forever. Good for ApiService, PreferencesManager.
  getIt.registerLazySingleton<ApiService>(() => ApiService());
  getIt.registerLazySingleton<PreferencesManager>(() => PreferencesManager());

  // ── Repositories ────────────────────────────────────────────────
  // Repositories need ApiService/PreferencesManager, so we get them from GetIt.
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      apiService: getIt<ApiService>(),
      preferencesManager: getIt<PreferencesManager>(),
    ),
  );

  getIt.registerLazySingleton<TripRepository>(
    () => TripRepositoryImpl(apiService: getIt<ApiService>()),
  );

  getIt.registerLazySingleton<ContactRepository>(
    () => ContactRepositoryImpl(apiService: getIt<ApiService>()),
  );

  // ── Use Cases ───────────────────────────────────────────────────
  // registerFactory: create a new instance every time getIt<LoginUseCase>() is called.
  // Use for ViewModels and UseCases that should be fresh per screen.
  getIt.registerFactory<LoginUseCase>(
    () => LoginUseCase(repository: getIt<AuthRepository>()),
  );

  getIt.registerFactory<GetTripsUseCase>(
    () => GetTripsUseCase(
      tripRepository: getIt<TripRepository>(),
      authRepository: getIt<AuthRepository>(),
    ),
  );

  getIt.registerFactory<GetDestinationsUseCase>(
    () => GetDestinationsUseCase(tripRepository: getIt<TripRepository>()),
  );

  getIt.registerFactory<GetTripDetailsUseCase>(
    () => GetTripDetailsUseCase(
      tripRepository: getIt<TripRepository>(),
      authRepository: getIt<AuthRepository>(),
    ),
  );

  getIt.registerFactory<GetItineraryUseCase>(
    () => GetItineraryUseCase(
      tripRepository: getIt<TripRepository>(),
      authRepository: getIt<AuthRepository>(),
    ),
  );

  getIt.registerFactory<GetContactsUseCase>(
    () => GetContactsUseCase(
      contactRepository: getIt<ContactRepository>(),
      authRepository: getIt<AuthRepository>(),
    ),
  );

  // ── ViewModels ──────────────────────────────────────────────────
  getIt.registerFactory<LoginViewModel>(
    () => LoginViewModel(loginUseCase: getIt<LoginUseCase>()),
  );

  getIt.registerFactory<TripsViewModel>(
    () => TripsViewModel(
      getTripsUseCase: getIt<GetTripsUseCase>(),
      getDestinationsUseCase: getIt<GetDestinationsUseCase>(),
      authRepository: getIt<AuthRepository>(),
    ),
  );

  getIt.registerFactory<MessagesViewModel>(
    () => MessagesViewModel(getContactsUseCase: getIt<GetContactsUseCase>()),
  );

  getIt.registerFactory<ProfileViewModel>(
    () => ProfileViewModel(authRepository: getIt<AuthRepository>()),
  );

  getIt.registerFactory<TripDetailsViewModel>(
    () => TripDetailsViewModel(
      getTripDetailsUseCase: getIt<GetTripDetailsUseCase>(),
      getItineraryUseCase: getIt<GetItineraryUseCase>(),
    ),
  );
}
