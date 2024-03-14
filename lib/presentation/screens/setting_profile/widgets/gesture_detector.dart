import 'package:everylounge/domain/entities/common/platform.dart';
import 'package:everylounge/presentation/screens/setting_profile/cubit.dart';
import 'package:everylounge/presentation/screens/setting_profile/widgets/account/password_dialog.dart';
import 'package:everylounge/presentation/widgets/snackbar/snackbar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class GestureDetectorButton extends StatelessWidget {
  final int index;
  final Widget child;

  const GestureDetectorButton({Key? key, required this.index, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController password = TextEditingController();

    return RawGestureDetector(
      gestures: {
        if (index == 0)
          TapGestureRecognizer: GestureRecognizerFactoryWithHandlers<TapGestureRecognizer>(() => TapGestureRecognizer(),
              (TapGestureRecognizer instance) {
            instance.onTap = () => _onLinkPressed(context);
          }),
        if (index == 1)
          TapGestureRecognizer: GestureRecognizerFactoryWithHandlers<TapGestureRecognizer>(() => TapGestureRecognizer(),
              (TapGestureRecognizer instance) {
            instance.onTap = () => showAlertDialog(context, isRating: true);
          }),
        if (index == 2 || (PlatformWrap.isWeb && index == 0))
          SerialTapGestureRecognizer: GestureRecognizerFactoryWithHandlers<SerialTapGestureRecognizer>(
              () => SerialTapGestureRecognizer(), (SerialTapGestureRecognizer instance) {
            instance.onSerialTapDown = (SerialTapDownDetails details) {
              if (details.count == 6) {
                showAlertDialog(context, isRating: false, controller: password, onSubmitted: (onSubmitted) async {
                  bool accessGranted = await context.read<ProfileSettingsCubit>().toggleDeveloperMode(password.text);
                  if (accessGranted) {
                    Navigator.pop(context);
                  }
                }, onChanged: (String newEmail) {
                  password.text = newEmail;
                  password.selection = TextSelection.fromPosition(TextPosition(offset: password.text.length));
                });
              }
            };
          })
      },
      child: child,
    );
  }

  _onLinkPressed(BuildContext context) async {
    if (!await launchUrl(Uri(path: 'info@lounge.me', scheme: 'mailto'), mode: LaunchMode.externalApplication)) {
      context.showSnackbar("info@lounge.me Недоступно");
    }
  }
}
