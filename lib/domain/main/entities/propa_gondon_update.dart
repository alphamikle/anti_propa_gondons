import 'package:anti_propa_gondons/domain/main/logic/main_screen_notifier.dart';

class PropaGondonUpdate {
  const PropaGondonUpdate({
    required this.url,
    required this.isSuccess,
  });

  factory PropaGondonUpdate.ok(PropaGondonUrl url) {
    return PropaGondonUpdate(url: url, isSuccess: true);
  }

  factory PropaGondonUpdate.error(PropaGondonUrl url) {
    return PropaGondonUpdate(url: url, isSuccess: false);
  }

  final String url;
  final bool isSuccess;

  PropaGondonUpdate copyWith({
    String? url,
    bool? isSuccess,
  }) {
    return PropaGondonUpdate(
      url: url ?? this.url,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }

  @override
  String toString() {
    return 'PropaGondonUpdate{url: $url, isSuccess: $isSuccess}';
  }
}
