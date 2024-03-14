import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/screens/history/cubit.dart';
import 'package:everylounge/presentation/screens/history/state.dart';
import 'package:everylounge/presentation/screens/history/widgets/app_bar.dart';
import 'package:everylounge/presentation/screens/history/widgets/history_list.dart';
import 'package:everylounge/presentation/screens/history/widgets/zero_sells_body.dart';
import 'package:everylounge/presentation/widgets/loaders/app_loader.dart';
import 'package:everylounge/presentation/widgets/loaders/circular.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HistoryScreen extends StatelessWidget {
  static const path = "history";

  const HistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.profileBackgroundColor,
      appBar: const HistoryAppBar(),
      body: CustomRefreshIndicator(
        onRefresh: () => context.read<HistoryCubit>().getOrderList(),
        builder: MaterialIndicatorDelegate(
          withRotation: false,
          elevation: 1,
          backgroundColor: Colors.white,
          builder: (context, controller) {
            return const Padding(padding: EdgeInsets.all(6), child: EveryAppLoader());
          },
        ),
        child: BlocBuilder<HistoryCubit, HistoryState>(
          builder: (context, state) {
            return !state.isLoading
                ? state.ordersList.isEmpty
                    ? const ZeroSellBody()
                    : HistoryList(
                        ordersList: state.ordersList,
                        isLoadingNewPage: state.isLoadingNewPage,
                      )
                : const Center(
                    child: AppCircularProgressIndicator.large(),
                  );
          },
        ),
      ),
    );
  }
}
