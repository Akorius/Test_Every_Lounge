import 'package:everylounge/domain/entities/file/pdf_data.dart';
import 'package:everylounge/presentation/common/router/routes.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/screens/setting_profile/cubit.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class Rules extends StatelessWidget {
  const Rules({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> title = ['Правила программы', 'Договор-оферта'];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Правила',
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
                      final String link = context.read<ProfileSettingsCubit>().getLink(index);
                      context.push(AppRoutes.pdfViewScreen, extra: PdfData(title: title[index], link: link));
                    },
                    child: ListTile(
                      title: Text(
                        title[index],
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
                );
              },
              itemCount: 2,
            ),
          ),
        ],
      ),
    );
  }
}
