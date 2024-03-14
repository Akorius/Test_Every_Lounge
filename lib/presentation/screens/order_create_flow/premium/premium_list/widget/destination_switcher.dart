import 'package:everylounge/presentation/common/assets/assets.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:slide_switcher/slide_switcher.dart';

class DestinationSwitcher extends StatelessWidget {
  final Function(int index) onSelect;

  const DestinationSwitcher({
    Key? key,
    required this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      width: MediaQuery.of(context).size.width,
      child: SlideSwitcher(
        containerBorderRadius: 16,
        indents: 2,
        containerHeight: 44,
        containerWight: MediaQuery.of(context).size.width - 32,
        onSelect: onSelect,
        slidersColors: const [Colors.white],
        containerColor: const Color(0xFFEDF3FC),
        children: const [
          DestinationSwitcherItem(icon: AppImages.departure, text: 'Вылет'),
          DestinationSwitcherItem(icon: AppImages.arrival, text: 'Прилёт'),
          DestinationSwitcherItem(icon: AppImages.transit, text: 'Транзит'),
        ],
      ),
    );
  }
}

class DestinationSwitcherItem extends StatelessWidget {
  final String text;
  final String icon;

  const DestinationSwitcherItem({
    Key? key,
    required this.text,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 8, top: 8, right: 8, bottom: 8),
      child: Row(
        children: [
          SvgPicture.asset(icon),
          const SizedBox(width: 9.25),
          Text(
            text,
            style: context.textStyles.textNormalRegular(color: context.colors.textBlue),
          ),
        ],
      ),
    );
  }
}
