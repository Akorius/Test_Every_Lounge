import 'package:everylounge/domain/data/storages/remote_config.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/widgets/appbars/back_arrow.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tinkoff_id_web/tinkoff_id_web.dart';

class TinkoffIdWebViewScreen extends StatelessWidget {
  static const path = "tinkoffIdWeb";
  final RemoteConfigStorage storage;

  const TinkoffIdWebViewScreen({Key? key, required this.storage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: Stack(
          children: [
            TinkoffIdWebView(
              onWebViewFinished: (result) {
                context.pop<TinkoffIdResult>(result);
              },
              clientId: storage.tinkoffIdClientId,
              mobileRedirectUri: storage.tinkoffIdRedirectUri,
              clearCookies: false,
              showProgressIndicator: true,
            ),
            Positioned(
              top: 10,
              left: 16,
              child: BackArrowButton(color: context.colors.buttonTinkoffBackground),
            ),
          ],
        ),
      ),
    );
  }
}
