import 'package:everylounge/domain/entities/lounge/service_search_type.dart';
import 'package:everylounge/presentation/common/assets/assets.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/screens/order_create_flow/search_airport/cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class InfoWarning extends StatelessWidget {
  final ServiceSearchType serviceType;

  const InfoWarning(this.serviceType, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 16),
      decoration: BoxDecoration(
          color: context.colors.searchAirportWarningBackground,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20))),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: Text(
                  serviceType == ServiceSearchType.premium
                      ? "Отображаются только аэропорты\nгде доступны премиальные сервисы"
                      : 'Отображаются только аэропорты\nгде доступны бизнес-залы',
                  style: context.textStyles.textNormalRegular(),
                ),
              ),
              GestureDetector(
                onTap: () {
                  context.read<SearchAirportCubit>().changeShowAlert(false);
                },
                child: SvgPicture.asset(
                  AppImages.closeBold,
                  height: 24,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
