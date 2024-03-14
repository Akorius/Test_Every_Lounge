import 'package:everylounge/domain/entities/lounge/airport.dart';
import 'package:everylounge/domain/entities/lounge/service_search_type.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/screens/order_create_flow/search_airport/widget/airport_loading_shimmer.dart';
import 'package:everylounge/presentation/screens/order_create_flow/search_airport/widget/switcher/airport_list.dart';
import 'package:flutter/material.dart';

class AirportCommonBody extends StatelessWidget {
  const AirportCommonBody({
    super.key,
    required this.airportList,
    required this.serviceType,
    required this.isLoading,
    required this.emptyWidget,
    this.shimmerItemCount = 5,
    this.title,
    this.hideTitleIfEmptyList = false,
  });

  final List<Airport> airportList;
  final ServiceSearchType serviceType;
  final bool isLoading;
  final int shimmerItemCount;
  final String? title;
  final Widget emptyWidget;
  final bool hideTitleIfEmptyList;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        (title?.isNotEmpty == true && !(hideTitleIfEmptyList && !isLoading && airportList.isEmpty))
            ? Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  title!,
                  style: AppTextStyles.textLargeBold(color: context.colors.textMiddleBlue),
                ),
              )
            : const SizedBox.shrink(),
        isLoading
            ? AirportLoadingShimmer(
                itemCount: shimmerItemCount,
              )
            : airportList.isEmpty
                ? emptyWidget
                : AirportList(
                    airportList: airportList,
                    serviceType: serviceType,
                    isLoading: isLoading,
                  ),
      ],
    );
  }
}
