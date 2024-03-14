import 'package:everylounge/domain/entities/bank/card.dart';
import 'package:everylounge/presentation/common/assets/assets.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/widgets/shared/modal_top_element.dart';
import 'package:everylounge/presentation/widgets/tappable/regular.dart';
import 'package:everylounge/presentation/widgets/tappable/regular_negative.dart';
import 'package:flutter/material.dart';

class TryRemoveCardModal extends StatelessWidget {
  static const path = "TryRemoveCardModal";
  final BankCard card;
  final Function callback;

  const TryRemoveCardModal({
    Key? key,
    required this.card,
    required this.callback,
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
                child: Image.asset(AppImages.cardRed),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 28, right: 28, top: 24),
                child: Text(
                  card.fake == true
                      ? "Вы действительно хотите отключить программу привилегий?"
                      : "Вы действительно хотите отвязать карту *${card.maskedNumber.split("*").last}?",
                  textAlign: TextAlign.center,
                  style: context.textStyles.header700(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 24, right: 24, top: 24),
                child: RegularButton(
                  label: Text(card.fake == true ? 'Отключить' : "Отвязать карту"),
                  onPressed: () => {
                    Navigator.pop(context),
                    callback.call(),
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 24),
                child: RegularButtonNegative(
                  minWidth: MediaQuery.of(context).size.width,
                  onPressed: () => {
                    Navigator.pop(context),
                  },
                  child: const Text("Отмена"),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
