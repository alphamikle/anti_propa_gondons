import 'package:anti_propa_gondons/domain/main/logic/main_screen_notifier.dart';

class PropaGondonResource {
  const PropaGondonResource({
    required this.url,
    required this.successRequests,
    required this.errorRequests,
  });

  factory PropaGondonResource.fromUrl(PropaGondonUrl url) {
    return PropaGondonResource(
      url: url,
      successRequests: 0,
      errorRequests: 0,
    );
  }

  final String url;
  final int successRequests;
  final int errorRequests;

  PropaGondonResource copyWith({
    String? url,
    int? successRequests,
    int? errorRequests,
  }) {
    return PropaGondonResource(
      url: url ?? this.url,
      successRequests: successRequests ?? this.successRequests,
      errorRequests: errorRequests ?? this.errorRequests,
    );
  }

  @override
  String toString() {
    return 'PropaGondonResource{url: $url, successRequests: $successRequests, errorRequests: $errorRequests}';
  }
}
