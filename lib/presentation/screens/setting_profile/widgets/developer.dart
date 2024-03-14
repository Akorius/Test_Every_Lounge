import 'package:debug_overlay/debug_overlay.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/screens/setting_profile/cubit.dart';
import 'package:everylounge/presentation/screens/setting_profile/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Developer extends StatefulWidget {
  final ProfileSettingsState? state;

  const Developer({Key? key, required this.state}) : super(key: key);

  @override
  State<Developer> createState() => _DeveloperState();
}

class _DeveloperState extends State<Developer> {
  List<String> title = ['Network logs', 'Widget inspector', 'Окружение', 'Рублевая оплата'];
  List<String> subtitle = ['', '', 'FIREBASE', ''];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Меню разработчика',
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
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                  ),
                  child: InkWell(
                    onTap: () {
                      if (index == 0) {
                        DebugOverlay.show();
                      }
                      if (index == 3) {
                        context.read<ProfileSettingsCubit>().togglePayWithOneRuble();
                      }
                    },
                    child: ListTile(
                      title: Text(
                        title[index],
                        style: AppTextStyles.textLargeRegular(
                          color: context.colors.appBarBackArrowColor,
                        ),
                      ),
                      subtitle: (index == 3)
                          ? Text(
                              widget.state!.isRuble.toString().toUpperCase(),
                              style: AppTextStyles.textLargeRegular(
                                color: context.colors.buttonEnabled,
                              ),
                            )
                          : null,
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: context.colors.textNormalGrey,
                        size: 15,
                      ),
                    ),
                  ),
                );
              },
              itemCount: 4,
            ),
          ),
        ],
      ),
    );
  }
}
