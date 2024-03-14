import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:everylounge/core/utils/money_formatter.dart';
import 'package:everylounge/data/clients/api_client.dart';
import 'package:everylounge/domain/entities/lounge/lounge.dart';
import 'package:everylounge/presentation/common/assets/assets.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoungeItemWidget extends StatelessWidget {
  final Lounge lounge;
  final bool showPrice;
  final bool showArrow;

  const LoungeItemWidget({
    super.key,
    required this.lounge,
    required this.showPrice,
    required this.showArrow,
  });

  @override
  Widget build(BuildContext context) {
    String logo = "${lounge.logoId}/logo.png";
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
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 48),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: context.colors.blackOpacity,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      lounge.flightDirection ?? "",
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
                        lounge.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: context.textStyles.textLargeBold(color: context.colors.textBlue),
                      ),
                      if (lounge.terminal.isNotEmpty)
                        Text(
                          lounge.terminal,
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
                if (showPrice)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    height: 38,
                    decoration: BoxDecoration(
                      color: context.colors.switcherColor,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AutoSizeText(
                            MoneyFormatter.getFormattedCost(lounge.cost),
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
                if (showArrow)
                  Container(
                    width: 80,
                    padding: const EdgeInsets.only(top: 12, bottom: 12),
                    height: 40,
                    decoration: BoxDecoration(
                      color: context.colors.buttonEnabled,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    child: SvgPicture.asset(
                      AppImages.arrowRightLong,
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
