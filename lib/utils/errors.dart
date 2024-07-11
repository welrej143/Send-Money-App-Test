class ServerException implements Exception {
  final String message;

  ServerException({this.message = 'Server Exception'});

  @override
  String toString() {
    return message;
  }
}

class DataSourceException implements Exception {
  final String message;

  DataSourceException({this.message = 'Data source exception'});

  @override
  String toString() {
    return message;
  }
}
