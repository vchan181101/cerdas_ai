sealed class UiState<T> {
  const UiState();
}

class Initial<T> extends UiState<T> {
  const Initial();
}

class Loading<T> extends UiState<T> {
  const Loading();
}

class Success<T> extends UiState<T> {
  final T data;
  const Success(this.data);
}

class Error<T> extends UiState<T> {
  final String message;
  const Error(this.message);
}
