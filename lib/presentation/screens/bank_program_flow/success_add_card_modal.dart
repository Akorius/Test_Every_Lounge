import 'package:everylounge/domain/entities/bank/card_type.dart';
import 'package:everylounge/presentation/common/assets/assets.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/widgets/shared/modal_top_element.dart';
import 'package:everylounge/presentation/widgets/tappable/regular.dart';
import 'package:flutter/material.dart';

class SuccessAddCardModal extends StatelessWidget {
  static const path = "successAddCardModal";
  final BankCardType? cardType;

  const SuccessAddCardModal({
    Key? key,
    required this.cardType,
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
                child: Image.asset(_getMainLogo()),
              ),
              Padding(
                  padding: const EdgeInsets.only(left: 28, right: 28, top: 24),
                  child: Column(
                    children: [
                      Text(
                        _getTitleText(),
                        textAlign: TextAlign.center,
                        style: context.textStyles.header700(),
                      ),
                      const SizedBox(height: 16),
                      Text(_getMainText(), textAlign: TextAlign.center, style: context.textStyles.textLargeRegular())
                    ],
                  )),
              Padding(
                padding: const EdgeInsets.only(left: 24, right: 24, top: 34, bottom: 24),
                child: RegularButton(
                  color: _getColorButton(context),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  label: const Text("Продолжить"),
                  withoutElevation: true,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  String _getTitleText() {
    if (cardType == BankCardType.otkrytie) {
      return "Карта банка «${getBankName(cardType)}» успешно добавлена";
    }
    if (cardType == BankCardType.moscowCredit) {
      return "Карта МКБ успешно привязан";
    }
    if (cardType == BankCardType.alfaClub) {
      return "А-Клуб подключен";
    }
    if (cardType == BankCardType.alfaPrem) {
      return "Способ оплаты Alfa Only\nуспешно подключен";
    }
    if (isTinkoffTypeCard(cardType)) {
      return "Способ оплаты Tinkoff успешно подключен";
    }
    if (cardType == BankCardType.beelineKZ) {
      return "Beeline Business Kazakhstan успешно подключен";
    }
    if (cardType == BankCardType.tochka) {
      return "Бонусный счет Банка Точка успешно подключен";
    }
    if (isGazPromPremiumTypeCard(cardType)) {
      return "Карта ${getBankName(cardType)} успешно добавлена";
    }
    return "Банковская карта успешно добавлена";
  }

  String _getMainLogo() {
    if (isGazPromPremiumTypeCard(cardType)) {
      return AppImages.cardBigCircleGazProm;
    }
    if (cardType == BankCardType.otkrytie) {
      return AppImages.cardBigCircleOtkrytie;
    }
    if (cardType == BankCardType.moscowCredit) {
      return AppImages.cardBigCircleMkb;
    }
    if (cardType == BankCardType.alfaClub) {
      return AppImages.cardBigCircleAlfa;
    }
    if (cardType == BankCardType.alfaPrem) {
      return AppImages.cardBigCircleAlfaPremBig;
    }
    if (isTinkoffTypeCard(cardType)) {
      return AppImages.cardBigCircleTinkoff;
    }
    if (cardType == BankCardType.beelineKZ) {
      return AppImages.cardBigCircleBeelineKZ;
    }
    if (cardType == BankCardType.tochka) {
      return AppImages.cardBigCircleTochka;
    }
    return AppImages.cardBigCircleOther;
  }

  String _getMainText() {
    if (isGazPromPremiumTypeCard(cardType)) {
      return "Газпромбанк компенсирует стоимость прохода в соответствии с условиями обслуживания премиальных карт";
    }
    if (cardType == BankCardType.otkrytie) {
      return "Вы сможете возместить стоимость прохода в соответствии с условиями вашего статуса";
    }
    if (cardType == BankCardType.moscowCredit) {
      return "МКБ компенсирует стоимость прохода в соответствии с условиями обслуживания премиальных карт";
    }
    if (cardType == BankCardType.alfaClub) {
      return "Клиенты А-Клуба могут бесплатно оформлять проходы в бизнес-залы. Доступное количество проходов можно посмотреть в приложении банка или Альфа-Онлайн";
    }
    if (cardType == BankCardType.alfaPrem) {
      return "Клиентам Alfa Only доступна компенсация за визиты в бизнес-залы. Условия компенсации можно посмотреть в приложении банка или Альфа-Онлайн";
    }
    if (isTinkoffTypeCard(cardType)) {
      return "Для получения дополнительных преимуществ и специальных цен на проходы в бизнес-залы ";
    }
    if (cardType == BankCardType.beelineKZ) {
      return "Клиентам Beeline Business Kazakhstan доступно бесплатное оформление проходов, баланс привилегий отображается в личном кабинете";
    }
    if (cardType == BankCardType.tochka) {
      return "Клиентам Банка Точка доступно бесплатное оформление проходов, баланс привилегий отображается в личном кабинете";
    }
    return "О доступных банковских привилегиях уточняйте в поддержке вашего банка";
  }

  Color? _getColorButton(BuildContext context) {
    if (isGazPromPremiumTypeCard(cardType)) {
      return context.colors.buttonEnabledGazProm;
    }
    if (cardType == BankCardType.otkrytie) {
      return context.colors.buttonEnabledOtkrytie;
    }
    if (cardType == BankCardType.other) {
      return context.colors.buttonEnabled;
    }
    return context.colors.buttonBlack;
  }
}
