import 'package:everylounge/data/constants/event_description.dart';
import 'package:everylounge/domain/entities/lounge/airport.dart';
import 'package:everylounge/domain/entities/lounge/service_search_type.dart';
import 'package:everylounge/presentation/common/router/routes.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/screens/order_create_flow/search_airport/cubit.dart';
import 'package:everylounge/presentation/screens/order_create_flow/search_airport/widget/switcher/airport_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AirportList extends StatelessWidget {
  final List<Airport> airportList;
  final ServiceSearchType serviceType;
  final bool isLoading;

  const AirportList({
    super.key,
    required this.airportList,
    required this.serviceType,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: airportList.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            context.read<SearchAirportCubit>().sendEventClick(eventName[airportServicesClick]!);
            switch (serviceType) {
              case ServiceSearchType.lounge:
                context.push(
                  "${AppRoutes.businessLoungeList}/${airportList[index].code.toLowerCase()}",
                  extra: {"airport": airportList[index]},
                ).then(
                  (value) => context.read<SearchAirportCubit>().getHistoryAirports(),
                );
                break;
              case ServiceSearchType.premium:
                context.push(AppRoutes.premiumServicesList, extra: {"airport": airportList[index]}).then(
                  (value) => context.read<SearchAirportCubit>().getHistoryAirports(),
                );
                break;
            }
          },
          child: AirportItemWidget(
            airportList[index],
            margin: const EdgeInsets.only(bottom: 8),
            backgroundColor: context.colors.cardBackground,
          ),
        );
      },
    );
  }
}
