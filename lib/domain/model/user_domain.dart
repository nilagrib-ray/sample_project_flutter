/// A domain model represents business data in a clean, app-focused way. It lives
/// in the "domain" layer—independent of where the data comes from (API, DB) or
/// how it's displayed (UI). This keeps the app logic simple and testable.
class UserDomain {
  final String userId;
  final String userType;
  final String userEmail;
  final String? userName;
  final String? token;
  final String? firstName;
  final String? lastName;
  final String? profileImage;

  /// The ? after a type (e.g. String?) means "nullable"—the value can be null
  /// (missing). required fields must always be provided; optional ones can be
  /// omitted when creating a UserDomain.
  const UserDomain({
    required this.userId,
    required this.userType,
    required this.userEmail,
    this.userName,
    this.token,
    this.firstName,
    this.lastName,
    this.profileImage,
  });
}
