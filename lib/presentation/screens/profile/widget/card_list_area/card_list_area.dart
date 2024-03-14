import 'package:everylounge/core/config.dart';
import 'package:everylounge/presentation/screens/profile/state.dart';
import 'package:everylounge/presentation/screens/profile/widget/card_list_area/card_list.dart';
import 'package:everylounge/presentation/screens/profile/widget/card_list_area/card_list_alfa.dart';
import 'package:everylounge/presentation/screens/profile/widget/card_list_area/card_list_empty.dart';
import 'package:flutter/material.dart';

class CardsListArea extends StatelessWidget {
  final ProfileState state;

  const CardsListArea({
    Key? key,
    required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (alfaBuild) return const CardListAlfa();
    if ((state.activeBankProgramsList?.isEmpty ?? true) && (state.inactiveBankProgramsList?.isEmpty ?? true)) {
      return EmptyCardArea(state: state);
    } else {
      return CardsList(state: state);
    }
  }
}
