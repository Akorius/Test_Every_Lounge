import 'package:everylounge/domain/entities/bank/card.dart';
import 'package:everylounge/presentation/common/assets/assets.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/widgets/shared/modal_top_element.dart';
import 'package:everylounge/presentation/widgets/tappable/regular_negative.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SuccessRemoveCardModal extends StatelessWidget {
  static const path = "SuccessRemoveCardModal";
  final BankCard card;

  const SuccessRemoveCardModal({
    Key? key,
    required this.card,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.bottomSheetBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Wrap(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const ModalTopElement(),
              const SizedBox(height: 24),
              SizedBox(
                height: 200,
                width: 200,
                child: Image.asset(AppImages.success),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 28, right: 28, top: 24),
                child: Text(
                  card.fake == true
                      ? 'Программа привилегий была отключена'
                      : "Карта ${card.maskedNumber.substring(card.maskedNumber.length - 8, card.maskedNumber.length)} была успешно отвязана от вашего профиля",
                  textAlign: TextAlign.center,
                  style: context.textStyles.header700(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 24, right: 24, top: 94, bottom: 24),
                child: RegularButtonNegative(
                  minWidth: MediaQuery.of(context).size.width,
                  onPressed: () {
                    context.pop();
                  },
                  child: const Text("Понятно"),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
