import 'package:everylounge/domain/entities/order/order.dart';
import 'package:everylounge/presentation/common/sticky_grouped_list/src/sticky_grouped_list.dart';
import 'package:everylounge/presentation/common/sticky_grouped_list/src/sticky_grouped_list_order.dart';
import 'package:everylounge/presentation/common/textstyles/textstyles.dart';
import 'package:everylounge/presentation/common/theme/theme.dart';
import 'package:everylounge/presentation/screens/history/cubit.dart';
import 'package:everylounge/presentation/screens/history/widgets/history_item.dart';
import 'package:everylounge/presentation/screens/history/widgets/refresher.dart';
import 'package:everylounge/presentation/widgets/loaders/app_loader.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HistoryList extends StatefulWidget {
  final List<Order>? ordersList;
  final bool isLoadingNewPage;

  const HistoryList({
    Key? key,
    required this.ordersList,
    required this.isLoadingNewPage,
  }) : super(key: key);

  @override
  State<HistoryList> createState() => _HistoryListState();
}

class _HistoryListState extends State<HistoryList> {
  final ScrollController _scrollController = ScrollController();
  bool isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScrollListener);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.backgroundColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(26),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          top: 8,
          left: 16,
          right: 16,
        ),
        child: ScrollConfiguration(
          behavior: MyBehavior(),
          child: Refresher(
            wchild: CustomScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: StickyGroupedListView<Order, DateTime>(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    stickyHeaderBackgroundColor: context.colors.backgroundColor,
                    elements: widget.ordersList!,
                    groupBy: (Order e) => DateTime(e.createdAt.year, e.createdAt.month, e.createdAt.day),
                    groupSeparatorBuilder: (Order element) => Padding(
                      padding: const EdgeInsets.only(bottom: 8.0, top: 16),
                      child: Text(
                        DateFormat('d MMMM y', 'ru_RU').format(element.createdAt),
                        style: context.textStyles.negativeButtonText(
                          color: context.colors.textHistoryDate,
                        ),
                      ),
                    ),
                    groupComparator: (a, b) => a.compareTo(b),
                    order: StickyGroupedListOrder.DESC,
                    itemBuilder: (context, order) {
                      return HistoryItem(order: order);
                    },
                  ),
                ),
                if (widget.isLoadingNewPage)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(right: 15, bottom: 15),
                      child: EveryAppLoader(size: 32),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScrollListener);
    super.dispose();
  }

  void _onScrollListener() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    const delta = 100;
    if (maxScroll - currentScroll <= delta) {
      context.read<HistoryCubit>().getNextOrdersPage();
    }
  }
}

//класс, убирающий ScrollGlow без изменения физики действия списка
class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
