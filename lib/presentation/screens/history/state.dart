import 'package:equatable/equatable.dart';
import 'package:everylounge/domain/entities/order/order.dart';

class HistoryState extends Equatable {
  final bool isLoading;
  final bool isLoadingNewPage;
  final int currentPage;
  final int totalPages;
  final List<Order> ordersList;
  final bool isFirstOpenHistoryScreen;

  const HistoryState({
    this.ordersList = const [],
    this.isLoading = true,
    this.isLoadingNewPage = false,
    this.currentPage = 1,
    this.totalPages = 1,
    this.isFirstOpenHistoryScreen = false,
  });

  @override
  List<Object?> get props => [
        isLoading,
        ordersList,
        isLoadingNewPage,
        currentPage,
        totalPages,
        isFirstOpenHistoryScreen,
      ];

  HistoryState copyWith({
    List<Order>? ordersList,
    bool? isLoading,
    bool? isLoadingNewPage,
    int? currentPage,
    int? totalPages,
    bool? isFirstOpenHistoryScreen,
  }) {
    return HistoryState(
      isLoading: isLoading ?? this.isLoading,
      ordersList: ordersList ?? this.ordersList,
      isLoadingNewPage: isLoadingNewPage ?? this.isLoadingNewPage,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      isFirstOpenHistoryScreen: isFirstOpenHistoryScreen ?? this.isFirstOpenHistoryScreen,
    );
  }
}
