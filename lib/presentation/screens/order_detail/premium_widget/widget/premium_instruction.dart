import 'package:collection/collection.dart';
import 'package:everylounge/data/clients/api_client.dart';
import 'package:everylounge/domain/entities/file/pdf_data.dart';
import 'package:everylounge/domain/entities/lounge/airport_destination_type.dart';
import 'package:everylounge/domain/entities/order/order.dart';
import 'package:everylounge/presentation/common/router/routes.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/widgets/tappable/regular_negative.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Instruction extends StatelessWidget {
  const Instruction(
    this.order, {
    super.key,
  });

  final Order order;
  final String instruction = "Инструкция";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8, left: 8.0, right: 8.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: context.colors.backgroundColor,
          borderRadius: const BorderRadius.all(Radius.circular(24)),
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 16,
            ),
            Text(
              "Номер заказа",
              style: context.textStyles.textSmallRegular(color: context.colors.hintText).copyWith(fontSize: 12),
            ),
            Text(
              order.pnr,
              style: context.textStyles.h1(color: context.colors.textDefault).copyWith(fontSize: 32),
            ),
            const SizedBox(height: 4),
            order.premiumService?.documents?.isNotEmpty == true
                ? Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
                    child: RegularButtonNegative(
                      minWidth: MediaQuery.of(context).size.width,
                      onPressed: () => launchUrl(context),
                      height: 48,
                      canPress: true,
                      isLoading: false,
                      child: Text(
                        instruction,
                        style: context.textStyles.textOrderDetailsLarge(color: context.colors.textOrderDetailsBlue),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
            const SizedBox(height: 8)
          ],
        ),
      ),
    );
  }

  Future<bool>? launchUrl(BuildContext context) {
    var service = order.premiumService;
    if ((order.flightInfo?.length ?? 0) > 1) {
      if (service?.documents != null) {
        for (var doc in service!.documents!) {
          var id = doc.url?.substring(1);
          var type = doc.type ?? AirportDestinationType.arrival;
          final String link = "${ApiClient.filesUrl}$id/instruction_${type.name}.pdf";
          context.push(AppRoutes.pdfViewScreen, extra: PdfData(title: instruction, link: link));
        }
      }
    } else {
      var info = order.flightInfo?.first;
      var doc = service?.documents?.firstWhereOrNull((element) => element.type == info?.type) ?? service?.documents?.firstOrNull;
      if (doc != null) {
        var id = doc.url?.substring(1);
        final String link = "${ApiClient.filesUrl}$id/instruction.pdf";
        context.push(AppRoutes.pdfViewScreen, extra: PdfData(title: instruction, link: link));
      }
    }
    return null;
  }
}
