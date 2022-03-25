import 'dart:async';
import 'dart:math';

import 'package:anti_propa_gondons/domain/main/entities/propa_gondon_resourse.dart';
import 'package:anti_propa_gondons/domain/main/logic/main_screen_notifier.dart';
import 'package:anti_propa_gondons/domain/main/total_requests.dart';
import 'package:anti_propa_gondons/service/colors.dart';
import 'package:anti_propa_gondons/service/routes.dart';
import 'package:anti_propa_gondons/service/universal_widgets/random_opacity.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yalo_locale/lib.dart';

const int _minMs = 250;
const int _maxMs = 1500;

Duration _generateDuration() {
  final int randomMs = Random().nextInt(_maxMs - _minMs) + _minMs;

  return Duration(milliseconds: randomMs);
}

class MainScreen extends StatefulWidget {
  const MainScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool _withRandomOpacity = true;

  Widget _propaGondonResourceBuilder(BuildContext context, int index) {
    final MainScreenNotifier mainScreenNotifier = Provider.of(context, listen: false);
    final PropaGondonResource resource = mainScreenNotifier.getResourceByIndex(index);

    final Widget tile = ListTile(
      title: Text(
        resource.url,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      onTap: () => mainScreenNotifier.togglePropaGondonResource(resource.url),
      leading: Checkbox(
        onChanged: (_) => mainScreenNotifier.togglePropaGondonResource(resource.url),
        value: mainScreenNotifier.isPropaGondonResourceDisabled(resource.url) == false,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: resource.successRequests.toString(),
                    style: const TextStyle(color: APGColors.success),
                  ),
                  const TextSpan(
                    text: ' / ',
                    style: TextStyle(
                      color: APGColors.text,
                    ),
                  ),
                  TextSpan(
                    text: resource.errorRequests.toString(),
                    style: const TextStyle(color: APGColors.error),
                  ),
                ],
              ),
            ),
          ),
          FloatingActionButton.small(
            onPressed: () => launch(resource.url),
            child: Icon(
              Icons.search,
              color: Theme.of(context).primaryColor,
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            highlightElevation: 0,
          ),
        ],
      ),
    );

    if (_withRandomOpacity) {
      return RandomOpacity(
        isAlwaysVisible: _withRandomOpacity == false,
        duration: _generateDuration(),
        child: tile,
      );
    }
    return tile;
  }

  void _disableRandomOpacity() {
    Timer(const Duration(milliseconds: _maxMs + 350), () {
      if (mounted) {
        setState(() {
          _withRandomOpacity = false;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    Provider.of<MainScreenNotifier>(context, listen: false).initialize();
  }

  @override
  Widget build(BuildContext context) {
    final LocalizationMessages loc = Messages.of(context);
    final MainScreenNotifier mainScreenNotifier = Provider.of<MainScreenNotifier>(context);

    final Widget mainScreen = Scaffold(
      appBar: AppBar(
        title: Text(loc.app.fullTitle),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).pushNamed(Routes.about),
            icon: const Icon(
              Icons.help_outline,
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          TotalRequests(
            totalRequests: mainScreenNotifier.totalRequests,
            requestsInWork: mainScreenNotifier.requestsInWork,
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              _propaGondonResourceBuilder,
              childCount: mainScreenNotifier.propaGondonResourcesCount,
            ),
          ),
        ],
      ),
    );
    const Widget loader = Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          backgroundColor: APGColors.uYellow,
        ),
      ),
    );

    return FutureBuilder<bool>(
      future: mainScreenNotifier.isInitialized,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        final bool isInitialized = snapshot.data ?? false;

        if (isInitialized && _withRandomOpacity) {
          _disableRandomOpacity();
        }

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: isInitialized ? mainScreen : loader,
        );
      },
    );
  }
}
