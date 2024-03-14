import 'package:everylounge/domain/entities/common/platform.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/screens/profile/cubit.dart';
import 'package:everylounge/presentation/screens/profile/state.dart';
import 'package:everylounge/presentation/screens/profile/widget/avatar.dart';
import 'package:everylounge/presentation/screens/profile/widget/modals/add_photo_modal.dart';
import 'package:everylounge/presentation/screens/profile/widget/modals/change_photo_modal.dart';
import 'package:everylounge/presentation/widgets/loaders/circular.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileArea extends StatelessWidget {
  final ProfileState state;

  const ProfileArea({
    Key? key,
    required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.colors.backgroundColor,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            color: context.colors.profileBackgroundColor,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            )),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 8),
            state.isPhotoInteraction
                ? Container(
                    decoration: BoxDecoration(
                        color: context.colors.cardBackground,
                        border: Border.all(width: 2.0, color: context.colors.profileAvatarBorder),
                        shape: BoxShape.circle),
                    child: ClipOval(
                      child: SizedBox.fromSize(
                        size: const Size.fromRadius(42), // Image radius
                        child: const AppCircularProgressIndicator(),
                      ),
                    ),
                  )
                : GestureDetector(
                    onTap: () {
                      if (PlatformWrap.isWeb) return;
                      (state.user?.profile.avatar != 0)
                          ? showChangePhotoModal(
                              context,
                              state.user,
                              callbackAddPhoto: () => context.read<ProfileCubit>().getPhotoFromGallery(context),
                              callbackRemovePhoto: () => context.read<ProfileCubit>().removePhoto(),
                            )
                          : showAddPhotoModal(
                              context,
                              callbackAddPhoto: () => context.read<ProfileCubit>().getPhotoFromGallery(context),
                            );
                    },
                    child: Avatar(user: state.user),
                  ),
            const SizedBox(height: 8),
            Text(
                textAlign: TextAlign.center,
                "${state.user?.profile.firstName} ${state.user?.profile.lastName}",
                style: context.textStyles.header700(color: context.colors.textLight)),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
