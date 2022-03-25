import 'package:anti_propa_gondons/domain/main/logic/main_screen_notifier.dart';
import 'package:anti_propa_gondons/service/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yalo_locale/lib.dart';

const double _infoContainerHeight = 80;
const double _controlContainerHeight = 56;

class TotalRequests extends StatelessWidget {
  const TotalRequests({
    required this.totalRequests,
    required this.requestsInWork,
    Key? key,
  }) : super(key: key);

  final int totalRequests;
  final int requestsInWork;

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      delegate: _TotalRequestsDelegate(
        totalRequests: totalRequests,
        requestsInWork: requestsInWork,
      ),
      floating: true,
    );
  }
}

class _TotalRequestsDelegate extends SliverPersistentHeaderDelegate {
  _TotalRequestsDelegate({
    required this.totalRequests,
    required this.requestsInWork,
  });

  final int totalRequests;
  final int requestsInWork;

  @override
  double get maxExtent => _infoContainerHeight + _controlContainerHeight;

  @override
  double get minExtent => maxExtent;

  @override
  bool shouldRebuild(_TotalRequestsDelegate oldDelegate) {
    return oldDelegate.totalRequests != totalRequests || oldDelegate.requestsInWork != requestsInWork;
  }

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final LocalizationMessages loc = Messages.of(context);
    final MainScreenNotifier mainScreenNotifier = Provider.of(context);
    final MainScreenNotifier mainScreenNotifierReadOnly = Provider.of(context, listen: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: _infoContainerHeight,
          width: MediaQuery.of(context).size.width,
          color: APGColors.uYellow,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 16),
                child: Text(
                  '${loc.main.requestsInWork}: $requestsInWork',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Text(
                  '${loc.main.totalRequests}: $totalRequests',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: _controlContainerHeight,
          width: MediaQuery.of(context).size.width,
          child: Material(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: ListTile(
              onTap: mainScreenNotifierReadOnly.togglePropaGondonResources,
              leading: Checkbox(
                value: mainScreenNotifier.isAllResourceDisabled
                    ? false
                    : mainScreenNotifier.isAnyResourceDisabled
                        ? null
                        : true,
                onChanged: (_) => mainScreenNotifierReadOnly.togglePropaGondonResources(),
                tristate: true,
              ),
              title: Text(
                mainScreenNotifier.isAllResourceDisabled ? loc.main.controls.enable : loc.main.controls.disable,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        )
      ],
    );
  }
}
