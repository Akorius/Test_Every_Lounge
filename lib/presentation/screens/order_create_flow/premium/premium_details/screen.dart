import 'package:auto_size_text/auto_size_text.dart';
import 'package:everylounge/domain/entities/common/platform.dart';
import 'package:everylounge/domain/entities/premium/premium_services.dart';
import 'package:everylounge/presentation/common/cubit/attach_card/state.dart';
import 'package:everylounge/presentation/common/router/routes.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/screens/login_flow/login_bottom_navigation/cubit.dart';
import 'package:everylounge/presentation/screens/order_create_flow/lounge/lounge_create/widget/additional_conditions.dart';
import 'package:everylounge/presentation/screens/order_create_flow/lounge/lounge_create/widget/scheduler/scheduler.dart';
import 'package:everylounge/presentation/screens/order_create_flow/lounge/lounge_create/widget/sliver_app_bar.dart';
import 'package:everylounge/presentation/screens/order_create_flow/lounge/lounge_create/widget/terminal.dart';
import 'package:everylounge/presentation/screens/order_create_flow/premium/premium_details/widget/premium_payment_area.dart';
import 'package:everylounge/presentation/screens/order_create_flow/premium/premium_details/widget/services_list.dart';
import 'package:everylounge/presentation/widgets/scaffold/common.dart';
import 'package:everylounge/presentation/widgets/snackbar/snackbar.dart';
import 'package:everylounge/presentation/widgets/tappable/regular.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'cubit.dart';
import 'state.dart';

class PremiumDetailsScreen extends StatelessWidget {
  static const String path = "premiumServicesDetailsScreen";

  const PremiumDetailsScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: CommonScaffold(
        messageStream: context.read<PremiumDetailsCubit>().messageStream,
        onMessage: (message) async {
          if (message == AttachCardState.successAddBankCardEvent) {
            final attachedCard = context.read<PremiumDetailsCubit>().state.activeBankCard?.type;
            if (attachedCard != null) {
              context.push(AppRoutes.successAddCardModal, extra: attachedCard);
            }
          } else if (message == PremiumDetailsState.navigateToCreateOrder) {
            switch (context.read<PremiumDetailsCubit>().state.service.kind) {
              case ServiceKind.meetandassist:
              default:
                context.push(AppRoutes.createOrderPremium, extra: {
                  "service": context.read<PremiumDetailsCubit>().state.service,
                  "destinationType": context.read<PremiumDetailsCubit>().state.destinationType
                });
                break;
            }
          } else {
            context.showSnackbar(message);
          }
        },
        backgroundColor: context.colors.backgroundColor,
        bottomNavigationBar: _BottomDetailsWidget(context.read<PremiumDetailsCubit>().state.service),
        child: SafeArea(
          bottom: false,
          child: BlocBuilder<PremiumDetailsCubit, PremiumDetailsState>(
            builder: (BuildContext context, state) {
              return NestedScrollView(
                physics: const BouncingScrollPhysics(),
                headerSliverBuilder: (context, innerScrolled) => [
                  CustomSliverAppBar(
                    state.service.gallery ?? [],
                    state.service.name,
                    (newOpacity) => context.read<PremiumDetailsCubit>().changeTitleOpacity(newOpacity),
                  ),
                ],
                body: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 0, left: 16, right: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AnimatedOpacity(
                          opacity: state.titleOpacity,
                          duration: const Duration(milliseconds: 200),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8, right: 8, top: 0),
                            child: AutoSizeText(
                              state.service.name,
                              maxLines: 2,
                              minFontSize: 14,
                              style: context.textStyles.h1(color: context.colors.textBlue),
                            ),
                          ),
                        ),
                        Terminal(state.service.terminal),
                        Padding(
                          padding: const EdgeInsets.only(left: 8, right: 8),
                          child: Text(state.service.location ?? "",
                              style: context.textStyles.textNormalRegular(color: context.colors.textNormalGrey)),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.only(left: 8, right: 8),
                          child: Scheduler(state.service.schedule),
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        AdditionalConditions(state.service.minAdultAge, state.service.maxStayDuration),
                        Padding(
                          padding: const EdgeInsets.only(left: 8, right: 8, top: 24),
                          child: Html(
                            data: state.service.description,
                          ),
                        ),
                        if (state.service.kind == ServiceKind.viplounge)
                          Padding(
                            padding: const EdgeInsets.only(left: 8, right: 8, top: 24),
                            child: Text(
                              "Доступно в VIP-зале",
                              style: context.textStyles.textLargeBold(color: context.colors.textBlue),
                            ),
                          ),
                        AvailableServicesList(service: state.service)
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  String parseScheduleTime(String time) {
    final nowDate = DateFormat('y-MM-dd').format(DateTime.now());
    final inputDate = DateTime.parse('$nowDate $time');
    final outputTime = DateFormat('HH:mm').format(inputDate);
    return outputTime;
  }
}

class _BottomDetailsWidget extends StatelessWidget {
  const _BottomDetailsWidget(
    this.service, {
    Key? key,
  }) : super(key: key);

  final PremiumService service;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PremiumDetailsCubit, PremiumDetailsState>(
      builder: (BuildContext context, state) {
        return Wrap(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: context.colors.cardBackground,
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 12, left: 24, right: 24, bottom: 12),
                child: !state.isAuth
                    ? RegularButton(
                        isLoading: state.isLoading,
                        height: 54,
                        label: Text(
                          "Авторизироваться",
                          style: context.textStyles.textLargeBold(color: context.colors.textLight),
                        ),
                        onPressed: () async {
                          context.go(AppRoutes.loginBottomNavigation);
                          context.read<LoginBottomNavigationCubit>().setIndex(0);
                        },
                      )
                    : PremiumPaymentArea(cost: service.cost(destinationType: state.destinationType), isLoading: state.isLoading),
              ),
            ),
            if (PlatformWrap.isIOS) Container(height: 21, decoration: BoxDecoration(color: context.colors.backgroundColor))
          ],
        );
      },
    );
  }
}
