class CommonError {
  final String consoleMessage;
  final String? userMessage;

  const CommonError({this.consoleMessage = '', this.userMessage});
}

enum CommonStatus { initial, loading, success, failure }
