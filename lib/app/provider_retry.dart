/// Screens offer explicit retry. Automatic retry would hide a 404 behind
/// loading and make a refused deep link look like a slow request.
Duration? appRetry(int retryCount, Object error) => null;
