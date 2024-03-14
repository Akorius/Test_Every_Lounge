import 'package:everylounge/domain/entities/lounge/airport_destination_type.dart';
import 'package:everylounge/presentation/common/assets/assets.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FlyDirection extends StatelessWidget {
  final InnerDestinationType type;

  const FlyDirection({
    Key? key,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String text;
    String icon;

    switch (type) {
      case InnerDestinationType.departure:
        text = "Вылет";
        icon = AppImages.departure;
        break;
      case InnerDestinationType.arrival:
        text = "Прилёт";
        icon = AppImages.arrival;
        break;
      case InnerDestinationType.transit:
        text = "Транзит";
        icon = AppImages.transit;
        break;
      default:
        text = "";
        icon = AppImages.transit;
        break;
    }
    return Padding(
      padding: const EdgeInsets.only(left: 8, top: 4, right: 8, bottom: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            icon,
            color: context.colors.textBlue,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: context.textStyles.textNormalRegular(color: context.colors.textBlue),
          ),
        ],
      ),
    );
  }
}
