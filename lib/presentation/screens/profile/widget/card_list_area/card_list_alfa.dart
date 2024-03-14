import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:flutter/material.dart';

class CardListAlfa extends StatelessWidget {
  const CardListAlfa({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 28),
      decoration: BoxDecoration(color: context.colors.backgroundColor),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Кэшбэк",
            style: context.textStyles.h2(),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            "Чтобы получить кэшбэк за повышение класса обслуживания, оплатите услугу"
            "\nкартой Альфа-Банка."
            "\n\nДанные карты вам нужно будет ввести на последнем этапе бронирования.",
            style: context.textStyles.textLargeRegular(),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
