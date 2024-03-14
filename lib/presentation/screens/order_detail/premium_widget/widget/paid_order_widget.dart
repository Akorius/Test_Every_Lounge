import 'package:everylounge/core/utils/money_formatter.dart';
import 'package:everylounge/data/clients/api_client.dart';
import 'package:everylounge/domain/entities/file/pdf_data.dart';
import 'package:everylounge/domain/entities/order/order_status.dart';
import 'package:everylounge/presentation/common/assets/assets.dart';
import 'package:everylounge/presentation/common/router/routes.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/screens/order_detail/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class PaidOrderWidget extends StatelessWidget {
  const PaidOrderWidget({super.key, required this.state});

  final OrderDetailsState state;

  final String vaucher = "Ваучер";

  @override
  Widget build(BuildContext context) {
    var designation = state.order.status == OrderStatus.paid ? "Оплачено" : state.order.status.getDesignation();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "$designation: ${MoneyFormatter.getFormattedCost(
                state.order.amount,
              )}₽",
              style: context.textStyles.textOrderDetailsNormal(
                color: context.colors.textDefault,
                ruble: true,
              ),
            ),
            Text(
              DateFormat('dd.MM.yyyy').format(state.order.createdAt),
              style: context.textStyles.textOrderDetailsNormal(color: context.colors.textDefault),
            )
          ],
        ),
        if (state.order.qrId != 0)
          GestureDetector(
            onTap: () {
              final String link = "${ApiClient.filesUrl}${state.order.qrId}/voucher.pdf";
              context.push(AppRoutes.pdfViewScreen, extra: PdfData(title: vaucher, link: link));
            },
            child: Row(
              children: [
                Text(
                  vaucher,
                  style: context.textStyles.textLargeRegular(color: context.colors.textDefault),
                ),
                const SizedBox(
                  width: 8,
                ),
                SvgPicture.asset(AppImages.voucherNew)
              ],
            ),
          ),
      ],
    );
  }
}
