import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:flutter/material.dart';

class Switcher extends StatelessWidget {
  const Switcher({super.key}) : super();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: const Color(0xFFEDF3FC), borderRadius: BorderRadius.circular(30)),
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(3),
      child: TabBar(
        unselectedLabelColor: Colors.redAccent,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(borderRadius: BorderRadius.circular(50), color: Colors.white),
        tabs: [
          _item(context: context, title: "Доступные"),
          _item(context: context, title: "Недавние"),
        ],
      ),
    );
  }
}

Widget _item({required BuildContext context, required String title}) {
  return Tab(
    height: 40,
    child: Text(
      title,
      style: context.textStyles.textNormalRegular(color: context.colors.buttonEnabled),
    ),
  );
}
