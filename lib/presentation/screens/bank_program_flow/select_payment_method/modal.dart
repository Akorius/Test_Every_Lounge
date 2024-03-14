import 'package:everylounge/domain/entities/bank/card_type.dart';
import 'package:everylounge/domain/entities/bank/selected_bank.dart';
import 'package:everylounge/domain/entities/common/platform.dart';
import 'package:everylounge/presentation/common/cubit/attach_card/state.dart';
import 'package:everylounge/presentation/common/router/routes.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/screens/login_flow/web_view_login_flow/alfa_id_web/result.dart';
import 'package:everylounge/presentation/widgets/shared/modal_top_element.dart';
import 'package:everylounge/presentation/widgets/snackbar/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stream_listener/flutter_stream_listener.dart';
import 'package:go_router/go_router.dart';
import 'package:tinkoff_id_web/tinkoff_id_web.dart';

import 'cubit.dart';
import 'state.dart';
import 'widget/bank_item.dart';

class SelectPaymentMethodModal extends StatelessWidget {
  static const path = "selectPaymentMethodModal";

  const SelectPaymentMethodModal({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamListener(
      stream: context.read<SelectPaymentMethodCubit>().messageStream,
      onData: (message) {
        if (message == AttachCardState.successAddBankCardEvent) {
          final attachedCard = context.read<SelectPaymentMethodCubit>().attachCardCubit.state.attachedCard?.type;
          context.pop();
          context.push(AppRoutes.successAddCardModal, extra: attachedCard);
        } else if (message == SelectPaymentMethodState.navigateToTinkoffWebView) {
          context
              .push<TinkoffIdResult>(AppRoutes.loginTinkoffWeb)
              .then((result) => context.read<SelectPaymentMethodCubit>().onFromTinkoffIdWebReturned(result));
        } else if (message == SelectPaymentMethodState.navigateToProfile) {
          context.pop();
        } else if (message == SelectPaymentMethodState.navigateToTochka) {
          context.push(AppRoutes.addByPhoneNumberModal, extra: BankCardType.tochka);
        } else if (message == SelectPaymentMethodState.navigateToAlfa) {
          context.push(AppRoutes.addByPhoneNumberModal, extra: BankCardType.alfaClub);
        } else if (message == SelectPaymentMethodState.navigateToAlfaPrem) {
          context
              .push<AlfaIdResult>(AppRoutes.loginAlfaWeb,
                  extra: context.read<SelectPaymentMethodCubit>().state.alfaAuthLink ?? '')
              .then((result) => context.read<SelectPaymentMethodCubit>().onAlfaWebViewReturned(result));
        } else if (message == SelectPaymentMethodState.navigateToBeelineKZ) {
          context.push(AppRoutes.addByPhoneNumberModal, extra: BankCardType.beelineKZ);
        } else if (message == SelectPaymentMethodState.showSuccess) {
          context.pop();
          context.push(
            AppRoutes.successAddCardModal,
            extra: context.read<SelectPaymentMethodCubit>().state.activeCard?.type,
          );
        } else {
          context.showSnackbar(message);
        }
      },
      child: BlocBuilder<SelectPaymentMethodCubit, SelectPaymentMethodState>(
        builder: (context, state) {
          return Container(
            decoration: BoxDecoration(
                color: context.colors.backgroundColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                )),
            padding: EdgeInsets.only(left: 24, right: 24, bottom: 24 + (PlatformWrap.isIOS ? 21 : 0)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const ModalTopElement(),
                const SizedBox(height: 24),
                Text(
                  "Добавить способ оплаты",
                  style: context.textStyles.h2(),
                ),
                const SizedBox(height: 16),
                ...PaymentMethod.values
                    .getRange(0, PaymentMethod.values.length)
                    .where((element) => state.excludeTinkoff ? element != PaymentMethod.tinkoff : true)
                    .where((element) => state.hideTochka ? element != PaymentMethod.tochka : true)
                    .where((element) => state.hideBeelineKZ ? element != PaymentMethod.beelineKZ : true)
                    .where((element) => (state.hideAlfaPrem || state.excludeAlfaPrem || state.excludeAlfa)
                        ? element != PaymentMethod.alfaPrem
                        : true)
                    .where((element) => (state.excludeAlfaPrem || state.excludeAlfa) ? element != PaymentMethod.alfa : true)
                    .map(
                      (e) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: BankItem(
                          methodInHandle: state.methodInHandle,
                          method: e,
                          onPressed: () => context.read<SelectPaymentMethodCubit>().onPaymentMethodPressed(e),
                        ),
                      ),
                    )
                    .toList(),
              ],
            ),
          );
        },
      ),
    );
  }
}
