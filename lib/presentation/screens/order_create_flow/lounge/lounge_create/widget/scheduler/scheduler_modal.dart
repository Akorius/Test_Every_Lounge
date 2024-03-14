import 'package:everylounge/domain/entities/order/schedule.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/screens/order_create_flow/lounge/lounge_create/widget/scheduler/scheduler_parser.dart';
import 'package:everylounge/presentation/screens/order_create_flow/lounge/lounge_create/widget/scheduler/scheduler_row.dart';
import 'package:flutter/material.dart';

void showSchedulerModal(BuildContext context, List<Schedule>? scheduleList) {
  Map<String, List<String>> map = SchedulerParser.parserSchedule(scheduleList!);
  showModalBottomSheet(
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
    ),
    backgroundColor: context.colors.bottomSheetBackgroundColor,
    context: context,
    builder: (BuildContext buildContext) {
      return Wrap(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              Container(
                height: 5,
                width: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: context.colors.cardSelectedBorder,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 28, right: 28, top: 16),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    'Время работы',
                    style: context.textStyles.h2(color: context.colors.textDefault),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 28, right: 28, top: 14, bottom: 28),
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: map.length + 1,
                  itemBuilder: (BuildContext context, int i) {
                    if (i == 0) {
                      return const SchedulerRow(isTitle: true);
                    } else {
                      var day = map.keys.toList()[i - 1];
                      var validFrom = map[day]?.first;
                      var validTill = ((map[day]?.length ?? 0) > 1) ? map[day]?.last : '';
                      return SchedulerRow(day: day, validFrom: validFrom, validTill: validTill);
                    }
                  },
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(
                    color: context.colors.buttonEnabledText,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: context.colors.buttonDisabled),
                  ),
                  child: Center(
                    child: Text(
                      'Понятно',
                      style: context.textStyles.negativeButtonText(color: context.colors.buttonNegativeText),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 21,
              )
            ],
          ),
        ],
      );
    },
  );
}
