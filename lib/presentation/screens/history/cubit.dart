import 'dart:async';

import 'package:everylounge/core/di/get_it.dart';
import 'package:everylounge/domain/entities/common/result.dart';
import 'package:everylounge/domain/entities/order/order.dart';
import 'package:everylounge/domain/entities/order/order_status.dart';
import 'package:everylounge/domain/entities/order/order_type.dart';
import 'package:everylounge/domain/usecases/order/get_orders.dart';
import 'package:everylounge/presentation/screens/history/state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HistoryCubit extends Cubit<HistoryState> {
  final GetUserOrdersUseCase _orderUseCase = getIt();
  StreamSubscription<List<Order>>? orderSubscription;
  final int countItems = 10;

  HistoryCubit() : super(const HistoryState()) {
    orderSubscription = _orderUseCase.stream.listen((orders) {
      orders.removeWhere(
        (element) => element.type == OrderType.upgrade && !toShowUpgradeStatusesInHistory.contains(element.status),
      );
      emit(state.copyWith(ordersList: orders.reversed.toList()));
    });
  }

  Future<void> getOrderList({bool isBottomEvent = false}) async {
    if (isBottomEvent && state.isFirstOpenHistoryScreen) return;
    bool needRefresh = !isBottomEvent;
    final Result<OrderData> data = await _orderUseCase.get(
      limit: countItems,
      page: state.currentPage,
      needRefresh: needRefresh,
    );
    if (needRefresh) {
      _orderUseCase.get(limit: 3, statuses: toShowOrderStatusesInActive);
    }
    final double count = data.value.totalItems / countItems;
    int totalPages = (count % 1) == 0 ? count.toInt() : count.toInt() + 1;
    emit(state.copyWith(isLoading: false, totalPages: totalPages, currentPage: 1, isFirstOpenHistoryScreen: true));
  }

  Future<void> getNextOrdersPage() async {
    if (state.isLoadingNewPage || state.currentPage >= state.totalPages) return;
    final nextPage = state.currentPage + 1;
    emit(state.copyWith(isLoadingNewPage: true));
    await _orderUseCase.getNextOrdersPage(page: nextPage, limit: countItems);
    emit(state.copyWith(isLoadingNewPage: false, currentPage: nextPage));
  }

  Stream<String> get messageStream => _messageController.stream;
  final _messageController = StreamController<String>();

  @override
  Future<void> close() async {
    await orderSubscription?.cancel();
    return super.close();
  }
}
