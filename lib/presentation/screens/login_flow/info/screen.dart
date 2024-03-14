import 'dart:async';

import 'package:everylounge/presentation/common/assets/assets.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/screens/login_flow/info/widget/info_item.dart';
import 'package:everylounge/presentation/widgets/scaffold/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginInfoScreen extends StatelessWidget {
  static const String path = "login_info";

  const LoginInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final infoIcons = [
      AppImages.firstInfoBackground,
      AppImages.secondInfoBackground,
      AppImages.thirdInfoBackground,
    ];
    return SafeArea(
      child: CommonScaffold(
        messageStream: StreamController<String>().stream,
        onMessage: (message) {},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 22, bottom: 20),
              child: SvgPicture.asset(AppImages.infoLogo),
            ),
            Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 18),
                child: Text(
                  "С Every Lounge\nвы сможете:",
                  textAlign: TextAlign.center,
                  style: context.textStyles.h1(),
                )),
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: infoIcons.length + 1,
                itemBuilder: (context, i) {
                  if (i == infoIcons.length) {
                    return Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InfoWidget(
                            textList: [
                              Text('© ООО «ЭВРИ ЛАУНЖ»', style: context.textStyles.textSmallBold(color: context.colors.textBlue)),
                              const SizedBox(height: 10),
                              Text("ОГРН: 1227700253461\n117218, Москва, Большая Черёмушкинская,\nд. 34, офис М216",
                                  style: context.textStyles.textNormalRegular(color: context.colors.textBlue)),
                              const SizedBox(height: 10),
                              GestureDetector(
                                onTap: () => _launchEmail(email),
                                child: Text("support@everylounge.ru",
                                    style: context.textStyles.textNormalRegular(color: context.colors.textBlue)),
                              ),
                              const SizedBox(height: 10),
                              GestureDetector(
                                onTap: () => _launchPhone(phoneNumber),
                                child: Text("+7 495 795-00-77",
                                    style: context.textStyles.textNormalRegular(color: context.colors.textBlue)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          InfoWidget(
                            textList: [
                              Text('Сервис по повышению класса обслуживания авиаперелета (апгрейд) предоставляется',
                                  style: context.textStyles.textNormalRegular(color: context.colors.textBlue)),
                              Text("ООО «АГЕНТ.РУ ОНЛАЙН»",
                                  style: context.textStyles.textSmallBold(color: context.colors.textBlue)),
                              const SizedBox(height: 10),
                              Text("ОГРН: 1157746720229\n125167, город Москва, Ленинградский пр-кт, д. 37 к. 12, этаж 6",
                                  style: context.textStyles.textNormalRegular(color: context.colors.textBlue)),
                            ],
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                      child: InfoItemWidget(
                        infoIcons: infoIcons[i],
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String get email => "support@everylounge.ru";

  String get phoneNumber => '+74957950077';

  void _launchPhone(String phoneNumber) async {
    final url = 'tel:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  void _launchEmail(String email) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: email,
    );
    final String formattedUri = emailLaunchUri.toString();
    if (await canLaunch(formattedUri)) {
      await launch(formattedUri);
    }
  }
}

class InfoWidget extends StatelessWidget {
  final List<Widget> textList;

  const InfoWidget({super.key, required this.textList});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: context.colors.switcherColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: textList,
      ),
    );
  }
}
