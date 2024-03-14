import 'package:cached_network_image/cached_network_image.dart';
import 'package:everylounge/data/clients/api_client.dart';
import 'package:everylounge/domain/entities/login/user.dart';
import 'package:everylounge/presentation/common/assets/assets.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  const Avatar({
    super.key,
    this.user,
    this.size,
    this.withBorder = true,
  });

  final User? user;
  final double? size;
  final bool withBorder;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: withBorder
          ? BoxDecoration(
              border: Border.all(
                width: 2.0,
                color: context.colors.profileAvatarBorder,
              ),
              shape: BoxShape.circle)
          : null,
      child: ClipOval(
        child: SizedBox.fromSize(
          size: Size.fromRadius(size ?? 42),
          child: user?.profile.avatar != 0
              ? CachedNetworkImage(imageUrl: "${ApiClient.filesUrl}${user?.profile.avatar}", fit: BoxFit.cover)
              : Image.asset(AppImages.avatarLogo),
        ),
      ),
    );
  }
}
