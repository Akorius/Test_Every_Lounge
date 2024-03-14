import 'package:everylounge/domain/entities/bank/card.dart';
import 'package:everylounge/domain/entities/bank/card_type.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/widgets/counter/counter.dart';
import 'package:flutter/material.dart';

class PassengersCounter extends StatelessWidget {
  final Function() onPressedPlus;
  final Function() onPressedMinus;
  final int count;
  final bool isRichedMaxGuests;
  final bool isLoading;
  final BankCard? activeBankCard;
  final bool? isPassageOver;
  final bool disableAdditionPassengers;
  final bool alfaLimitEnable;
  final int maxPassengers;

  const PassengersCounter({
    Key? key,
    required this.onPressedPlus,
    required this.onPressedMinus,
    required this.isLoading,
    required this.count,
    required this.isRichedMaxGuests,
    this.activeBankCard,
    this.isPassageOver,
    this.disableAdditionPassengers = false,
    this.alfaLimitEnable = false,
    required this.maxPassengers,
  }) : super(key: key);

  static const addGuest = "Добавить гостей";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MediaQuery.of(context).size.width < 300
              ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                    addGuest,
                    style: context.textStyles.textLargeBold(color: context.colors.textDefault),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Counter(
                      count: count,
                      onPressedMinus: onPressedMinus,
                      onPressedPlus: disableAdditionPassengers ? null : onPressedPlus,
                      opacityPlus: disableAdditionPassengers ? 0.2 : 1,
                    ),
                  )
                ])
              : SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    children: [
                      Text(
                        addGuest,
                        style: context.textStyles.textLargeBold(color: context.colors.textDefault),
                      ),
                      Counter(
                          count: count,
                          onPressedMinus: onPressedMinus,
                          onPressedPlus: disableAdditionPassengers ? null : onPressedPlus,
                          opacityPlus: disableAdditionPassengers ? 0.2 : 1),
                    ],
                  ),
                ),
          const SizedBox(
            height: 5,
          ),
          if (alfaLimitEnable && isPassageOver != true) ...[
            Text(
              "Лимит проходов в бизнес-зал исчерпан",
              style: context.textStyles.textSmallRegular(color: context.colors.textError),
            ),
          ] else if (count > 2 && activeBankCard?.type == BankCardType.alfaPrem) ...[
            Text(
              "Максимально могут быть компенсированы 4 прохода (10000 рублей)",
              style: context.textStyles.textSmallRegular(color: context.colors.textNormalGrey),
            ),
          ] else ...[
            if (disableAdditionPassengers && count >= maxPassengers)
              Text(
                "В одном заказе максимум $maxPassengers гостей",
                style: context.textStyles.textSmallRegular(color: context.colors.textNormalGrey),
              ),
          ],
          if (isRichedMaxGuests && !isLoading)
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(
                "Выбрано максимальное количество гостей",
                style: context.textStyles.textSmallRegular(color: context.colors.textError),
              ),
            ),
        ],
      ),
    );
  }
}
