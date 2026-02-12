/// Sealed class equivalent for handling API responses.
/// Mirrors the Kotlin `Resource<T>` sealed class.
sealed class Resource<T> {
  const Resource();
}

class ResourceSuccess<T> extends Resource<T> {
  final T data;
  const ResourceSuccess(this.data);
}

class ResourceError<T> extends Resource<T> {
  final String message;
  const ResourceError(this.message);
}

class ResourceLoading<T> extends Resource<T> {
  const ResourceLoading();
}