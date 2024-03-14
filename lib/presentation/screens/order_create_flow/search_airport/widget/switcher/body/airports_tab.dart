import 'package:everylounge/presentation/screens/order_create_flow/search_airport/cubit.dart';
import 'package:everylounge/presentation/screens/order_create_flow/search_airport/state.dart';
import 'package:everylounge/presentation/screens/order_create_flow/search_airport/widget/switcher/body/airport_tab_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AirportsTab extends StatelessWidget {
  final bool isHistory;

  const AirportsTab({super.key, this.isHistory = false});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchAirportCubit, SearchAirportState>(
      builder: (BuildContext context, state) => AirportTabBody(
        airportListNearby: state.airportListNearby,
        airportListHistory: state.airportListHistory,
        airportListPopular: state.airportListPopular,
        isLoadingHistory: state.isLoadingHistory,
        isLoadingPopular: state.isLoadingPopular,
        isLoadingNearby: state.isLoadingNearby,
        isHistory: isHistory,
        serviceType: state.serviceType,
      ),
    );
  }
}
