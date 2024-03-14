import 'package:everylounge/presentation/screens/home/widget/add_card_modal.dart';
import 'package:everylounge/presentation/screens/home/widget/authorize_modal.dart';
import 'package:everylounge/presentation/screens/home_bottom_navigation/widget/rating/rating_app_modal.dart';
import 'package:everylounge/presentation/screens/home_bottom_navigation/widget/update_app_modal.dart';
import 'package:flutter/material.dart';

class ModalManager {
  final List<Function> _modalQueue = [];
  bool _isModalOpen = false;

  void openAuthModal(BuildContext context) {
    _enqueueModal(() {
      return showAuthorizeModal(context);
    });
  }

  void openUpdateModal(
    BuildContext context, {
    required Function updateCallback,
  }) {
    _enqueueModal(() {
      return showUpdateAppModal(context, updateCallback);
    });
  }

  void openRatingModal(BuildContext context) {
    _enqueueModal(() {
      return showRatingAppModal(context);
    });
  }

  void openAddCardModal(BuildContext context, bool hideBanks) {
    _enqueueModal(() {
      return showAddCardModal(context, hideBanks, false);
    });
  }

  void _enqueueModal(Future Function() execute) {
    if (_isModalOpen) {
      _modalQueue.add(() => _openModal(execute));
    } else {
      _openModal(execute);
    }
  }

  void _openModal(Future Function() execute) {
    _isModalOpen = true;
    execute().then(
      (_) {
        _isModalOpen = false;
        if (_modalQueue.isNotEmpty) {
          final nextModal = _modalQueue.removeAt(0);
          nextModal();
        }
      },
    );
  }
}
