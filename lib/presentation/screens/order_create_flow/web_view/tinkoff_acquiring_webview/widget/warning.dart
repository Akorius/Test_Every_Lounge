import 'package:everylounge/domain/entities/bank/card_type.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:flutter/material.dart';

class AcquiringWarningWidget extends StatelessWidget {
  late final String title;
  late final String subtitle;
  final String defaultTitle = "Выбранный Вами способ оплаты не предполагает получение компенсации от банка";
  final String defaultSubtitle = "Для получения компенсации строго следуйте инструкциям вашего банка";
  final BankCardType? activeCard;

  AcquiringWarningWidget({Key? key, required this.activeCard}) : super(key: key) {
    _checkCardTypeText();
  }

  _checkCardTypeText() {
    switch (activeCard) {
      case BankCardType.gazpromDefault:
      case BankCardType.gazpromPremium:
      case BankCardType.gazpromPrivate:
        title =
            "Обращаем ваше внимание, что\nустановленный вами «Активный способ оплаты» предполагает получение компенсации Газпромбанка";
        subtitle = "Для получения компенсации вашего банка,\nзайдите в профиль и измените «Активный\nспособ оплаты».";
      case BankCardType.alfaClub:
      case BankCardType.alfaPrem:
        title =
            "Обращаем ваше внимание, что\nустановленный вами «Активный способ оплаты» предполагает получение компенсации Альфа Банка";
        subtitle = "Для получения компенсации вашего банка,\nзайдите в профиль и измените «Активный\nспособ оплаты».";
      case BankCardType.tinkoffDefault:
      case BankCardType.tinkoffPremium:
      case BankCardType.tinkoffPrivate:
      case BankCardType.tinkoffPro:
        title =
            "Обращаем ваше внимание, что\nустановленный вами «Активный способ оплаты» предполагает получение компенсации Тинькофф";
        subtitle = "Для получения компенсации вашего банка,\nзайдите в профиль и измените «Активный\nспособ оплаты».";
      case BankCardType.moscowCredit:
        title =
            "Обращаем ваше внимание, что\nустановленный вами «Активный способ оплаты» предполагает получение компенсации Банка МКБ";
        subtitle = "Для получения компенсации вашего банка,\nзайдите в профиль и измените «Активный\nспособ оплаты».";
      case BankCardType.otkrytie:
        title =
            "Обращаем ваше внимание, что\nустановленный вами «Активный способ оплаты» предполагает получение компенсации Банка Открытие";
        subtitle = "Для получения компенсации вашего банка,\nзайдите в профиль и измените «Активный\nспособ оплаты».";
      case BankCardType.raiffeisen:
      case BankCardType.tochka:
      case BankCardType.beelineKZ:
      case BankCardType.other:
      default:
        title = defaultTitle;
        subtitle = defaultSubtitle;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            offset: const Offset(0, 7),
            blurRadius: 6,
          ),
        ],
      ),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: context.textStyles.textTinkoffPayButton()),
          const SizedBox(height: 10),
          Text(subtitle, style: context.textStyles.textNormalRegular())
        ],
      ),
    );
  }
}
