import 'package:everylounge/domain/entities/bank/card.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/screens/profile/state.dart';
import 'package:flutter/material.dart';

import 'card_widget.dart';

class CardsList extends StatelessWidget {
  final ProfileState state;

  const CardsList({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.colors.backgroundColor,
      ),
      child: Column(
        children: [
          const SizedBox(height: 10),
          if (state.activeBankProgramsList!.isNotEmpty) ActiveCardArea(activeBankCardList: state.activeBankProgramsList!),
          const SizedBox(height: 32 - 8),
          if (state.inactiveBankProgramsList!.isNotEmpty) OtherCardsArea(inActiveBankCardList: state.inactiveBankProgramsList!),
        ],
      ),
    );
  }
}

class ActiveCardArea extends StatelessWidget {
  final List<BankCard> activeBankCardList;

  const ActiveCardArea({
    super.key,
    required this.activeBankCardList,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Активный способ оплаты",
          style: context.textStyles.textLargeBold(color: context.colors.textOrderDetailsTitle),
        ),
        const SizedBox(height: 16),
        ...activeBankCardList
            .map((e) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: CardWidget(bankCard: e),
                ))
            .toList(),
      ],
    );
  }
}

class OtherCardsArea extends StatelessWidget {
  final List<BankCard> inActiveBankCardList;

  const OtherCardsArea({
    super.key,
    required this.inActiveBankCardList,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Доступные способы оплаты",
          style: context.textStyles.textLargeBold(color: context.colors.textNormalGrey),
        ),
        const SizedBox(height: 16),
        ...inActiveBankCardList
            .map((e) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: CardWidget(bankCard: e),
                ))
            .toList(),
      ],
    );
  }
}
