import 'package:cached_network_image/cached_network_image.dart';
import 'package:everylounge/data/clients/api_client.dart';
import 'package:everylounge/domain/entities/order/order.dart';
import 'package:everylounge/domain/entities/order/order_status.dart';
import 'package:everylounge/presentation/common/assets/assets.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/widgets/shared/ticketWrapper/ticket_top.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shimmer/shimmer.dart';

class LoungeTicketTop extends StatelessWidget {
  const LoungeTicketTop({
    super.key,
    required this.order,
    required this.pnr,
    required this.needMaskPnr,
    required this.isPartnerOrg,
    required this.needLoadQrForLoungeMe,
    required this.isLoungeMe,
    required this.isDragonPass,
    required this.isAirportOrgs,
  });

  final Order order;
  final String pnr;
  final bool needMaskPnr;
  final bool isPartnerOrg;
  final bool needLoadQrForLoungeMe;
  final bool isLoungeMe;
  final bool isDragonPass;
  final bool isAirportOrgs;

  @override
  Widget build(BuildContext context) {
    return TicketTop(
      child: Column(
        children: [
          const SizedBox(height: 16),
          Text(
            order.status.getDesignation(),
            style: context.textStyles.textOrderDetailsLarge(color: context.colors.textOrderDetailsTitle),
          ),
          const SizedBox(height: 20),
          isPartnerOrg && !needMaskPnr
              ? Container(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  width: 226,
                  height: 226,
                  decoration: BoxDecoration(
                    color: context.colors.cardBackground,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 3,
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      (isLoungeMe && needLoadQrForLoungeMe)
                          ? CachedNetworkImage(
                              height: 180,
                              imageUrl: "${ApiClient.filesUrl}${order.qrId}",
                              errorWidget: (c, s, _) => Padding(
                                padding: const EdgeInsets.only(top: 16, bottom: 16),
                                child: Image.asset(AppImages.qrCodeBg),
                              ),
                              placeholder: (context, string) => Shimmer.fromColors(
                                baseColor: context.colors.backgroundColor,
                                highlightColor: context.colors.dividerGray,
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(20),
                                      topLeft: Radius.circular(20),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : QrImageView(
                              data: pnr,
                              version: isLoungeMe ? 2 : QrVersions.auto,
                              errorCorrectionLevel: QrErrorCorrectLevel.M,
                              size: 180,
                            ),
                      Image.asset(
                        getImageUrl(),
                        errorBuilder: (c, e, s) => const SizedBox.shrink(),
                        width: 168,
                        height: 33,
                      ),
                    ],
                  ),
                )
              : SizedBox(
                  height: 226,
                  width: 226,
                  child: Image.asset(AppImages.qrCodeBg),
                ),
          const SizedBox(height: 15),
          Text(
            pnr,
            textAlign: TextAlign.center,
            style: context.textStyles.header700(),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  String getImageUrl() {
    if (isDragonPass) {
      return AppImages.dragonPassLabel;
    }
    if (isLoungeMe) {
      return AppImages.loungeMeLabel;
    }
    if (isAirportOrgs) {
      return AppImages.everyLoungeLabel;
    }
    return '';
  }
}
