import 'package:everylounge/presentation/common/assets/assets.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ShareButton extends StatelessWidget {
  const ShareButton({
    Key? key,
    this.callback,
  }) : super(key: key);

  final Function? callback;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => callback?.call(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(AppImages.impart),
          const SizedBox(width: 12),
          Text(
            "Поделиться",
            textAlign: TextAlign.center,
            style: context.textStyles.textOrderDetailsLarge(color: context.colors.textOrderDetailsImpart),
          )
        ],
      ),
    );
  }
}
