import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stream_listener/flutter_stream_listener.dart';

class CommonScaffold extends StatelessWidget {
  final Stream<String> messageStream;
  final Function(String) onMessage;
  final PreferredSizeWidget? appBar;
  final Widget child;
  final bool resizeToAvoidBottomInset;
  final bool extendBodyBehindAppBar;
  final Color? backgroundColor;
  final Widget? bottomNavigationBar;

  const CommonScaffold({
    Key? key,
    required this.messageStream,
    required this.onMessage,
    this.appBar,
    required this.child,
    this.resizeToAvoidBottomInset = true,
    this.extendBodyBehindAppBar = false,
    this.backgroundColor,
    this.bottomNavigationBar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        extendBodyBehindAppBar: extendBodyBehindAppBar,
        backgroundColor: backgroundColor ?? context.colors.backgroundColor,
        appBar: appBar,
        body: StreamListener(
          stream: messageStream,
          onData: onMessage,
          child: child,
        ),
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        bottomNavigationBar: bottomNavigationBar,
      ),
    );
  }
}
