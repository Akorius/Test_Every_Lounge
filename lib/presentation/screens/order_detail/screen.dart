import 'package:everylounge/domain/entities/order/order_type.dart';
import 'package:everylounge/domain/entities/payment/acquiring_type.dart';
import 'package:everylounge/presentation/common/cubit/attach_card/state.dart';
import 'package:everylounge/presentation/common/cubit/payment/state.dart';
import 'package:everylounge/presentation/common/router/routes.dart';
import 'package:everylounge/presentation/screens/order_create_flow/web_view/tinkoff_acquiring_webview/extra.dart';
import 'package:everylounge/presentation/screens/order_detail/cubit.dart';
import 'package:everylounge/presentation/screens/order_detail/lounge_widget/lounge_screen_content.dart';
import 'package:everylounge/presentation/screens/order_detail/premium_widget/premium_screen.dart';
import 'package:everylounge/presentation/screens/order_detail/state.dart';
import 'package:everylounge/presentation/screens/order_detail/upgrade_widget/upgrade_modal_content.dart';
import 'package:everylounge/presentation/widgets/snackbar/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stream_listener/flutter_stream_listener.dart';
import 'package:go_router/go_router.dart';

class OrderDetailsScreen extends StatefulWidget {
  static const String pathScreen = "order_screen";
  static const String pathModal = "order_modal";

  const OrderDetailsScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> with WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        context.read<OrderDetailsCubit>().payOrderCubit.fromBanksAppReturned();
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.detached:
        break;
      case AppLifecycleState.hidden:
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    context.read<OrderDetailsCubit>().refreshOrder();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: StreamListener(
        stream: context.read<OrderDetailsCubit>().messageStream,
        onData: (message) {
          if (message.contains(PayOrderState.navigateToTinkoffWebView)) {
            context.push(
              AppRoutes.acquiringWebViewTinkkoff,
              extra: AcquiringExtraObject(
                activeCardType: context.read<OrderDetailsCubit>().state.activeCard?.type,
                paymentUrl: context.read<OrderDetailsCubit>().payOrderCubit.state.webViewPaymentUri!,
                onPaymentSuccess: () => context.read<OrderDetailsCubit>().payOrderCubit.onWebViewReturned(true),
                onPaymentFailure: () => context.read<OrderDetailsCubit>().payOrderCubit.onWebViewReturned(false),
                showTinkoffWarning: true,
              ),
            );
          } else if (message.contains(PayOrderState.navigateToSuccess)) {
            if (context.read<OrderDetailsCubit>().state.order.acquiringType == AcquiringType.passages) {
              context.showTopSnackbar("Ваш заказ успешно оформлен");
            } else {
              context.showTopSnackbar("Ваш заказ успешно оплачен");
            }
          } else if (message.contains(PayOrderState.navigateToOrderDetailsScreen)) {
            //ignore
          } else if (message == AttachCardState.successAddBankCardEvent) {
            final attachedCard = context.read<OrderDetailsCubit>().attachCardCubit.state.attachedCard?.type;
            if (attachedCard != null) {
              context.push(AppRoutes.successAddCardModal, extra: attachedCard);
            }
          } else {
            context.read<OrderDetailsCubit>().sendEventError(message);
            context.showSnackbar(message);
          }
        },
        child: BlocBuilder<OrderDetailsCubit, OrderDetailsState>(
          builder: (context, state) {
            return state.order.type == OrderType.lounge
                ? LoungeScreenContent(state: state)
                : state.order.type == OrderType.premium
                    ? PremiumScreenContent(state: state)
                    : UpgradeModalContent(state: state);
          },
        ),
      ),
    );
  }
}
