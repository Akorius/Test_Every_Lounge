import 'package:everylounge/domain/entities/lounge/airport.dart';
import 'package:everylounge/domain/entities/lounge/service_search_type.dart';
import 'package:everylounge/presentation/screens/order_create_flow/search_airport/widget/info_block.dart';
import 'package:everylounge/presentation/screens/order_create_flow/search_airport/widget/switcher/body/airport_common_body.dart';
import 'package:flutter/material.dart';

class AirportTabBody extends StatelessWidget {
  final List<Airport> airportListNearby;
  final List<Airport> airportListHistory;
  final List<Airport> airportListPopular;
  final bool isLoadingHistory;
  final bool isLoadingPopular;
  final bool isLoadingNearby;
  final bool isHistory;
  final ServiceSearchType serviceType;

  const AirportTabBody({
    required this.airportListNearby,
    required this.airportListHistory,
    required this.airportListPopular,
    required this.isLoadingHistory,
    required this.isLoadingPopular,
    required this.isLoadingNearby,
    this.isHistory = false,
    required this.serviceType,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      children: [
        isHistory
            ? AirportCommonBody(
                airportList: airportListHistory,
                serviceType: serviceType,
                isLoading: isLoadingHistory,
                emptyWidget: const Info(title: "Пока пусто", subtitle: "Вы еще не просматривали бизнес-залы"),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AirportCommonBody(
                    airportList: airportListNearby,
                    serviceType: serviceType,
                    isLoading: isLoadingNearby,
                    title: "Аэропорты рядом",
                    emptyWidget: Padding(
                      padding: EdgeInsets.only(bottom: 16),
                      child: Info(
                        title: "Аэропортов рядом не обнаружено",
                        subtitle: serviceType == ServiceSearchType.premium
                            ? "Отображаются только аэропорты\nгде доступны премиальные сервисы"
                            : 'Отображаются только аэропорты\nгде доступны бизнес-залы',
                      ),
                    ),
                    shimmerItemCount: 2,
                  ),
                  const SizedBox(height: 8),
                  AirportCommonBody(
                    airportList: airportListNearby,
                    serviceType: serviceType,
                    isLoading: isLoadingPopular,
                    title: "Популярные направления",
                    emptyWidget: const SizedBox.shrink(),
                    hideTitleIfEmptyList: true,
                  )
                ],
              ),
      ],
    );
  }
}
