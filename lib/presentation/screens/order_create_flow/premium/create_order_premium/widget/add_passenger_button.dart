import 'package:everylounge/presentation/common/assets/assets.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/widgets/tappable/regular_negative.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AddPassengerButton extends StatelessWidget {
  final Function() onPressed;

  const AddPassengerButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RegularButtonNegative(
      backgroundColor: Colors.transparent,
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            AppImages.plus,
            color: context.colors.textNormalLink,
          ),
          const SizedBox(width: 10),
          Text(
            "Добавить пассажира",
            style: context.textStyles.textLargeBold(color: context.colors.textNormalLink),
          ),
        ],
      ),
    );
  }
}
