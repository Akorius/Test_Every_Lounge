import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:flutter/material.dart';

class UnorderedListItemCustom extends StatelessWidget {
  const UnorderedListItemCustom(this.textBold, this.text, {super.key});

  final String textBold;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(" • ", style: context.textStyles.textNormalRegular()),
        Expanded(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(text: textBold, style: context.textStyles.textNormalRegular(ruble: true)),
                TextSpan(
                    text: text,
                    style: context.textStyles.textSmallBold(
                      color: context.colors.textDefault,
                    )),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
