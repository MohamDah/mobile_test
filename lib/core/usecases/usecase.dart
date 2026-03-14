/// Base contract for every use-case in FitLife.
///
/// [T]   – the return type wrapped in a [Future].
/// [P] – the parameter object. Use [NoParams] when none are needed.
abstract interface class UseCase<T, P> {
  Future<T> call(P params);
}

/// Sentinel class passed to [UseCase.call] when no parameters are required.
class NoParams {
  const NoParams();
}
