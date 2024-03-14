import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class NotPublicOffer extends StatelessWidget {
  final TextStyle? firstStyle;
  final TextStyle? secondStyle;

  const NotPublicOffer({
    this.firstStyle,
    this.secondStyle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        child: Container(
          padding: const EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
          decoration: BoxDecoration(
            color: context.colors.textDefault.withOpacity(0.4),
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: firstStyle ?? context.textStyles.textSmallRegular(color: Colors.white),
              children: [
                const TextSpan(text: "*Не является публичной офертой, подробные условия\nна "),
                TextSpan(
                  text: "сайте банка.",
                  style: secondStyle ??
                      context.textStyles.textSmallRegular(color: Colors.white).copyWith(decoration: TextDecoration.underline),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      launchUrlString(
                          "https://alfabank.servicecdn.ru/site-upload/d0/2a/2366/rules_povyshenie_klassa_aclub_30062023.pdf");
                    },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
