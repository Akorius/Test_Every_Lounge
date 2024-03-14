import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/screens/order_create_flow/search_airport/widget/switcher/body/airport_common_body.dart';
import 'package:everylounge/presentation/screens/order_create_flow/search_airport/widget/switcher/body/airports_tab.dart';
import 'package:everylounge/presentation/screens/order_create_flow/search_airport/widget/switcher/switcher.dart';
import 'package:everylounge/presentation/widgets/scaffold/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'cubit.dart';
import 'state.dart';
import 'widget/info_warning.dart';
import 'widget/search_bar.dart';

class SearchAirportScreen extends StatelessWidget {
  static const String path = "airports";

  const SearchAirportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchAirportCubit, SearchAirportState>(
      builder: (BuildContext context, state) {
        return CommonScaffold(
          messageStream: context.read<SearchAirportCubit>().messageStream,
          onMessage: (message) {},
          backgroundColor: context.colors.backgroundColor,
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            backgroundColor: context.colors.backgroundColor,
            elevation: 0,
            title: Text(
              "Выбрать аэропорт",
              style: context.textStyles.h2(),
            ),
            leading: BackButton(
              onPressed: () => GoRouter.of(context).pop(),
              color: context.colors.textDefault,
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SearchBarWidget(
                  searchAirports: (trimmedValue) => context.read<SearchAirportCubit>().getSearchAirports(text: trimmedValue),
                  onClearSearch: () => context.read<SearchAirportCubit>().onClearSearch(),
                ),
              ),
              Expanded(
                child: state.fromSearch
                    ? SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: AirportCommonBody(
                            airportList: state.airportListSearch,
                            isLoading: state.isLoadingSearch,
                            serviceType: state.serviceType,
                            emptyWidget: Padding(
                              padding: EdgeInsets.only(top: MediaQuery.of(context).size.width * 0.33),
                              child: Text(
                                "К сожалению, по вашему\nзапросу ничего не найдено",
                                style: AppTextStyles.textLargeBold(color: context.colors.textMiddleBlue),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      )
                    : const DefaultTabController(
                        length: 2,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            children: [
                              Switcher(),
                              Flexible(
                                child: TabBarView(
                                  physics: NeverScrollableScrollPhysics(),
                                  children: [
                                    AirportsTab(),
                                    AirportsTab(isHistory: true),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
              ),
              if (state.isShowInfoWarning && !state.isLoadingSearch) InfoWarning(state.serviceType),
            ],
          ),
        );
      },
    );
  }
}
