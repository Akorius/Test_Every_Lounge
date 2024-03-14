import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class InfoItemWidget extends StatelessWidget {
  final String infoIcons;
  final AutoSizeGroup? groupText;
  final Function? callback;

  const InfoItemWidget({required this.infoIcons, this.groupText, this.callback, super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: <Widget>[
        Image.asset(
          infoIcons,
          alignment: Alignment.center,
        ),
        // Positioned(
        //   bottom: 40,
        //   child: Container(
        //     height: 134,
        //     width: MediaQuery.of(context).size.width - 80,
        //     constraints: const BoxConstraints(minWidth: 184),
        //     child: Column(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       crossAxisAlignment: CrossAxisAlignment.center,
        //       children: [
        //         SizedBox(
        //           height: 66,
        //           child: Center(
        //             child: AutoSizeText(
        //               infoText,
        //               textAlign: TextAlign.center,
        //               group: groupText,
        //               maxLines: 3,
        //               minFontSize: 6,
        //               style: context.textStyles.textLargeRegular(color: context.colors.loginInfoCardText),
        //             ),
        //           ),
        //         ),
        //         const SizedBox(
        //           height: 24,
        //         ),
        //         Container(
        //           height: 44,
        //           constraints: const BoxConstraints(minWidth: 184),
        //           child: OutlinedButton(
        //             onPressed: () => callback.call(),
        //             style: OutlinedButton.styleFrom(
        //               side: BorderSide(
        //                 color: context.colors.buttonInfoBorder,
        //               ),
        //               shape: RoundedRectangleBorder(
        //                 borderRadius: BorderRadius.circular(16),
        //               ),
        //             ),
        //             child: Text(
        //               "Выбрать бизнес-зал",
        //               textAlign: TextAlign.center,
        //               style: context.textStyles.loginInfoButtonText(
        //                 color: context.colors.buttonInfoText,
        //               ),
        //             ),
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
