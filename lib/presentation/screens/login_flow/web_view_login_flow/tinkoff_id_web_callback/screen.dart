import 'package:everylounge/core/di/get_it.dart';
import 'package:everylounge/domain/usecases/login/sign_in_with_tinkoff_web_web.dart';
import 'package:everylounge/presentation/common/router/router.dart';
import 'package:everylounge/presentation/common/router/routes.dart';
import 'package:everylounge/presentation/widgets/loaders/circular.dart';
import 'package:everylounge/presentation/widgets/snackbar/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TinkoffIdWebCallbackScreen extends StatefulWidget {
  static const path = "tinkoff-id-web-callback";

  final String? code;

  const TinkoffIdWebCallbackScreen({Key? key, this.code}) : super(key: key);

  @override
  State<TinkoffIdWebCallbackScreen> createState() => _TinkoffIdWebCallbackScreenState();
}

class _TinkoffIdWebCallbackScreenState extends State<TinkoffIdWebCallbackScreen> {
  final SignInWithTinkoffWebToWebUseCase _signInWithTinkoffWebToWebUseCase = getIt();

  @override
  void initState() {
    webWasInitialized = true;
    _processSuccessUrl(widget.code);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const AppCircularProgressIndicator();
  }

  _processSuccessUrl(String? url) async {
    final result = await _signInWithTinkoffWebToWebUseCase.processCallbackUrl(url);
    if (result.isSuccess) {
      context.push(AppRoutes.homeBottomNavigation);
    } else {
      context.showSnackbar(result.message);
      context.push(AppRoutes.loginBottomNavigation);
    }
  }
}
