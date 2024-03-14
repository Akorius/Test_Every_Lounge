import 'package:everylounge/domain/entities/order/schedule.dart';
import 'package:everylounge/presentation/common/assets/assets.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/screens/order_create_flow/lounge/lounge_create/widget/scheduler/scheduler_modal.dart';
import 'package:everylounge/presentation/screens/order_create_flow/lounge/lounge_create/widget/scheduler/scheduler_parser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Scheduler extends StatelessWidget {
  final List<Schedule>? scheduleList;

  const Scheduler(
    this.scheduleList, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showSchedulerModal(context, scheduleList),
      child: Row(
        children: [
          SvgPicture.asset(AppImages.clock),
          const SizedBox(
            width: 6,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              SchedulerParser.getTimeSchedulerMainTitle(scheduleList),
              style: TextStyle(
                shadows: [Shadow(color: context.colors.textNormalLink, offset: const Offset(0, -4))],
                fontSize: 14,
                color: Colors.transparent,
                decoration: TextDecoration.underline,
                decorationColor: context.colors.textNormalLink,
                decorationThickness: 1,
                decorationStyle: TextDecorationStyle.dashed,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
