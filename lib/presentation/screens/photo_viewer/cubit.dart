import 'dart:async';

import 'package:everylounge/presentation/screens/photo_viewer/state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PhotoViewerCubit extends Cubit<PhotoViewerState> {
  final List<String> photoIdsList;
  final String? currentId;

  PhotoViewerCubit(this.photoIdsList, this.currentId)
      : super(
          PhotoViewerState(idsList: photoIdsList, currentPage: currentId == null ? 0 : photoIdsList.indexOf(currentId)),
        );

  Stream<String> get messageStream => _messageController.stream;
  final _messageController = StreamController<String>();

  void onPageChanged(int page) {
    emit(state.copyWith(currentPage: page));
  }

  @override
  Future<void> close() async {
    return super.close();
  }
}
