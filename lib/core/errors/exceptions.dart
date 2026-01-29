class ServerException implements Exception {
  final String message;
  final int? statusCode;
  final String url;

  const ServerException({this.message = 'Server Error', this.statusCode, this.url = ''});

  @override
  String toString() => 'url: $url \nServerException $message (status code: $statusCode)';
}