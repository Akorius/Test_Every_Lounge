import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:duration/duration.dart';
import 'package:everylounge/core/utils/text.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:flutter/material.dart';

class AdditionalConditions extends StatelessWidget {
  const AdditionalConditions(
    this.minAdultAge,
    this.maxStayDuration, {
    Key? key,
  }) : super(key: key);

  final int? minAdultAge;
  final String? maxStayDuration;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(left: 16, right: 16, top: 10),
      decoration: BoxDecoration(
        color: context.colors.backgroundColor,
        border: Border.all(color: context.colors.textFieldBorderEnabled),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
      child: Column(
        children: [
          Row(
            children: [Text("Дети до ${TextUtils.getAdultAge(minAdultAge ?? 2)}"), const Spacer(), const Text("бесплатно")],
          ),
          if (maxStayDuration != null)
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 6),
              child: Container(
                decoration: DottedDecoration(
                  shape: Shape.line,
                  linePosition: LinePosition.bottom,
                  color: context.colors.lightDashBorder,
                ),
              ),
            ),
          if (maxStayDuration != null)
            Row(
              children: [
                const Text("Пребывание в зале"),
                const Spacer(),
                Text("до ${tryParseTime("${maxStayDuration!}.0")?.inHours ?? 0} часов")
              ],
            ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
