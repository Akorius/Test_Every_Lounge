import 'package:everylounge/domain/entities/common/platform.dart';
import 'package:everylounge/domain/entities/login/passage.dart';
import 'package:everylounge/presentation/common/router/routes.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/screens/order_create_flow/upgrade/search_upgrade_flight/cubit.dart';
import 'package:everylounge/presentation/screens/order_create_flow/upgrade/search_upgrade_flight/state.dart';
import 'package:everylounge/presentation/screens/order_create_flow/upgrade/search_upgrade_flight/widget/animated_error.dart';
import 'package:everylounge/presentation/screens/order_create_flow/upgrade/search_upgrade_flight/widget/booking_details_area.dart';
import 'package:everylounge/presentation/screens/order_create_flow/upgrade/search_upgrade_flight/widget/upgrade_area/upgrade_flight_area_alfa.dart';
import 'package:everylounge/presentation/screens/order_create_flow/upgrade/search_upgrade_flight/widget/upgrade_area/upgrade_flight_area_web.dart';
import 'package:everylounge/presentation/widgets/appbars/back_arrow.dart';
import 'package:everylounge/presentation/widgets/loaders/circular.dart';
import 'package:everylounge/presentation/widgets/scaffold/common.dart';
import 'package:everylounge/presentation/widgets/snackbar/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SearchUpgradeBookingScreen extends StatelessWidget {
  static const String path = "search_booking";

  const SearchUpgradeBookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: BlocBuilder<SearchUpgradeFlightCubit, UpgradeFlightState>(
        builder: (BuildContext context, state) {
          return state.cardsLoading
              ? Scaffold(
                  backgroundColor: context.colors.lightProgress,
                  body: const Padding(
                    padding: EdgeInsets.all(8),
                    child: AppCircularProgressIndicator(),
                  ),
                )
              : CommonScaffold(
                  extendBodyBehindAppBar: true,
                  messageStream: context.read<SearchUpgradeFlightCubit>().messageStream,
                  onMessage: (message) async {
                    if (message == UpgradeFlightState.successSearchTicketEvent) {
                      context.push(AppRoutes.flightOrder, extra: context.read<SearchUpgradeFlightCubit>().state.searchData);
                    } else {
                      context.showSnackbar(message);
                    }
                  },
                  appBar: appBar(context),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: Stack(
                      children: [
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              PlatformWrap.isAndroidOrIOS
                                  ? state.activeCard?.passageType == TypePassage.endlessLoungeAndUpgrade
                                      ? const UpgradeFlightAreaAlfa()
                                      : const SizedBox.shrink()
                                  : const UpgradeFlightAreaWeb(),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: state.activeCard?.passageType == TypePassage.endlessLoungeAndUpgrade
                                      ? 20
                                      : MediaQuery.of(context).padding.top + 54,
                                  horizontal: 24,
                                ),
                                child: BookingDetailsArea(state.canGetBookingDetails, state.currentCompany),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: AnimatedError(state.errorMessage),
                        ),
                      ],
                    ),
                  ),
                );
        },
      ),
    );
  }

  PreferredSizeWidget appBar(BuildContext context) {
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      backgroundColor: context.colors.appBarTransparentBackgroundColor,
      leading: const BackArrowButton(),
      elevation: 0,
    );
  }
}
