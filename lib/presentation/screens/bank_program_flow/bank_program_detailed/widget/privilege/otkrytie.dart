import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:flutter/material.dart';

class OtkrytiePrivilege extends StatelessWidget {
  const OtkrytiePrivilege({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Специальные условия для вас",
          style: context.textStyles.textSmallBold(color: context.colors.textNormalGrey),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Text(
            "При оплате картой Opencard банка «Открытие» вы сможете возместить стоимость покупки в рамках привилегии AirBack",
            style: context.textStyles.textLargeBold(),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
