enum Environment { dev, staging, prod }

class AppConfig {
  static AppConfig? _instance;
  static AppConfig get instance {
    _instance ??= AppConfig.initialize();
    return _instance!;
  }

  final Environment environment;
  final String baseUrl;

  const AppConfig._({required this.environment, required this.baseUrl});

  factory AppConfig.initialize() {
    const env = String.fromEnvironment('ENV', defaultValue: 'dev');

    final config = switch (env) {
      'prod' => const AppConfig._(
          environment: Environment.prod,
          baseUrl: 'https://api.cheeringshop.online/api/v1',
        ),
      'staging' => const AppConfig._(
          environment: Environment.staging,
          baseUrl: 'https://api.cheeringshop.online/api/v1',
        ),
      _ => const AppConfig._(
          environment: Environment.dev,
          baseUrl: 'https://api.cheeringshop.online/api/v1',
        ),
    };

    _instance = config;
    return config;
  }

  bool get isDev => environment == Environment.dev;
  bool get isStaging => environment == Environment.staging;
  bool get isProd => environment == Environment.prod;
}

// fvm flutter run --dart-define=ENV=dev
// fvm flutter run --dart-define=ENV=prod
