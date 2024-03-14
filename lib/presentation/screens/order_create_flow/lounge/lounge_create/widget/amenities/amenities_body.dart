import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/screens/order_create_flow/lounge/lounge_create/widget/amenities/amenities_list.dart';
import 'package:everylounge/presentation/screens/order_create_flow/lounge/lounge_create/widget/text_with_dotted.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

class AmenitiesBody extends StatelessWidget {
  const AmenitiesBody(
    this.isAuth, {
    super.key,
  });

  final bool isAuth;

  @override
  Widget build(BuildContext context) {
    return isAuth
        ? ExpandableNotifier(
            child: Column(
              children: [
                Expandable(
                  collapsed: ExpandableButton(
                    child: const TextWithDottedBorder("Доступно в бизнес-зале"),
                  ),
                  expanded: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ExpandableButton(
                        child: const TextWithDottedBorder("Свернуть информацию"),
                      ),
                      const AmenitiesListWidget()
                    ],
                  ),
                ),
              ],
            ),
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8, top: 24),
                child: Text(
                  "Доступно в бизнес-зале",
                  style: context.textStyles.textLargeBold(color: context.colors.textBlue),
                ),
              ),
              const AmenitiesListWidget(),
            ],
          );
  }
}
