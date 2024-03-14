import 'package:everylounge/presentation/common/assets/assets.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/widgets/tappable/regular.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TinkoffPayButton extends StatelessWidget {
  const TinkoffPayButton({
    Key? key,
    required this.onPressed,
    this.canPress = true,
    this.loading = false,
  }) : super(key: key);

  final Function() onPressed;
  final bool canPress;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return RegularButton(
      label: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Оплатить с Tinkoff",
            style: context.textStyles.textTinkoffPayButton(),
          ),
          const SizedBox(width: 8),
          SvgPicture.asset(AppImages.tinkoffPayLogo, height: 16),
        ],
      ),
      onPressed: onPressed,
      color: context.colors.buttonTinkoffBackground,
      colorPressed: context.colors.buttonTinkoffBackground,
      canPress: canPress,
      isLoading: loading,
    );
  }
}
