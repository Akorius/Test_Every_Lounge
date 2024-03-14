import 'package:everylounge/presentation/common/assets/assets.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/widgets/snackbar/snackbar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void showNoteForEmployees(BuildContext context) {
  showModalBottomSheet(
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
    ),
    backgroundColor: context.colors.bottomSheetBackgroundColor,
    context: context,
    builder: (BuildContext buildContext) {
      return Wrap(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              Container(
                height: 5,
                width: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: context.colors.cardSelectedBorder,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 200,
                width: 200,
                child: Image.asset(AppImages.noteLogo),
              ),
              const SizedBox(
                height: 40,
              ),
              Text(
                'Note for Business Lounge’s\nemployees:',
                style: context.textStyles.h2(color: context.colors.textDefault),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 28, right: 28, top: 16),
                child: Text.rich(
                  style: context.textStyles.textLargeRegular(),
                  TextSpan(
                    children: [
                      TextSpan(
                          text: '• Your business lounge has an agreement with LoungeMe (TAV Holdings company)\n\n',
                          style: context.textStyles.textNormalRegular(color: context.colors.textDefault)),
                      TextSpan(
                          text: '• Do not scan the QR code with Lounge Pass devices!\n\n',
                          style: context.textStyles.textNormalRegular(color: context.colors.textDefault)),
                      TextSpan(
                          text:
                              '• To Account for the passenger you must log in to the LoungeMe portal using the following link: ',
                          style: context.textStyles.textNormalRegular(color: context.colors.textDefault)),
                      TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => _onLinkPressed(context, uri: 'desk.lounge.me', scheme: 'https'),
                        text: "desk.lounge.me\n\n",
                        style: context.textStyles.textLargeRegularLink(),
                      ),
                      TextSpan(
                          text:
                              '• Your unique user credentials for LoungeMe portal you might know, otherwise you can request it by e-mail: ',
                          style: context.textStyles.textNormalRegular(color: context.colors.textDefault)),
                      TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => _onLinkPressed(context, uri: 'info@lounge.me', scheme: 'mailto'),
                        text: "info@lounge.me",
                        style: context.textStyles.textLargeRegularLink(),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 47,
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(
                    color: context.colors.buttonEnabledText,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: context.colors.buttonDisabled),
                  ),
                  child: Center(
                    child: Text(
                      'Ok',
                      style: context.textStyles.negativeButtonText(color: context.colors.buttonNegativeText),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              )
            ],
          ),
        ],
      );
    },
  );
}

_onLinkPressed(BuildContext context, {required String scheme, required String uri}) async {
  if (!await launchUrl(Uri(scheme: scheme, path: uri), mode: LaunchMode.externalApplication)) {
    context.showSnackbar("Невозможно открыть ссылку: $uri");
  }
}
