import 'package:everylounge/data/constants/event_description.dart';
import 'package:everylounge/domain/entities/bank/card.dart';
import 'package:everylounge/domain/entities/lounge/lounge.dart';
import 'package:everylounge/domain/entities/lounge/service_search_type.dart';
import 'package:everylounge/presentation/common/router/routes.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/screens/order_create_flow/lounge/lounge_list/widget/lounge_custom_switcher.dart';
import 'package:everylounge/presentation/screens/order_create_flow/lounge/lounge_list/widget/lounge_item_widget.dart';
import 'package:everylounge/presentation/widgets/appbars/back_arrow.dart';
import 'package:everylounge/presentation/widgets/loaders/circular.dart';
import 'package:everylounge/presentation/widgets/scaffold/common.dart';
import 'package:everylounge/presentation/widgets/snackbar/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'cubit.dart';
import 'state.dart';

class LoungeListScreen extends StatelessWidget {
  static const String path = "airport";

  const LoungeListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CommonScaffold(
      messageStream: context.read<LoungeListCubit>().messageStream,
      onMessage: (message) async {
        context.read<LoungeListCubit>().sendEventError(message);
        context.showSnackbar(message);
      },
      backgroundColor: context.colors.profileBackgroundColor,
      appBar: AppBar(
        backgroundColor: context.colors.profileBackgroundColor,
        leading: const BackArrowButton(),
        centerTitle: true,
        elevation: 0,
        title: Text(context.read<LoungeListCubit>().state.airport?.code ?? "",
            textAlign: TextAlign.center,
            style: context.textStyles.textLargeBold(color: context.colors.textLight).copyWith(fontSize: 48)),
      ),
      child: BlocBuilder<LoungeListCubit, LoungeListState>(
        builder: (BuildContext context, state) {
          return state.isLoading || state.isLoungeLoading
              ? SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: AppCircularProgressIndicator.large(
                    color: context.colors.lightProgress,
                  ),
                )
              : Column(
                  children: [
                    Text(state.airport!.name.isEmpty ? state.airport!.city : "${state.airport!.city}, ${state.airport!.name}",
                        textAlign: TextAlign.center,
                        style: context.textStyles.textLargeRegular(color: context.colors.textLight.withOpacity(0.6))),
                    const SizedBox(height: 16),
                    Expanded(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.only(top: 24),
                        decoration: BoxDecoration(
                          color: context.colors.backgroundColor,
                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                        ),
                        child: (state.loungeListAll.isNotEmpty)
                            ? Column(
                                children: [
                                  LoungeCustomSwitcher(
                                    onSelect: context.read<LoungeListCubit>().changeIndexTab,
                                  ),
                                  Expanded(
                                    child: LoungeList(
                                      isAuth: state.isAuth,
                                      activeCard: state.activeCard,
                                      isPayByPass: state.isPayByPass,
                                      listLounge: state.selectedIndex == 0
                                          ? state.loungeListAll
                                          : state.selectedIndex == 1
                                              ? state.loungeListInternational
                                              : state.loungeListDomestic,
                                    ),
                                  ),
                                ],
                              )
                            : const SizedBox.shrink(),
                      ),
                    )
                  ],
                );
        },
      ),
    );
  }
}

class LoungeList extends StatelessWidget {
  final List<Lounge> listLounge;
  final BankCard? activeCard;
  final bool isAuth;
  final bool isPayByPass;

  const LoungeList({
    super.key,
    required this.listLounge,
    required this.activeCard,
    required this.isAuth,
    required this.isPayByPass,
  });

  @override
  Widget build(BuildContext context) {
    return listLounge.isNotEmpty
        ? ListView.builder(
            itemCount: listLounge.length,
            itemBuilder: ((context, index) {
              final Lounge item = listLounge[index];
              return Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child: GestureDetector(
                  onTap: () {
                    context.read<LoungeListCubit>().sendEventClick(eventName[businessLoungeClick]!);
                    context.push(AppRoutes.businessLoungeDetails, extra: {
                      "lounge": item,
                      "searchType": ServiceSearchType.lounge,
                      "card": activeCard,
                    });
                  },
                  child: LoungeItemWidget(
                    lounge: item,
                    showPrice: isAuth && !isPayByPass,
                    showArrow: isAuth && isPayByPass,
                  ),
                ),
              );
            }),
          )
        : const Padding(
            padding: EdgeInsets.only(top: 16),
            child: Text('Нет доступных услуг'),
          );
  }
}
