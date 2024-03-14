import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BottomMenuItem extends StatelessWidget {
  final bool selected;
  final String text;
  final String icon;
  final Function() onPressed;

  const BottomMenuItem({
    Key? key,
    required this.selected,
    required this.text,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onPressed(),
      child: Column(
        children: [
          Container(
            width: 24,
            height: 2,
            color: selected ? context.colors.cardSelectedBorder : Colors.transparent,
          ),
          const SizedBox(height: 5),
          SvgPicture.asset(
            icon,
            height: 24,
            color: selected ? context.colors.iconSelected : context.colors.iconUnselected,
          ),
          const SizedBox(height: 9),
          Text(
            text,
            style: context.textStyles.bottomMenuText(
              color: selected ? context.colors.iconSelected : context.colors.iconUnselected,
            ),
          ),
        ],
      ),
    );
  }
}
