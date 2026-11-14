class ApiConstants {
  ApiConstants._();

  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8030/api',
  );

  static const String login = '/login';
  static const String tasks = '/tasks';
}
