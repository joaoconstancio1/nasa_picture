mixin Env {
  String get baseUrl;
}

class EnvImpl implements Env {
  @override
  String get baseUrl => const String.fromEnvironment(
        'BASE_URL',
      );
}
