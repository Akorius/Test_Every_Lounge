import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/screens/setting_profile/cubit.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Permission extends StatelessWidget {
  const Permission({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Действия',
            style: context.textStyles.negativeButtonText(
              color: context.colors.buttonPressed,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 16, bottom: 24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: context.colors.buttonPressedText,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 3,
                ),
              ],
            ),
            child: Theme(
              data: Theme.of(context).copyWith(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ),
              child: InkWell(
                onTap: () {
                  context.read<ProfileSettingsCubit>().requestPermission(context);
                },
                child: ListTile(
                  title: Text(
                    'Разрешенные вами',
                    style: AppTextStyles.textLargeRegular(
                      color: context.colors.appBarBackArrowColor,
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: context.colors.textNormalGrey,
                    size: 15,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
