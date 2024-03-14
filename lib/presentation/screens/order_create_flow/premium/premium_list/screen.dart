import 'package:auto_size_text/auto_size_text.dart';
import 'package:collection/collection.dart';
import 'package:everylounge/presentation/common/router/routes.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/widgets/appbars/back_arrow.dart';
import 'package:everylounge/presentation/widgets/loaders/circular.dart';
import 'package:everylounge/presentation/widgets/scaffold/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'cubit.dart';
import 'state.dart';
import 'widget/destination_switcher.dart';
import 'widget/premium_service_item_widget.dart';

class PremiumServicesListScreen extends StatelessWidget {
  static const String path = "premium_list";

  PremiumServicesListScreen({super.key});

  final _textGroup = AutoSizeGroup();

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      messageStream: context.read<PremiumServicesListCubit>().messageStream,
      onMessage: (message) async {},
      backgroundColor: context.colors.profileBackgroundColor,
      appBar: AppBar(
        backgroundColor: context.colors.profileBackgroundColor,
        leading: const BackArrowButton(),
        centerTitle: true,
        elevation: 0,
        title: Text(context.read<PremiumServicesListCubit>().state.airport.code,
            textAlign: TextAlign.center,
            style: context.textStyles.textLargeBold(color: context.colors.textLight).copyWith(fontSize: 48)),
      ),
      child: BlocBuilder<PremiumServicesListCubit, PremiumServicesListState>(
        builder: (BuildContext context, state) {
          var servicesList = context.read<PremiumServicesListCubit>().getServicesList();
          return state.isLoading
              ? SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: AppCircularProgressIndicator.large(
                    color: context.colors.lightProgress,
                  ),
                )
              : Column(
                  children: [
                    Text(state.airport.name.isEmpty ? state.airport.city : "${state.airport.city}, ${state.airport.name}",
                        textAlign: TextAlign.center,
                        style: context.textStyles.textLargeRegular(color: context.colors.textLight.withOpacity(0.6))),
                    Expanded(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.only(top: 16),
                        padding: const EdgeInsets.only(top: 16),
                        decoration: BoxDecoration(
                          color: context.colors.backgroundColor,
                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                        ),
                        child: Column(
                          children: [
                            DestinationSwitcher(
                              onSelect: context.read<PremiumServicesListCubit>().onAirportDestinationSelected,
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            servicesList.isNotEmpty
                                ? Expanded(
                                    child: ListView(
                                      padding: const EdgeInsets.only(bottom: 16),
                                      shrinkWrap: true,
                                      physics: const BouncingScrollPhysics(),
                                      children: [
                                        ...servicesList.mapIndexed(
                                          (i, e) => Padding(
                                            padding: EdgeInsets.only(left: 16, right: 16, top: i == 0 ? 0 : 16),
                                            child: GestureDetector(
                                              onTap: () => context.push(AppRoutes.premiumServicesDetails, extra: {
                                                "service": e,
                                                "destinationType": state.destinationType,
                                              }),
                                              child: PremiumServiceItemWidget(
                                                  service: e,
                                                  isAuth: state.hasActiveCard,
                                                  hasActiveBankCard: state.hasActiveCard,
                                                  textGroup: _textGroup,
                                                  destinationType: state.destinationType),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                : const Padding(
                                    padding: EdgeInsets.only(top: 16),
                                    child: Text('Нет доступных услуг'),
                                  )
                          ],
                        ),
                      ),
                    ),
                  ],
                );
        },
      ),
    );
  }
}
