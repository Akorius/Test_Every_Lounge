import 'package:everylounge/domain/entities/bank/card.dart';
import 'package:everylounge/domain/entities/bank/card_type.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/screens/bank_program_flow/bank_program_detailed/cubit.dart';
import 'package:everylounge/presentation/screens/bank_program_flow/bank_program_detailed/widget/active_program_label.dart';
import 'package:everylounge/presentation/screens/bank_program_flow/bank_program_detailed/widget/privilege/alfa/alfa.dart';
import 'package:everylounge/presentation/screens/bank_program_flow/bank_program_detailed/widget/privilege/alfa/alfa_premium.dart';
import 'package:everylounge/presentation/screens/bank_program_flow/bank_program_detailed/widget/privilege/beeline_kz.dart';
import 'package:everylounge/presentation/screens/bank_program_flow/bank_program_detailed/widget/privilege/mkb.dart';
import 'package:everylounge/presentation/screens/bank_program_flow/bank_program_detailed/widget/privilege/otkrytie.dart';
import 'package:everylounge/presentation/screens/bank_program_flow/bank_program_detailed/widget/privilege/tinkoff_private.dart';
import 'package:everylounge/presentation/widgets/tappable/regular.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'privilege/gazprom_premium.dart';
import 'privilege/other.dart';
import 'privilege/tinkoff_default.dart';
import 'privilege/tinkoff_premium.dart';
import 'privilege/tochka.dart';

class PrivilegeCard extends StatelessWidget {
  final BankCard bankCard;
  final bool loading;
  late final Widget _privilegeWidget;

  PrivilegeCard({
    Key? key,
    required this.bankCard,
    required this.loading,
  }) : super(key: key) {
    switch (bankCard.type) {
      case BankCardType.tinkoffDefault:
      case BankCardType.tinkoffPro:
        _privilegeWidget = const TinkoffDefaultPrivilege();
        break;
      case BankCardType.tinkoffPremium:
        _privilegeWidget = const TinkoffPremiumPrivilege();
        break;
      case BankCardType.tinkoffPrivate:
        _privilegeWidget = const TinkoffPrivatePrivilege();
        break;
      case BankCardType.gazpromPremium:
      case BankCardType.gazpromPrivate:
        _privilegeWidget = const GazPromPremiumPrivilege();
        break;
      case BankCardType.tochka:
        _privilegeWidget = TochkaPrivilege(bankCard: bankCard);
        break;
      case BankCardType.beelineKZ:
        _privilegeWidget = BeelineKZPrivilege(bankCard: bankCard);
        break;
      case BankCardType.otkrytie:
        _privilegeWidget = const OtkrytiePrivilege();
        break;
      case BankCardType.moscowCredit:
        _privilegeWidget = const MkbPrivilege();
        break;
      case BankCardType.alfaClub:
        _privilegeWidget = AlfaPrivilege(bankCard: bankCard);
        break;
      case BankCardType.alfaPrem:
        _privilegeWidget = AlfaPremiumPrivilege(bankCard: bankCard);
        break;
      case BankCardType.gazpromDefault:
      case BankCardType.other:
      case BankCardType.raiffeisen:
        _privilegeWidget = const NoPrivilege();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 24, right: 24, bottom: 20, top: 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
      ),
      child: Column(
        children: [
          _privilegeWidget,
          const SizedBox(height: 24),
          bankCard.isActive
              ? ActiveProgramLabel(
                  isLoading: loading,
                  text: bankCard.fake == true ? '• Активная программа привилегий' : "• Активный способ оплаты")
              : RegularButton(
                  isLoading: loading,
                  label: Text(bankCard.fake == true ? "Сделать активной" : "Сделать активным"),
                  onPressed: context.read<BankProgramDetailedCubit>().setActiveCard,
                  textStyle: context.textStyles.textLargeBold(),
                  height: 42,
                  withoutElevation: true,
                ),
        ],
      ),
    );
  }
}
