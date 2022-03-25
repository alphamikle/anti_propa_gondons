abstract class Config {
  Config._();

  static const requestQueueSize = int.fromEnvironment('QUEUE_SIZE', defaultValue: 500);
  static const demoMode = bool.fromEnvironment('DEMO_MODE', defaultValue: false);
  static const requestsDelay = int.fromEnvironment('DELAY', defaultValue: 500);
}
