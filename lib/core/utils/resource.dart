/// A sealed class is a class that can only have a fixed set of subclasses defined
/// in the same file. The compiler knows all possible variants, so you can safely
/// use a switch to handle each case without missing any.
///
/// The `T` is a generic type -- it means "some type we'll specify later." When you
/// use `Resource<String>`, T becomes String; when you use `Resource<UserDomain>`,
/// T becomes UserDomain. This lets one class work with any data type.
sealed class Resource<T> {
  const Resource();
}

/// Represents a successful API call or data operation. The [data] field holds
/// the actual result (e.g. a user object, a list of trips). Use this when
/// everything went well and you have data to display.
class ResourceSuccess<T> extends Resource<T> {
  final T data;
  const ResourceSuccess(this.data);
}

/// Represents a failed operation. The [message] tells the user what went wrong
/// (e.g. "Invalid password" or "Network error"). Use this when something fails
/// so the UI can show an error message.
class ResourceError<T> extends Resource<T> {
  final String message;
  const ResourceError(this.message);
}

/// Represents an operation that is still in progress (e.g. waiting for the API).
/// No data yet—use this to show a loading spinner or skeleton on the screen.
class ResourceLoading<T> extends Resource<T> {
  const ResourceLoading();
}
