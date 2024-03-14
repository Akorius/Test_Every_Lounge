import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:flutter/material.dart';

class OrDivider extends StatelessWidget {
  const OrDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
            child: Divider(
          height: 1,
          thickness: 1,
          color: context.colors.dividerGray,
        )),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "или войдите с помощью",
              style: context.textStyles.textNormalRegularGrey(),
            )),
        Expanded(
            child: Divider(
          height: 1,
          thickness: 1,
          color: context.colors.dividerGray,
        )),
      ],
    );
  }
}
