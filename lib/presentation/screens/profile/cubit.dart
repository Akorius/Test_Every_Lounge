import 'dart:async';

import 'package:everylounge/core/di/get_it.dart';
import 'package:everylounge/data/constants/event_description.dart';
import 'package:everylounge/domain/entities/bank/card.dart';
import 'package:everylounge/domain/entities/login/user.dart';
import 'package:everylounge/domain/usecases/file/file_upload.dart';
import 'package:everylounge/domain/usecases/metrics/appMetrica/metrics.dart';
import 'package:everylounge/domain/usecases/metrics/appMetrica/metrics_event_type.dart';
import 'package:everylounge/domain/usecases/privileges/get_cards.dart';
import 'package:everylounge/domain/usecases/setting_profile/find_out_hide_params.dart';
import 'package:everylounge/domain/usecases/user/get_user.dart';
import 'package:everylounge/domain/usecases/user/update_user.dart';
import 'package:everylounge/presentation/common/cubit/attach_card/cubit.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/screens/profile/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetUserUseCase _getUserUseCase = getIt();
  final GetCardsUseCase _getCardsUseCase = getIt();
  final FileUploadUseCase _fileUploadUseCase = getIt();
  final UpdateUserUseCase _updateUserUseCase = getIt();
  final FindOutHideParamsUseCase _findOutHideParamsUseCase = getIt();
  final MetricsUseCase _metricsUseCase = getIt<MetricsUseCase>();

  late final StreamSubscription<User> _userStreamSubscription;
  late final StreamSubscription<List<BankCard>> _cardsStreamSubscription;

  final AttachCardCubit attachCardCubit = getIt();

  ProfileCubit() : super(const ProfileState()) {
    onCreate();
  }

  Stream<String> get messageStream => _messageController.stream;
  final _messageController = StreamController<String>();

  void onCreate() async {
    _metricsUseCase.sendEvent(event: eventName[profileClick]!, type: MetricsEventType.click);
    attachCardCubit.listen(
      (event) => emit(state.copyWith(isCardAttaching: event.cardAttaching)),
      _messageController.add,
    );
    emit(state.copyWith(hideBanks: _findOutHideParamsUseCase.isHideBanksIOS()));
    _userStreamSubscription = _getUserUseCase.stream.listen((user) {
      emit(state.copyWith(user: user));
    });
    _cardsStreamSubscription = _getCardsUseCase.stream.listen((cards) {
      emit(state.copyWith(
        activeBankProgramsList: cards.where((element) => element.isActive).toList(),
        inactiveBankProgramsList: cards.where((element) => !element.isActive).toList(),
        isLoading: false,
      ));
    });
  }

  getPhotoFromGallery(BuildContext context) async {
    var titleColors = context.colors.profileBackgroundColor;
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: image.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
        ],
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: '',
            toolbarColor: titleColors,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
          ),
          IOSUiSettings(
            title: '',
          ),
        ],
      );
      if (croppedFile != null) {
        emit(state.copyWith(isPhotoInteraction: true));
        final uploadResult = await _fileUploadUseCase.call(croppedFile.path);
        if (uploadResult.isSuccess) {
          await _updateUserUseCase.update(avatarId: uploadResult.value.id);
          await _getUserUseCase.get();
        } else {
          _messageController.add(uploadResult.message);
          _metricsUseCase.sendEvent(event: uploadResult.message, type: MetricsEventType.alert);
        }
      }
    }
    emit(state.copyWith(isPhotoInteraction: false));
  }

  updateCards() async {
    await _getUserUseCase.get();
    await _getCardsUseCase.get();
  }

  void removePhoto() async {
    emit(state.copyWith(isPhotoInteraction: true));
    final result = await _updateUserUseCase.update(avatarId: 0);
    if (!result.isSuccess) {
      _messageController.add(result.message);
      _metricsUseCase.sendEvent(event: result.message, type: MetricsEventType.alert);
    } else {
      await _getUserUseCase.get();
    }
    emit(state.copyWith(isPhotoInteraction: false));
  }

  sendEventClick(String event) {
    _metricsUseCase.sendEvent(event: event, type: MetricsEventType.click);
  }

  @override
  Future<void> close() {
    return Future.wait([
      _userStreamSubscription.cancel(),
      _cardsStreamSubscription.cancel(),
      attachCardCubit.unListen(),
    ]).then((value) => super.close());
  }
}
