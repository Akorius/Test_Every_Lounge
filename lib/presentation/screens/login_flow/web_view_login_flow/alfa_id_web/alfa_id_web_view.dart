import 'dart:async';

import 'package:everylounge/core/di/get_it.dart';
import 'package:everylounge/presentation/screens/login_flow/web_view_login_flow/alfa_id_web/failure_value.dart';
import 'package:everylounge/presentation/screens/login_flow/web_view_login_flow/alfa_id_web/result.dart';
import 'package:flutter/material.dart';
import 'package:native_launcher/native_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AlfaIdWebView extends StatefulWidget {
  final String link;
  final bool clearCookies;
  final bool showProgressIndicator;
  final Function(AlfaIdResult result) onWebViewFinished;

  const AlfaIdWebView({
    Key? key,
    required this.onWebViewFinished,
    required this.link,
    this.clearCookies = false,
    this.showProgressIndicator = false,
  }) : super(key: key);

  @override
  State<AlfaIdWebView> createState() => _AlfaIdWebViewState();
}

class _AlfaIdWebViewState extends State<AlfaIdWebView> {
  late final WebViewController _webViewController;

  bool _isLoading = true;

  @override
  void initState() {
    var uri = Uri.parse(widget.link);
    NativeLauncher launcher = getIt();
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) async {
            if (request.url.contains('aid://everyloungeauth')) {
              _processSuccessUrl(request.url);
              return NavigationDecision.prevent;
            }
            if (request.url.contains('aid://login_by_qr')) {
              launcher.launchAppByDeeplink(
                deeplink: request.url,
                packageName: "alfabank",
                errorCallback: (e) => {
                  _onFinished(AlfaIdResult.failure(
                      "Не удалось найти приложение. Выполните вход по номеру телефона", AlfaIdFailure.clientNotFound))
                },
              );
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
          onPageStarted: (String url) async {
            if (url.contains(uri.toString())) {
              _setLoading(true);
            }
          },
          onPageFinished: (String url) {
            _setLoading(false);
          },
          onWebResourceError: (WebResourceError error) async {
            // ///ios fix
            // if ((await _webViewController.currentUrl())
            //         ?.contains("https://id.alfa.ru/auth/step?cid") ??
            //     true) {
            //   return;
            // }
            _onFinished(AlfaIdResult.failure(error.description, AlfaIdFailure.webResourceError));
          },
        ),
      );
    if (widget.clearCookies) {
      WebViewCookieManager().clearCookies();
    }
    Future.delayed(
      const Duration(milliseconds: 200),
      () => _webViewController.loadRequest(uri),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        _onFinished(AlfaIdResult.failure("Cancelled by user.", AlfaIdFailure.cancelledByUser));
        return Future(() => false);
      },
      child: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                WebViewWidget(
                  controller: _webViewController,
                ),
                if (widget.showProgressIndicator)
                  Visibility(
                    visible: _isLoading,
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFEF3124),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _processSuccessUrl(String url) async {
    final queryParameters = Uri.parse(url).queryParameters;
    final code = queryParameters["code"];
    if (code?.isNotEmpty ?? false) {
      _onFinished(AlfaIdResult.success(code!));
    } else {
      _onFinished(AlfaIdResult.failure(
        "There was no validation code in the redirected link.",
        AlfaIdFailure.noCodeInRedirectUri,
      ));
    }
  }

  _onFinished(AlfaIdResult result) => widget.onWebViewFinished(result);

  _setLoading(bool loading) {
    setState(() {
      _isLoading = loading;
    });
  }
}
