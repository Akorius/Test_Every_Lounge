import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:timer_count_down/timer_count_down.dart';

class CodeResendWidget extends StatelessWidget {
  final Function onResentPressed;
  final bool showTimer;
  final Function onTimerEnd;
  final int secondsLeft;

  const CodeResendWidget({
    Key? key,
    required this.onResentPressed,
    this.showTimer = false,
    required this.secondsLeft,
    required this.onTimerEnd,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return showTimer
        ? Countdown(
            seconds: secondsLeft,
            build: (BuildContext context, double seconds) {
              return Text(
                "Отправить код повторно через ${seconds.toInt()} сек",
                style: context.textStyles.textLargeRegular(color: context.colors.textFieldHint),
              );
            },
            onFinished: onTimerEnd,
          )
        : Text.rich(
            style: context.textStyles.textLargeRegular(),
            textAlign: TextAlign.center,
            TextSpan(
              text: "Не получили код?",
              children: [
                const TextSpan(text: ' '),
                TextSpan(
                  recognizer: TapGestureRecognizer()..onTap = () => onResentPressed(),
                  text: "Выслать ещё раз",
                  style: context.textStyles.textLargeRegularLink(),
                )
              ],
            ),
          );
  }
}
