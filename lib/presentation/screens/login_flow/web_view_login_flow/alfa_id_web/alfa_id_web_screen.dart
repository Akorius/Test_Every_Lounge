import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/screens/login_flow/web_view_login_flow/alfa_id_web/alfa_id_web_view.dart';
import 'package:everylounge/presentation/screens/login_flow/web_view_login_flow/alfa_id_web/result.dart';
import 'package:everylounge/presentation/widgets/appbars/back_arrow.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AlfaIdWebScreen extends StatelessWidget {
  static const path = "alfaIdWeb";
  final String link;

  const AlfaIdWebScreen({Key? key, required this.link}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: context.colors.textLight,
        leading: const Padding(
          padding: EdgeInsets.only(left: 16),
          child: BackArrowButton(),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            AlfaIdWebView(
              onWebViewFinished: (result) {
                context.pop<AlfaIdResult>(result);
              },
              link: link,
              clearCookies: true,
              showProgressIndicator: true,
            ),
          ],
        ),
      ),
    );
  }
}
