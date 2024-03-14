import 'package:everylounge/domain/entities/bank/card.dart';
import 'package:everylounge/domain/entities/bank/card_type.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:flutter/material.dart';

class InfoPaymentWidget extends StatelessWidget {
  const InfoPaymentWidget(this.activeBankCard, this.isFirstAttention, this.onTapClose, {super.key});

  final BankCard? activeBankCard;
  final Function? onTapClose;
  final bool? isFirstAttention;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(15),
        ),
        color: context.colors.buttonDisabled,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: Text(
                getLimitPassesText(),
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            GestureDetector(
              onTap: () => onTapClose?.call(),
              child: Icon(
                Icons.close,
                color: context.colors.textDefault,
              ),
            )
          ],
        ),
      ),
    );
  }

  String getLimitPassesText() {
    switch (activeBankCard?.type) {
      case BankCardType.alfaClub:
        if (activeBankCard?.passesCount == 0) {
          return passesAreOverText;
        } else {
          return limitsAreOverAlfaText;
        }
      case BankCardType.tinkoffPrivate:
        return isFirstAttention == true ? payPassTinkoffText : limitsAreOverTinkoffText;
      default:
        return passesAreOverText;
    }
  }

  static String passesAreOverText = 'Проходы закончились, оплатите онлайн или выберите другой способ оплаты';
  static String limitsAreOverTinkoffText =
      'В этом заказе вы выбрали максимум проходов. Чтобы оформить больше проходов, создайте новый заказ и оплатите его с Tinkoff Pay. Для компенсации обратитесь в чат поддержки Тинькофф';
  static String payPassTinkoffText = 'Оплатите проходы и для компенсации обратитесь в чат поддержки Тинькофф';
  static String limitsAreOverAlfaText =
      'Лимит проходов в выбранный бизнес-зал исчерпан. Оформить бесплатное посещение вы сможете после истечения возможного времени пребывания в бизнес-зале. Для добавления гостей оформите отдельный заказ и оплатите его банковской картой';
}
