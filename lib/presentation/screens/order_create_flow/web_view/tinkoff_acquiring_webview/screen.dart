import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:duration/duration.dart';
import 'package:everylounge/core/config.dart';
import 'package:everylounge/core/di/get_it.dart';
import 'package:everylounge/data/constants/event_description.dart';
import 'package:everylounge/domain/entities/bank/card_type.dart';
import 'package:everylounge/domain/entities/common/logger.dart';
import 'package:everylounge/domain/usecases/metrics/appMetrica/metrics.dart';
import 'package:everylounge/domain/usecases/metrics/appMetrica/metrics_event_type.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/screens/order_create_flow/web_view/tinkoff_acquiring_webview/widget/custom_app_bar_web_view.dart';
import 'package:everylounge/presentation/screens/order_create_flow/web_view/tinkoff_acquiring_webview/widget/warning.dart';
import 'package:everylounge/presentation/widgets/loaders/circular.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TinkoffAcquiringWebView extends StatefulWidget {
  static const String path = "tinkoffWebViewAcquiring";
  final Uri paymentUrl;
  final Function onPaymentSuccess;
  final Function onPaymentFailure;
  final bool showTinkoffWarning;
  final BankCardType? activeCardType;

  const TinkoffAcquiringWebView({
    super.key,
    required this.paymentUrl,
    required this.onPaymentSuccess,
    required this.onPaymentFailure,
    required this.showTinkoffWarning,
    this.activeCardType,
  });

  @override
  State<TinkoffAcquiringWebView> createState() => _TinkoffAcquiringWebViewState();
}

class _TinkoffAcquiringWebViewState extends State<TinkoffAcquiringWebView> {
  late final WebViewController _webViewController;
  Timer? successResultWatcher;
  StreamSubscription? appLinkSubscription;
  dynamic isFail;
  dynamic isSuccess;
  bool _isLoading = true;
  bool isShowInfo = true;
  bool isShowAppBar = true;
  final MetricsUseCase _metricsUseCase = getIt<MetricsUseCase>();

  @override
  void initState() {
    initWebViewController();
    Future.delayed(
      const Duration(milliseconds: 200),
      () => _webViewController.loadRequest(widget.paymentUrl),
    );
    initResultWatcher();
    super.initState();
  }

  void initResultWatcher() {
    successResultWatcher = Timer.periodic(
      ms(500),
      (timer) async {
        if (isFail == true || isFail == "1") timer.cancel();
        if (isSuccess == true || isSuccess == "1") timer.cancel();
        try {
          isFail = await _webViewController.runJavaScriptReturningResult(
            "['Произошла ошибка оплаты', 'Unable to pay'].some(substring=>document.getElementsByTagName('html')[0].innerHTML.includes(substring))",
          );
          dynamic tryAgain = await _webViewController.runJavaScriptReturningResult(
              "['Попробуйте снова', 'Try again'].some(substring=>document.getElementsByTagName('html')[0].innerHTML.includes(substring))");
          if (tryAgain == true || tryAgain == "1") isFail = false;
          isSuccess = await _webViewController.runJavaScriptReturningResult(
            "['Оплата прошла успешно', 'Paid'].some(substring=>document.getElementsByTagName('html')[0].innerHTML.includes(substring))",
          );
        } catch (e, s) {
          Log.exception(e, s, "successResultWatcher");
        }
      },
    );
  }

  void initWebViewController() {
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) async {
            if (request.url.contains(successUrl) || request.url.contains(failUrl)) {
              await _onPop();
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
          onPageStarted: (String url) async {
            setState(() => _isLoading = true);
            hideInfo(url);
            hideAppBar(url);
            if (url.contains("https://tinkoffbank.onelink.me")) {
              final launchUri = Uri.parse(url).queryParameters["af_dp"] as String;
              await launchUrlString(launchUri);
              _webViewController.loadRequest(widget.paymentUrl);
              appLinkSubscription = AppLinks().stringLinkStream.listen((event) async {
                Log.message(event, sender: "WebView");
                if (event.contains(successUrl) || event.contains(tinkoffSuccessUrl)) {
                  successResultWatcher?.cancel();
                  isSuccess = true;
                  _onPop();
                }
                if (event.contains(failUrl) || event.contains(tinkoffFailUrl)) {
                  successResultWatcher?.cancel();
                  isFail = true;
                  _onPop();
                }
                if (event.contains("securepayments.tinkoff.ru")) {
                  _webViewController.reload();
                }
              });
            }
          },
          onPageFinished: (String url) {
            _setLoading(false);
          },
          onWebResourceError: (WebResourceError error) async {
            showAppBar();
          },
        ),
      );
  }

  void hideInfo(String url) {
    if (url != widget.paymentUrl.toString()) {
      setState(() {
        isShowInfo = false;
      });
    }
  }

  void hideAppBar(String url) {
    if (url.contains(apiTinkoffSuccessUrl) || url.contains(apiTinkoffFailUrl)) {
      setState(() {
        isShowAppBar = false;
      });
    } else {
      showAppBar();
    }
  }

  void showAppBar() {
    if (isShowAppBar == false) {
      setState(() {
        isShowAppBar = true;
      });
    }
  }

  @override
  void dispose() {
    successResultWatcher?.cancel();
    appLinkSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await _onPop();
        return false;
      },
      child: Scaffold(
        backgroundColor: context.colors.appBarBackArrowBorder,
        appBar: isShowAppBar
            ? PreferredSize(
                preferredSize: const Size.fromHeight(60.0), // here the desired height
                child: CustomAppBarWebView(activeCard: widget.activeCardType))
            : null,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    WebViewWidget(
                      controller: _webViewController,
                    ),
                    Visibility(
                      visible: _isLoading,
                      child: const Center(
                        child: AppCircularProgressIndicator.large(),
                      ),
                    ),
                  ],
                ),
              ),
              if (widget.showTinkoffWarning && isShowInfo) AcquiringWarningWidget(activeCard: widget.activeCardType),
            ],
          ),
        ),
      ),
    );
  }

  _setLoading(bool loading) {
    if (mounted) {
      setState(() {
        _isLoading = loading;
      });
    }
  }

  _onPop() async {
    if (isFail == true || isFail == '1') {
      widget.onPaymentFailure();
    } else if (isSuccess == true || isSuccess == '1') {
      _metricsUseCase.sendEvent(event: eventName[paySuccess]!, type: MetricsEventType.message);
      widget.onPaymentSuccess();
    } else {
      widget.onPaymentFailure();
    }
    context.pop();
  }
}
