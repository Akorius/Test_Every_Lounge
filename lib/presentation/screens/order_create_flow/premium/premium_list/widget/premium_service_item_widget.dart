import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:everylounge/core/utils/money_formatter.dart';
import 'package:everylounge/data/clients/api_client.dart';
import 'package:everylounge/domain/entities/lounge/airport_destination_type.dart';
import 'package:everylounge/domain/entities/premium/premium_services.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:flutter/material.dart';

class PremiumServiceItemWidget extends StatelessWidget {
  final PremiumService service;
  final bool isAuth;
  final bool hasActiveBankCard;
  final AutoSizeGroup textGroup;
  final InnerDestinationType destinationType;

  const PremiumServiceItemWidget({
    super.key,
    required this.hasActiveBankCard,
    required this.service,
    required this.isAuth,
    required this.textGroup,
    required this.destinationType,
  });

  @override
  Widget build(BuildContext context) {
    String logo = "${service.logoId}/logo.png";
    return Container(
      height: 290,
      width: MediaQuery.of(context).size.width,
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(16),
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: CachedNetworkImageProvider("${ApiClient.filesUrl}$logo"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(color: context.colors.blackOpacity, borderRadius: BorderRadius.circular(8)),
                    child: Text(
                      service.flightDirection ?? "",
                      style: context.textStyles.textNormalRegular(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            // height: 96,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.colors.textLight,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      AutoSizeText(
                        service.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: context.textStyles.textLargeBold(color: context.colors.textBlue),
                      ),
                      if (service.terminal.isNotEmpty)
                        Text(
                          service.terminal,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: context.textStyles.textNormalRegular(
                            color: context.colors.textDefault.withOpacity(0.6),
                          ),
                        )
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  height: 38,
                  decoration: const BoxDecoration(
                    color: Color(0xFFEDF3FC),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AutoSizeText(
                          "от ${MoneyFormatter.getFormattedCost(
                            service.cost(destinationType: destinationType),
                          )}",
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          style: context.textStyles.textLargeBold(
                            color: context.colors.buttonEnabled,
                            ruble: true,
                          ),
                        ),
                        AutoSizeText(
                          " ₽",
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          style: context.textStyles.textLargeBold(
                            color: context.colors.buttonEnabled,
                            ruble: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
