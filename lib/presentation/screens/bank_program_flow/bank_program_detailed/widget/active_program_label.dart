import 'package:everylounge/core/di/get_it.dart';
import 'package:everylounge/domain/usecases/setting_profile/find_out_hide_params.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/widgets/loaders/circular.dart';
import 'package:flutter/material.dart';

class ActiveProgramLabel extends StatelessWidget {
  final String text;
  final bool isLoading;

  const ActiveProgramLabel({
    Key? key,
    required this.text,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.black.withOpacity(0.1),
      ),
      child: Center(
        child: isLoading
            ? const Padding(
                padding: EdgeInsets.all(8),
                child: AppCircularProgressIndicator(),
              )
            : Text(
                //TODO убрать гетИт из виджета
                getIt<FindOutHideParamsUseCase>().detailedActiveCard() ? "Активная карта" : text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.textStyles.textNormalRegular(color: context.colors.textNormalLink),
              ),
      ),
    );
  }
}
